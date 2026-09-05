The branded error page is `/404.cfm`. It sets HTTP status 404 and `noindex, follow`, has no canonical URL, and uses root-relative links so nested missing URLs work. `Application.cfc` renders it from `onMissingTemplate` for missing CFML pages. It is intentionally independent of the shared navigation, database queries and JavaScript.

The front-end web server must also send missing static files and extensionless paths to this page using an internal error handler, preserving status 404. Do not redirect to the homepage or return status 200.

For Apache, merge this into the site's configuration (or `.htaccess` if the host allows `FileInfo` overrides):

```apache
ErrorDocument 404 /404.cfm
```

For IIS, configure the site's **Error Pages → 404 → Execute a URL on this site** as `/404.cfm`. Preserve existing CFML handler mappings and confirm that IIS uses the custom error page for remote requests. Hosting configuration can be locked by the server administrator; validate the resulting HTTP response rather than relying on the settings screen alone.

Nginx and CommandBox need their own server error mapping. Use the existing CFML routing/upstream when internally handling `/404.cfm`.

After deployment, check each URL with `curl -i`:

```sh
curl -i https://atticladderph.com/404.cfm
curl -i https://atticladderph.com/does-not-exist.cfm
curl -i https://atticladderph.com/missing/nested/page.cfm
curl -i https://atticladderph.com/does-not-exist
curl -i https://atticladderph.com/missing-file.html
```

Each response must have status **404**, display the branded “We couldn’t find that page” message, and keep the requested URL. Check Home, Gallery, Contact and quote-form links from the nested URL. Existing pages must still return their normal successful responses. Keep `/404.cfm` out of the sitemap.

References: [Lucee application events](https://docs.lucee.org/recipes/application-cfc.html), [Apache custom errors](https://httpd.apache.org/docs/current/custom-error.html), [IIS HTTP errors](https://learn.microsoft.com/en-us/iis/configuration/system.webserver/httperrors/).
