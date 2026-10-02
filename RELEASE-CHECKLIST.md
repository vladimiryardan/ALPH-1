# Public website release candidate

Host-independent preparation only. The public hostname is `atticladderph.com`,
as referenced by the site's production URLs. The server/provider, deployment
method, paths, service names and active server configuration are not confirmed
by repository evidence. Nothing here deploys.

## Build and review

- Run `python scripts/build_release.py` from the repository with Python 3.9+.
  It creates a uniquely named directory under the OS temp directory outside the
  web root, containing `public-site.zip` and `release-manifest.json`.
- Keep both artifacts together in approved private release storage; temp storage
  is not a durable backup. Deploy only the ZIP contents, never the manifest.
- The ZIP uses an explicit public-page allowlist, required shared templates,
  `Content/gallery-alt.json`, CSS/JS and filtered image assets including the
  Git-ignored `gallery/`. Missing gallery images fail the build. Before approval,
  compare every `gallery/` path in the manifest with the content owner's approved
  publication inventory; the builder includes every matching image below
  `gallery/` and does not enforce approval itself. Future required assets need
  allowlist updates.
- The manifest records each packaged file's SHA256 and size, ZIP SHA256, Git HEAD,
  working-tree dirty state and builder hash. The package snapshots current files,
  including uncommitted work; review the diff before approval. Do not edit source
  while building. Rebuild after approved changes and verify the final ZIP hash.
- Excluded by the builder's explicit allowlist: admin pages and diagnostic
  endpoints (`mail-test.cfm`, `recaptcha-test.cfm`, `admin/db_test.cfm`),
  environment files, server config, editor/Git files, SQL, tooling, logs,
  documents, `gallery-backups/`, and customer uploads including
  `uploads/quote-requests/`. `inc_local_dev.cfm` is included as the request-level
  development guard, not as a diagnostic endpoint. Inspect the final ZIP
  inventory and reject unexpected paths before release. Admin release scope
  remains pending; this candidate has no admin UI.

## Production prerequisites (values stay in the environment)

- Confirm the target CFML/Lucee version and datasource named `atticladderph`.
  Provision datasource credentials through the host's protected configuration.
- Supply environment names `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`,
  `SMTP_PASSWORD`, `SMTP_SSL`, `SMTP_TLS`, `SMTP_FROM`, `SMTP_TO`, `SMTP_REPLY_TO`,
  `RECAPTCHA_SITE_KEY`, `RECAPTCHA_SECRET_KEY`, and `APP_ENV`.
  Set `APP_ENV` to production, never development. Preserve the tested SMTP values
  and the existing TLS/SSL interpretation; this release does not change them.
- `ADMIN_TOTP_SECRET` is optional for this public-only package; decide admin
  scope before deploying admin separately. Never copy environment files into
  the ZIP or source-control. `ZvladSecureFolderIgnore/start-prod.sh` and its
  production environment file are Git-ignored and excluded from the release ZIP;
  deliver/provision the launcher separately through the approved secure
  operations channel. Never substitute the development environment or launcher.
- Configure reCAPTCHA for the production hostname, HTTPS, database connectivity,
  SMTP connectivity and restricted writable `uploads/quote-requests/` storage.
  Block HTTP access and script execution in customer-upload storage at the host.
- Confirm existing remote diagnostics and private files are removed or denied:
  omission from this ZIP does not remove files already on the server. Check
  `mail-test.cfm`, `recaptcha-test.cfm`, `admin/db_test.cfm` and admin setup tools.
- Implement host-specific static/missing-route handling using
  [404-DEPLOYMENT.md](404-DEPLOYMENT.md). The public hostname is known, but the
  live front server and deployment method are not; the production mapping and
  its exact configuration command remain blocked until those are confirmed.
  Keep HTTP 404 and the original requested URL.

## Backup, deployment and restoration

Production execution is blocked until the server/provider, operating system,
front server and CFML runtime, deployment method, release/document-root paths,
persistent-data paths, database location, and service names are confirmed.
Record the exact host-specific backup, switch, configuration-validation,
reload/restart and restore commands before authorizing a deployment. Do not infer
them from local CommandBox configuration or project agent context.

Before deployment:

1. Record the currently active release identifier, the approved candidate ZIP
  SHA256, and the operator/time. Store backups in access-controlled storage
  outside the web root and release directory.
2. Back up the currently deployed application code as a code-only snapshot, plus
  a separate copy of active web-server/routing configuration and protected
  runtime configuration. Restrict environment-config backup access; never put
  its values in this checklist, a release manifest, or command output.
3. Separately snapshot the database, current published gallery, uploads and
  quote-request/customer-upload data. Record each persistent path and verify
  that backups can be read. Do not combine mutable data with a code-only
  rollback artifact.
4. Stage the candidate as a new code release, retaining the current release and
  attaching existing persistent storage and protected runtime configuration.
  Do not overwrite live data paths or environment configuration. This candidate
  includes no database migration.
5. Capture and review the host-specific activation and rollback commands before
  switching releases. Validate configuration before any approved reload or
  restart.

Rollback after a code or routing failure:

1. Stop further release actions and record the failure time and current release.
2. Switch the active code release back to the recorded previous code-only
  snapshot using the host's pre-reviewed release-switch procedure. Do not
  restore an old database or replace persistent-data directories.
3. Restore the prior web-server/routing configuration only if this release
  changed it; validate that configuration before the authorized reload/restart.
4. Reattach the current production environment configuration and current
  persistent paths: database, uploads, quote requests, and gallery. Preserve
  every write or file received since deployment. Reconcile gallery files
  individually; never mirror an old gallery backup over newer production work.
5. Verify application health, forms without sending uncontrolled test email,
  and all 404 response classes. Keep the failed release and private diagnostic
  evidence for investigation.

The host-specific commands and exact paths cannot be finalized from repository
evidence. A data restore is not part of routine rollback; any database recovery
requires a separately approved reconciliation plan that preserves writes made
since the backup.

## Release checks and current limits

- Verify Home, About, Gallery, FAQ, Contact, quote and legal pages on mobile and
  desktop; verify CSS/JS and gallery images load, including nested album paths.
- Verify diagnostic endpoints return 404/403 and private files are inaccessible.
- On a confirmed non-production server configuration, verify HTTPS, missing
  CFML, nested missing CFML, missing static-file and extensionless URLs; all
  must return the branded page with HTTP 404, preserve the requested URL, and
  not redirect. The production host-specific configuration remains blocked.
- Successful contact/quote submissions, attachment delivery and inbox receipt are
  **assumed working at the user's direction, not verified end to end**. Carry this
  explicit release limitation until a controlled test is completed. The designated
  customer test address is `vladimiryardan@gmail.com`; avoid unsolicited test sends.
- A source dependency check found `quote_process.cfm` references
  `css/bootstrap.min.css`, which is absent locally. Resolve that existing error-page
  styling dependency or explicitly accept it before release; the builder invents
  no replacement asset. Runtime and production verification are still required.
- Monitor application errors and mail delivery after the release; record outcome.

## Rollback

If core pages or lead delivery fail, switch application code back to the recorded
previous release using the agreed host procedure, restore only changed server
configuration if necessary, then repeat page/form and 404 checks. Preserve all
customer uploads, new requests, newer gallery assets and database writes received
since deployment. Do not restore an old database or mirror an old upload directory
as routine rollback. Any database recovery requires a separately reviewed data
reconciliation plan. Keep the failed artifact and diagnostic evidence privately.
