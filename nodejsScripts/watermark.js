const fs = require("fs");
const path = require("path");
const sharp = require("sharp");

// ============================================================
// SETTINGS
// ============================================================

// Change this to the folder containing the images
const SOURCE_DIR =
    "C:\\BsiTask\\Attic Ladder\\fb\\GroupsFB\\20240812";

// Watermark image must be in the same folder as watermark.js
const WATERMARK_FILE = path.join(__dirname, "watermark.png");

// Output folder will be created inside SOURCE_DIR
const OUTPUT_DIR = path.join(SOURCE_DIR, "watermarked");

// Watermark width relative to the image width
// 0.22 = 22%
const WATERMARK_SCALE = 0.30;
const WATERMARK_OPACITY = 0.92;
const WATERMARK_POSITION = "centre";

// Watermark transparency
// 0.15 = 15% visibility
//const WATERMARK_OPACITY = 0.15;

// Watermark position
// Options:
// centre, northwest, northeast, southwest, southeast, north, south
//const WATERMARK_POSITION = "centre";

// Distance from the image edges
const WATERMARK_MARGIN = 25;

// Supported image extensions
const IMAGE_EXTENSIONS = /\.(jpg|jpeg|png|webp)$/i;


// ============================================================
// VALIDATION
// ============================================================

if (!fs.existsSync(SOURCE_DIR)) {
    console.error("Source folder does not exist:");
    console.error(SOURCE_DIR);
    process.exit(1);
}

if (!fs.existsSync(WATERMARK_FILE)) {
    console.error("Watermark image was not found:");
    console.error(WATERMARK_FILE);
    process.exit(1);
}

if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}


// ============================================================
// CREATE TRANSPARENT WATERMARK
// ============================================================

async function createWatermarkBuffer(targetWidth) {
    /*
     * The supplied watermark has a white background.
     *
     * This function converts:
     * white pixels -> transparent
     * black pixels -> visible
     * gray pixels  -> partially visible
     */

    const {
        data: grayPixels,
        info
    } = await sharp(WATERMARK_FILE)
        .resize({
            width: targetWidth,
            withoutEnlargement: true
        })
        .grayscale()
        .raw()
        .toBuffer({ resolveWithObject: true });

    const alphaPixels = Buffer.alloc(grayPixels.length);

    for (let i = 0; i < grayPixels.length; i++) {
        const darkness = 255 - grayPixels[i];

        alphaPixels[i] = Math.max(
            0,
            Math.min(
                255,
                Math.round(darkness * WATERMARK_OPACITY)
            )
        );
    }

    const blackPixels = Buffer.alloc(
        info.width * info.height * 3,
        0
    );

    return sharp(blackPixels, {
        raw: {
            width: info.width,
            height: info.height,
            channels: 3
        }
    })
        .joinChannel(alphaPixels, {
            raw: {
                width: info.width,
                height: info.height,
                channels: 1
            }
        })
        .png()
        .toBuffer();
}


// ============================================================
// CALCULATE WATERMARK POSITION
// ============================================================

function calculatePosition(
    imageWidth,
    imageHeight,
    watermarkWidth,
    watermarkHeight
) {
    const margin = WATERMARK_MARGIN;

    switch (WATERMARK_POSITION) {
        case "northwest":
            return {
                left: margin,
                top: margin
            };

        case "northeast":
            return {
                left: imageWidth - watermarkWidth - margin,
                top: margin
            };

        case "southwest":
            return {
                left: margin,
                top: imageHeight - watermarkHeight - margin
            };

        case "southeast":
            return {
                left: imageWidth - watermarkWidth - margin,
                top: imageHeight - watermarkHeight - margin
            };

        case "north":
            return {
                left: Math.round(
                    (imageWidth - watermarkWidth) / 2
                ),
                top: margin
            };

        case "south":
            return {
                left: Math.round(
                    (imageWidth - watermarkWidth) / 2
                ),
                top: imageHeight - watermarkHeight - margin
            };

        case "centre":
        default:
            return {
                left: Math.round(
                    (imageWidth - watermarkWidth) / 2
                ),
                top: Math.round(
                    (imageHeight - watermarkHeight) / 2
                )
            };
    }
}


