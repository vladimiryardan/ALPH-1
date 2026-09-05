

<cfsetting showdebugoutput="false">
<cfheader statuscode="404" statustext="Not Found">
<cfheader name="X-Robots-Tag" value="noindex, follow">
<cfcontent type="text/html; charset=utf-8" reset="true">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex, follow">
    <meta name="description" content="This page could not be found. Return to Attic Ladder PH, browse installation photos, or contact us for help.">
    <title>Page Not Found | Attic Ladder PH</title>
    <link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon-32x32.png">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; font-family: system-ui, sans-serif; color: #212529; background: #f8f9fa; }
        header { background: #212529; padding: 1.25rem max(1.5rem, calc((100% - 1120px) / 2)); }
        .brand { color: white; font-size: 1.25rem; font-weight: 700; text-decoration: none; }
        main { flex: 1; display: grid; place-items: center; padding: 3rem 1.5rem; }
        .message { width: 100%; max-width: 680px; text-align: center; }
        .code { margin: 0; color: #806017; font-size: clamp(4rem, 16vw, 7rem); font-weight: 800; line-height: 1; }
        h1 { font-size: clamp(1.8rem, 6vw, 2.5rem); margin: 1.5rem 0 1rem; }
        .description { color: #545b62; font-size: 1.125rem; line-height: 1.7; }
        .actions { display: flex; justify-content: center; flex-wrap: wrap; gap: 1rem; margin: 2rem 0; }
        .button { display: inline-block; border: 2px solid #212529; border-radius: .5rem; padding: .8rem 1.4rem; font-weight: 600; color: #212529; text-decoration: none; }
        .primary { background: #212529; color: white; }
        .button:hover { background: #d4a64a; color: #212529; }
        a:focus-visible { outline: 3px solid #96711e; outline-offset: 5px; }
        .help a { color: #212529; text-underline-offset: .2em; }
        footer { text-align: center; padding: 1.5rem; color: #545b62; }
    </style>
</head>
<body>
    <header><a class="brand" href="/">Attic Ladder PH</a></header>
    <main>
        <div class="message">
            <p class="code" aria-hidden="true">404</p>
            <h1>We couldn't find that page</h1>
            <p class="description">The link may be outdated, or the address may have been mistyped. You can return home or explore our attic ladder installations.</p>
            <nav class="actions" aria-label="Find another page">
                <a class="button primary" href="/">Return to Home</a>
                <a class="button" href="/gallery.cfm">Browse Gallery</a>
            </nav>
            <p class="help">Need help? <a href="/contact.cfm">Contact us</a> or <a href="/quoterequest.cfm">request a free quote</a>.</p>
        </div>
    </main>
    <footer>Attic Ladder PH &middot; Free Space Lifestyle</footer>
</body>
</html>
