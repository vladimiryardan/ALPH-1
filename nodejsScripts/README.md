# Gallery compression

From the website root, install the existing dependency if needed:

```powershell
npm install --prefix nodejsScripts
```

Preview compression without changing files:

```powershell
node nodejsScripts/compress-gallery.js
```

Apply compression:

```powershell
node nodejsScripts/compress-gallery.js --write
```

The script processes images recursively inside `gallery/YYYYMMDD` albums. It
keeps filenames and formats so gallery links and alt text continue working.
Defaults: quality 80, maximum width/height 1920 pixels, no enlargement.
JPEG/WebP compression and PNG palette reduction are lossy; metadata is stripped
after applying image orientation. GIFs and animated images are skipped.
Images are replaced only if the encoded result is smaller.

Originals are saved under `gallery-backups/<run timestamp>/`, outside the gallery,
before replacements. Copy these files back into the corresponding gallery paths
to restore them. Avoid repeatedly compressing the same images, which can reduce
quality further.

Options: `--quality 90`, `--max-size 0` (keep dimensions), `--source "path"`
(an alternate gallery root containing dated album folders), `--help`.
Alternate sources have backups in a sibling `<source-name>-backups` directory.
Failures are reported individually and result in a nonzero exit code.
