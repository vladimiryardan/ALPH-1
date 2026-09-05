const fs = require("node:fs/promises");
const path = require("node:path");
const { parseArgs } = require("node:util");
const sharp = require("sharp");

async function main() {
    const { values } = parseArgs({ options: {
        write: { type: "boolean", default: false },
        source: { type: "string", default: path.join(__dirname, "..", "gallery") },
        quality: { type: "string", default: "80" },
        "max-size": { type: "string", default: "1920" },
        help: { type: "boolean", default: false }
    } });
    if (values.help) {
        console.log("Usage: node nodejsScripts/compress-gallery.js [--write] [--quality 80] [--max-size 1920] [--source path]\nDefaults to a read-only preview. Use --max-size 0 to retain dimensions.\nOnly dated (YYYYMMDD) album folders are processed, including nested images.");
        return;
    }
    const quality = Number(values.quality);
    const maxSize = Number(values["max-size"]);
    if (!Number.isInteger(quality) || quality < 1 || quality > 100 ||
        !Number.isInteger(maxSize) || maxSize < 0) {
        throw new Error("Quality must be 1–100; max-size must be a nonnegative integer.");
    }
    const source = path.resolve(values.source);
    const backup = path.join(path.dirname(source), `${path.basename(source)}-backups`,
        `${new Date().toISOString().replace(/[:.]/g, "-")}-${process.pid}`);
    const files = [];
    async function collect(folder) {
        for (const entry of await fs.readdir(folder, { withFileTypes: true })) {
            const file = path.join(folder, entry.name);
            if (entry.isDirectory()) await collect(file);
            else if (entry.isFile() && /\.(jpe?g|png|webp|gif)$/i.test(entry.name)) files.push(file);
        }
    }
    for (const entry of await fs.readdir(source, { withFileTypes: true })) {
        if (entry.isDirectory() && /^\d{8}$/.test(entry.name)) await collect(path.join(source, entry.name));
    }
    files.sort();
    console.log(`${values.write ? "Applying compression" : "Preview (no files changed)"}: ${files.length} images`);
    let originalBytes = 0, savedBytes = 0, changed = 0, failed = 0;
    for (const file of files) {
        const relative = path.relative(source, file);
        let temporary;
        try {
            const input = await fs.readFile(file);
            originalBytes += input.length;
            const metadata = await sharp(input, { animated: true }).metadata();
            if ((metadata.pages || 1) > 1 || metadata.format === "gif") {
                console.log(`Skipped animation/GIF: ${relative}`);
                continue;
            }
            let pipeline = sharp(input).rotate();
            if (maxSize) pipeline = pipeline.resize({ width: maxSize, height: maxSize,
                fit: "inside", withoutEnlargement: true });
            switch (metadata.format) {
                case "jpeg": pipeline = pipeline.jpeg({ quality, mozjpeg: true }); break;
                case "png": pipeline = pipeline.png({ quality, palette: true, compressionLevel: 9 }); break;
                case "webp": pipeline = pipeline.webp({ quality, effort: 6 }); break;
                default: throw new Error(`Unsupported image format: ${metadata.format}`);
            }
            const output = await pipeline.toBuffer();
            if (output.length >= input.length) {
                console.log(`Already smaller: ${relative}`);
                continue;
            }
            if (values.write) {
                const backupFile = path.join(backup, relative);
                await fs.mkdir(path.dirname(backupFile), { recursive: true });
                await fs.writeFile(backupFile, input, { flag: "wx" });
                temporary = `${file}.${process.pid}.compressing`;
                await fs.writeFile(temporary, output, { flag: "wx" });
                await fs.rename(temporary, file);
                temporary = undefined;
            }
            savedBytes += input.length - output.length;
            changed++;
            console.log(`${values.write ? "Compressed" : "Would compress"}: ${relative} (${input.length} -> ${output.length} bytes)`);
        } catch (error) {
            failed++;
            console.error(`Failed: ${relative}: ${error.message}`);
        } finally {
            if (temporary) await fs.rm(temporary, { force: true });
        }
    }
    console.log(`${changed} images ${values.write ? "compressed" : "could be compressed"}; ${(savedBytes / 1048576).toFixed(2)} MB saved (${originalBytes ? (savedBytes / originalBytes * 100).toFixed(1) : 0}%); ${failed} failed.`);
    if (values.write && changed) console.log(`Originals backed up to: ${backup}`);
    if (failed) process.exitCode = 1;
}

main().catch(error => { console.error(error.message); process.exitCode = 1; });
