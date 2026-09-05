 <cfset pageTitle = "Attic Ladder Installation Gallery | Attic Ladder PH">
<cfset pageDescription = "Browse attic ladder installation photos from Attic Ladder PH. Explore completed projects and find inspiration for practical, space-saving attic access.">
<cfinclude template = "inc_header.cfm">
<cfset activeNav = "gallery">

<!--- ############
      Build gallery data from the /gallery/yyyymmdd/ folders on disk
      ############ --->
<cfset galleryRoot = expandPath("./gallery")>
<cfset galleryAlbums = arrayNew(1)>
<cfset validExtensions = "jpg,jpeg,png,gif,webp">

<cfif directoryExists(galleryRoot)>

    <cfdirectory action="list" directory="#galleryRoot#" name="qAlbumFolders" type="dir" sort="name DESC">

    <cfloop query="qAlbumFolders">

        <cfset albumFolderName = qAlbumFolders.name>
        <cfset albumPath = galleryRoot & "/" & albumFolderName>

        <!--- only treat yyyymmdd-style folders as albums --->
        <cfif reFind("^\d{8}$", albumFolderName) GT 0>

            <!--- recurse in case images are nested a level deeper inside the album folder --->
            <cfdirectory action="list" directory="#albumPath#" name="qAlbumImages" type="file" sort="directory ASC, name ASC" recurse="true">

            <cfset albumImages = arrayNew(1)>

            <cfloop query="qAlbumImages">
                <cfif listFindNoCase(validExtensions, listLast(qAlbumImages.name, "."))>
                    <cfset relativeDir = replaceNoCase(qAlbumImages.directory, galleryRoot, "", "once")>
                    <cfset relativeDir = replace(relativeDir, "\", "/", "all")>
                    <cfset arrayAppend(albumImages, {
                        fileName = qAlbumImages.name,
                        path = "gallery" & relativeDir & "/" & qAlbumImages.name
                    })>
                </cfif>
            </cfloop>

            <!--- images are named 1, 2, 3... so sort numerically instead of alphabetically (avoids 1, 10, 2, 3...) --->
            <!--- zero-pad the numeric filename so a plain text sort still lands in numeric order --->
            <cfset sortMap = structNew("linked")>
            <cfloop array="#albumImages#" index="imgObj">
                <cfset numericKey = numberFormat(val(listFirst(imgObj.fileName, ".")), "0000000000")>
                <cfset structInsert(sortMap, numericKey & "_" & imgObj.fileName, imgObj, true)>
            </cfloop>
            <cfset sortedKeys = structKeyArray(sortMap)>
            <cfset arraySort(sortedKeys, "text")>
            <cfset albumImages = arrayNew(1)>
            <cfloop array="#sortedKeys#" index="sortedKey">
                <cfset arrayAppend(albumImages, sortMap[sortedKey])>
            </cfloop>

            <cfif arrayLen(albumImages)>
                <cfset albumDate = createDate(
                    left(albumFolderName, 4),
                    mid(albumFolderName, 5, 2),
                    right(albumFolderName, 2)
                )>

                <cfset arrayAppend(galleryAlbums, {
                    folderName = albumFolderName,
                    displayDate = dateFormat(albumDate, "mmmm d, yyyy"),
                    images = albumImages
                })>
            </cfif>

        </cfif>

    </cfloop>

</cfif>

 <!--
    ############
    body
    ############
  -->
  <body class="d-flex flex-column h-100">
    <main class="flex-shrink-0">

      <!---
      ############
      Navigation
      ############
      --->
      <cfinclude template = "inc_nav.cfm">

      <!--
      ############
      Header
      ############
      -->
      <header class="bg-dark py-5">
        <div class="container px-5">
          <div class="row gx-5 align-items-center justify-content-center">
            <div class="col-lg-8 col-xl-7 col-xxl-6">
              <div class="my-5 text-center">
                <h1 class="display-5 fw-bolder text-white mb-2">Gallery</h1>
                <p class="lead fw-normal text-white-50 mb-0">
                  A look at our completed Attic Ladder installations.
                </p>
              </div>
            </div>
          </div>
        </div>
      </header>

      <!--
      ############
      Gallery section
      ############
      -->
      <section class="py-5">
        <div class="container px-5 my-5">

          <cfif arrayLen(galleryAlbums) EQ 0>

            <div class="text-center text-muted py-5">
              <i class="bi bi-images" style="font-size: 3rem;"></i>
              <p class="lead mt-3 mb-0">No gallery photos have been added yet. Please check back soon.</p>
            </div>

          <cfelse>

            <cfoutput>
            <cfloop array="#galleryAlbums#" index="album">
              <div class="gallery-album mb-5">
                <h2 class="h4 fw-bolder mb-4 gallery-album-title">
                  <i class="bi bi-calendar3 me-2 text-primary"></i>#album.displayDate#
                </h2>
                <div class="row gx-3 gy-3">
                  <cfloop from="1" to="#arrayLen(album.images)#" index="imgPos">
                    <cfset img = album.images[imgPos]>
                    <cfset imgIndex = imgPos - 1>
                    <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                      <a
                        href="#img.path#"
                        class="gallery-thumb d-block rounded-3 overflow-hidden"
                        data-bs-toggle="modal"
                        data-bs-target="##galleryModal"
                        data-album="#album.folderName#"
                        data-index="#imgIndex#"
                      >
                        <img
                          src="#img.path#"
                          class="img-fluid gallery-thumb-img"
                          loading="lazy"
                          alt="Attic Ladder gallery photo - #album.displayDate#"
                        />
                      </a>
                    </div>
                  </cfloop>
                </div>
              </div>
            </cfloop>
            </cfoutput>

            <!--- lightbox modal for full-size viewing --->
            <div class="modal fade" id="galleryModal" tabindex="-1" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered modal-xl">
                <div class="modal-content bg-dark border-0">
                  <button
                    type="button"
                    class="btn-close btn-close-white gallery-modal-close"
                    data-bs-dismiss="modal"
                    aria-label="Close"
                  ></button>
                  <div class="modal-body d-flex align-items-center justify-content-center position-relative p-0">
                    <button type="button" class="gallery-nav gallery-nav-prev" aria-label="Previous photo">
                      <i class="bi bi-chevron-left"></i>
                    </button>
                    <img src="" alt="Gallery photo" class="gallery-modal-img" id="galleryModalImage" />
                    <button type="button" class="gallery-nav gallery-nav-next" aria-label="Next photo">
                      <i class="bi bi-chevron-right"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!--- data used by the lightbox script to know each album's images and enable prev/next --->
            <cfoutput>
            <script>
              window.galleryAlbums = {
                <cfloop array="#galleryAlbums#" index="album">
                  "#album.folderName#": [
                    <cfloop array="#album.images#" index="img">"#img.path#",</cfloop>
                  ],
                </cfloop>
              };
            </script>
            </cfoutput>

          </cfif>

        </div>
      </section>

    </main>
 <cfinclude template = "inc_footer.cfm">

<script src="js/gallery.js"></script>