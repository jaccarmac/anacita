(use-modules (guix packages)
             (guix git-download)
             (guix build-system meson)
             ((guix licenses)
              #:prefix license:)
             (gnu packages pkg-config)
             (gnu packages perl)
             (gnu packages bison)
             (gnu packages texinfo)
             (gnu packages freedesktop)
             (gnu packages python)
             (gnu packages xml)
             (gnu packages glib)
             (gnu packages gtk)
             (gnu packages gnome)
             (gnu packages webkit)
             (gnu packages libusb)
             (gnu packages gstreamer)
             (gnu packages compression)
             (gnu packages gettext))

(define ratify
  (let ((commit "c21d3de0431a6d4e3ecfdfaa720a932c0e8e691e")
        (revision "1"))
    (package
      (name "ratify")
      (version (git-version "2.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ptomato/ratify")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0iwjva4hvhrvda76ghw32p1m2niz5h3fjkn06n34sfvcb4s5gz2i"))))
      (build-system meson-build-system)
      (arguments
       '(#:glib-or-gtk? #t
         #:tests? #f))
      (native-inputs (list pkg-config))
      (inputs (list glib gdk-pixbuf gtk+))
      (home-page "https://github.com/ptomato/ratify")
      (synopsis
       "A library for importing and exporting RTF documents to and from GtkTextBuffers.")
      (description
       "Ratify is a library for importing and exporting RTF documents to and
from GtkTextBuffers.")
      (license license:gpl3))))

(define chimara
  (let ((commit "04ff30aaf404e18f98e1ab86533c9dece11cb605")
        (revision "1"))
    (package
      (name "chimara")
      (version (git-version "0.9.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/chimara/Chimara")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "05avgkxm4cnjiihswxvy3w0sd8bh9d9lnly2hai5cn544a3y5wva"))
         (modules '((guix build utils)))
         (snippet '(begin
                     ;; Skip the custom install script.
                     (substitute* "meson.build"
                       (("meson.add_install_script")
                        "#meson.add_install_script"))))))
      (build-system meson-build-system)
      (arguments
       '(#:glib-or-gtk? #t
         #:tests? #f))
      (native-inputs (list pkg-config perl bison
                           `(,glib "bin") texinfo))
      (inputs (list glib
                    pango
                    gtk+
                    gstreamer
                    gst-plugins-base
                    gst-plugins-good
                    gst-plugins-bad
                    gobject-introspection))
      (home-page "https://github.com/chimara/Chimara")
      (synopsis "TODO")
      (description "TODO")
      (license (license:non-copyleft
                "https://github.com/chimara/Chimara/blob/beda78bb187dbf52e2bade624d38adbe84da338b/COPYING")))))

(define inform7-ide
  (let ((commit ;"4253b300e7380a3a5d2449d0f951a2ae209f7242"
                "166fa84c560bc2100a29474438eee07b8733052f")
         ;TODO Remove horrible hack.
        (revision "1"))
    (package
      (name "inform7-ide")
      (version (git-version "6M62" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url ;"https://github.com/ptomato/inform7-ide"
                    "https://github.com/jaccarmac/inform7-ide") ;TODO Remove horrible hack.
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 ;"1wwbilsknfblj0l0arz5zd353jq0g0azp5v3xc0d5y72drxn1w6s"
                  "1wvraqv0mfayv2lq0l19wy5fkd899mg68d8wfmcnqda7japrn8zs")) ;TODO Remove horrible hack.
         (modules '((guix build utils)))
         (snippet '(begin
                     ;; Use the Guix version of webkitgtk.
                     (substitute* "meson.build"
                       (("webkit2gtk-4.0")
                        "webkit2gtk-4.1"))))))
      (build-system meson-build-system)
      (arguments
       '(#:glib-or-gtk? #t
         #:tests? #f
         #:phases (modify-phases %standard-phases
                    ;; Skip shrink-runpath.
                    (delete 'shrink-runpath)))) ;TODO Figure out how to only skip for ni.
      (native-inputs (list pkg-config
                           `(,glib "bin")
                           `(,gtk+ "bin") desktop-file-utils python))
      (inputs (list libxml2
                    glib
                    gtk+
                    gtksourceview-3
                    gspell
                    goocanvas
                    webkitgtk
                    libplist
                    gnu-gettext
                    gstreamer
                    gst-plugins-base
                    gst-plugins-good
                    gst-plugins-bad
                    xz
                    ratify
                    chimara))
      (home-page "http://inform7.com/")
      (synopsis "A design system for interactive fiction")
      (description
       "Inform is a free app for creating works of interactive fiction, available
for MacOS, Windows, Linux and Android.  Inside it is a powerful programming
language based on English language text.")
      (license license:gpl3))))

inform7-ide
