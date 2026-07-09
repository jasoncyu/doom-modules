;; -*- no-byte-compile: t; -*-
;;; term/ghostel/packages.el

(package! ghostel
  :recipe (:host github :repo "dakra/ghostel"
           :files (:defaults "etc" "src" "vendor" "build.zig" "build.zig.zon" "symbols.map"))
  :pin "67fa1ebeb940c411fcc53a7dfbe33eac1ecb9cae")

(package! evil-ghostel
  :recipe (:host github :repo "dakra/ghostel"
           :local-repo "ghostel"
           :files ("extensions/evil-ghostel/evil-ghostel.el"))
  :pin "67fa1ebeb940c411fcc53a7dfbe33eac1ecb9cae")
