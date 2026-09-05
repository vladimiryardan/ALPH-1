<cfparam name="pageCanonicalURL" default="">
<cfparam name="pageTitle" default="Attic Ladder PH | Attic Access Solutions">
<cfparam name="pageImageURL" default="https://atticladderph.com/images/attic-ladder-main.png">
<cfparam name="pageImageAlt" default="Retractable attic ladder installed beneath an open ceiling hatch">
<cfparam name="pageDescription" default="Discover space-saving attic ladders from Attic Ladder PH. Explore attic access solutions, nationwide supply and installation options, and request a free quote.">
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="<cfoutput>#encodeForHTMLAttribute(pageDescription)#</cfoutput>" />
    <meta name="author" content="" />
    <title><cfoutput>#encodeForHTML(pageTitle)#</cfoutput></title>
    <meta property="og:title" content="<cfoutput>#encodeForHTMLAttribute(pageTitle)#</cfoutput>" />
    <meta property="og:description" content="<cfoutput>#encodeForHTMLAttribute(pageDescription)#</cfoutput>" />
    <meta property="og:image" content="<cfoutput>#encodeForHTMLAttribute(pageImageURL)#</cfoutput>" />
    <meta property="og:image:alt" content="<cfoutput>#encodeForHTMLAttribute(pageImageAlt)#</cfoutput>" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="<cfoutput>#encodeForHTMLAttribute(pageTitle)#</cfoutput>" />
    <meta name="twitter:description" content="<cfoutput>#encodeForHTMLAttribute(pageDescription)#</cfoutput>" />
    <meta name="twitter:image" content="<cfoutput>#encodeForHTMLAttribute(pageImageURL)#</cfoutput>" />
    <meta name="twitter:image:alt" content="<cfoutput>#encodeForHTMLAttribute(pageImageAlt)#</cfoutput>" />
    <cfif len(pageCanonicalURL)>
      <link rel="canonical" href="<cfoutput>#encodeForHTMLAttribute(pageCanonicalURL)#</cfoutput>" />
      <meta property="og:url" content="<cfoutput>#encodeForHTMLAttribute(pageCanonicalURL)#</cfoutput>" />
    </cfif>
    <!-- Favicon-->
    <link rel="icon" type="image/png" sizes="16x16" href="/assets/favicon-16x16.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="96x96" href="/assets/favicon-96x96.png" />
    <!-- Bootstrap icons-->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    
    <link 
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
      rel="stylesheet">

    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="css/styles.css" rel="stylesheet" />
  </head>