// ============================================================
// WATERMARK ONE IMAGE
// ============================================================

async function watermarkImage(filename) {
    const inputPath = path.join(SOURCE_DIR, filename);
    const outputPath = path.join(OUTPUT_DIR, filename);

    try {
        const rotatedImage = sharp(inputPath).rotate();
        const metadata = await rotatedImage.metadata();

        if (!metadata.width || !metadata.height) {
            throw new Error(
                "Unable to determine the image dimensions."
            );
        }

        const watermarkWidth = Math.max(
            1,
            Math.round(metadata.width * WATERMARK_SCALE)
        );

        const watermarkBuffer =
            await createWatermarkBuffer(watermarkWidth);

        const watermarkMetadata =
            await sharp(watermarkBuffer).metadata();

        const position = calculatePosition(
            metadata.width,
            metadata.height,
            watermarkMetadata.width,
            watermarkMetadata.height
        );

        await sharp(inputPath)
            .rotate()
            .composite([
                {
                    input: watermarkBuffer,
                    left: Math.max(0, position.left),
                    top: Math.max(0, position.top),
                    blend: "over"
                }
            ])
            .toFile(outputPath);

        console.log("Watermarked: " + filename);
    } catch (error) {
        console.error("Failed: " + filename);
        console.error(error.message);
    }
}


// ============================================================
// PROCESS ALL IMAGES
// ============================================================
async function run() {
    let files = fs
        .readdirSync(SOURCE_DIR, {
            withFileTypes: true
        })
        .filter(function (entry) {
            return (
                entry.isFile() &&
                IMAGE_EXTENSIONS.test(entry.name)
            );
        })
        .map(function (entry) {
            return entry.name;
        })
        .sort(function (a, b) {
            // Natural numeric order:
            // 1.png, 2.png, 3.png, 10.png
            return a.localeCompare(b, undefined, {
                numeric: true,
                sensitivity: "base"
            });
        });

    if (files.length === 0) {
        console.log("No supported images found in:");
        console.log(SOURCE_DIR);
        return;
    }

    console.log("Source folder:");
    console.log(SOURCE_DIR);

    console.log("\nDestination folder:");
    console.log(OUTPUT_DIR);

    console.log("\nImages found: " + files.length);
    console.log(files.join(", "));
    console.log("");

    // If there is only one image, copy it unchanged
    if (files.length === 1) {
        const onlyImage = files[0];

        fs.copyFileSync(
            path.join(SOURCE_DIR, onlyImage),
            path.join(OUTPUT_DIR, onlyImage)
        );

        console.log(
            "Copied without watermark: " + onlyImage
        );

        console.log("\nDone.");
        return;
    }

    const firstImage = files[0];
    const lastImage = files[files.length - 1];

    // Copy first image without watermark
    fs.copyFileSync(
        path.join(SOURCE_DIR, firstImage),
        path.join(OUTPUT_DIR, firstImage)
    );

    console.log(
        "Copied without watermark: " + firstImage
    );

    // Copy last image without watermark
    fs.copyFileSync(
        path.join(SOURCE_DIR, lastImage),
        path.join(OUTPUT_DIR, lastImage)
    );

    console.log(
        "Copied without watermark: " + lastImage
    );

    // Watermark only the images between first and last
    const filesToWatermark = files.slice(1, -1);

    if (filesToWatermark.length === 0) {
        console.log(
            "\nNo images remain to watermark."
        );
    } else {
        console.log(
            "\nImages to watermark: " +
            filesToWatermark.length
        );

        console.log(filesToWatermark.join(", "));
        console.log("");

        for (const file of filesToWatermark) {
            await watermarkImage(file);
        }
    }

    console.log("");
    console.log("Done.");
    console.log("All images saved to:");
    console.log(OUTPUT_DIR);
}


// ============================================================
// START
// ============================================================

run().catch(function (error) {
    console.error("Unexpected error:");
    console.error(error);
    process.exit(1);
});