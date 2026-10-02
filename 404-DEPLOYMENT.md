The branded error page is `/404.cfm`. It sets HTTP status 404 and `noindex, follow`, has no canonical URL, and uses root-relative links so nested missing URLs work. `Application.cfc` renders it from `onMissingTemplate` for missing CFML pages. It is intentionally independent of the shared navigation, database queries and JavaScript.

The repository identifies the public hostname as `atticladderph.com`, but does
not confirm the production provider, operating system, active front server,
CFML upstream/routing configuration, deployment method, or document root. The
host-specific production configuration is therefore **blocked**. Do not apply
the examples below to production until those details are confirmed and the
change is authorized.

To finalize the server instructions, obtain the provider/server identity and
operating system, web-server product/version and active site configuration,
CFML runtime and upstream/handler mapping, document root and release paths,
deployment method, and an approved non-production test origin. Confirm whether
configuration is managed in a server block/site file, `.htaccess`, IIS settings,
or another control plane.

The front-end web server must also send missing static files and extensionless paths to this page using an internal error handler, preserving status 404. Do not redirect to the homepage or return status 200.

Conditional example only, if Apache is confirmed: merge this into the site's
configuration (or `.htaccess` if the host allows `FileInfo` overrides):

```apache
ErrorDocument 404 /404.cfm
```

Conditional example only, if IIS is confirmed: configure the site's **Error
Pages → 404 → Execute a URL on this site** as `/404.cfm`. Preserve existing
CFML handler mappings and confirm that IIS uses the custom error page for
remote requests. Hosting configuration can be locked by the server
administrator; validate the resulting HTTP response rather than relying on the
settings screen alone.

Nginx and CommandBox need their own server error mapping. If either is confirmed,
document the exact active configuration and use the existing CFML
routing/upstream when internally handling `/404.cfm`. Do not guess directives
or paths from this generic note.

After configuring an approved **non-production** server, set `TEST_ORIGIN` to
that test site's origin and check each case. Do not use the production hostname
for validation without explicit deployment authorization:

```sh
curl -i "$TEST_ORIGIN/404.cfm"
curl -i "$TEST_ORIGIN/does-not-exist.cfm"
curl -i "$TEST_ORIGIN/missing/nested/page.cfm"
curl -i "$TEST_ORIGIN/does-not-exist"
curl -i "$TEST_ORIGIN/missing-file.html"
```

Each response must have status **404**, display the branded “We couldn’t find
that page” message, and keep the requested URL without redirecting. The cases
cover a direct CFML missing URL, nested CFML missing URL, extensionless URL, and
static-file URL. Check Home, Gallery, Contact and quote-form links from the
nested URL. Existing pages must still return their normal successful responses.
Keep `/404.cfm` out of the sitemap.

The repository does not provide an approved non-production origin or active
server configuration, so these runtime checks and the production mapping remain
unverified and blocked pending the host details above.

References: [Lucee application events](https://docs.lucee.org/recipes/application-cfc.html), [Apache custom errors](https://httpd.apache.org/docs/current/custom-error.html), [IIS HTTP errors](https://learn.microsoft.com/en-us/iis/configuration/system.webserver/httperrors/).
