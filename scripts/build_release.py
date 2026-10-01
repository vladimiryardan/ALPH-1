"""Build a public-site candidate outside the web root; never deploys or reads env files."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from datetime import datetime, timezone
import zipfile

ROOT = Path(__file__).resolve().parents[1]
FILES = """Application.cfc 404.cfm index.cfm about.cfm gallery.cfm faq.cfm
contact.cfm contact.cfc quoterequest.cfm quote_process.cfm quote-thank-you.cfm
privacy.cfm terms-conditions.cfm inc_header.cfm inc_nav.cfm inc_footer.cfm
inc_local_dev.cfm attic_ladder_types.cfm attic_luxury_of_space.cfm
attic_ladder_smart_investment.cfm blog_inc_cta.cfm robots.txt sitemap.xml
Content/gallery-alt.json""".split()
IMAGES = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".avif", ".ico"}
TREES = {"assets": IMAGES, "images": IMAGES, "gallery": IMAGES,
         "css": {".css"}, "js": {".js"}}


def safe_file(relative):
    path = ROOT / relative
    for part in [path, *path.parents]:
        if part == ROOT:
            break
        if part.is_symlink() or (hasattr(part, "is_junction") and part.is_junction()):
            raise ValueError(f"Refusing linked path: {relative}")
    if not path.resolve().is_relative_to(ROOT) or not path.is_file():
        raise ValueError(f"Missing or unsafe required file: {relative}")
    return path


def git(*args):
    return subprocess.check_output(["git", "-C", str(ROOT), *args], text=True).strip()


def main():
    selected = set(FILES)
    for folder, extensions in TREES.items():
        base = ROOT / folder
        if not base.is_dir():
            raise ValueError(f"Required asset directory missing: {folder}")
        for directory, dirs, files in os.walk(base, followlinks=False):
            for name in dirs:
                candidate = Path(directory) / name
                if candidate.is_symlink() or (hasattr(candidate, "is_junction") and candidate.is_junction()):
                    raise ValueError(f"Refusing linked asset directory in {folder}")
            dirs[:] = [name for name in dirs if not name.startswith(".")]
            for name in files:
                if not name.startswith(".") and Path(name).suffix.lower() in extensions:
                    relative = (Path(directory) / name).relative_to(ROOT).as_posix()
                    safe_file(relative)
                    selected.add(relative)
    if not any(name.startswith("gallery/") for name in selected):
        raise ValueError("No gallery images found: restore approved gallery assets before building")
    for name in selected:
        safe_file(name)
    commit = git("rev-parse", "HEAD")
    dirty = bool(git("status", "--porcelain", "--untracked-files=all"))
    output_base = Path(tempfile.gettempdir()).resolve()
    if output_base.is_relative_to(ROOT):
        raise ValueError("System temp directory is inside web root; configure an external TEMP directory")
    output = Path(tempfile.mkdtemp(prefix="atticladder-release-", dir=output_base))
    archive = output / "public-site.zip"
    inventory = []
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as bundle:
        for name in sorted(selected):
            content = safe_file(name).read_bytes()
            info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            bundle.writestr(info, content)
            inventory.append({"path": name, "bytes": len(content), "sha256": hashlib.sha256(content).hexdigest()})
    manifest = {
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "git_commit": commit, "working_tree_dirty": dirty,
        "source": "Current working tree plus allowlisted Git-ignored gallery images; not a clean-commit build",
        "builder_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "archive_sha256": hashlib.sha256(archive.read_bytes()).hexdigest(),
        "files": inventory,
    }
    (output / "release-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(output), "file_count": len(inventory),
                      "gallery_images": sum(f["path"].startswith("gallery/") for f in inventory),
                      "working_tree_dirty": dirty, "archive_sha256": manifest["archive_sha256"]}, indent=2))


if __name__ == "__main__":
    main()
