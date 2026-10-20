;; -*- no-byte-compile: t; -*-
;;; tools/lsp/packages.el

(if (modulep! +eglot)
    (progn
      (package! eglot :pin "28884319c6326adc6dd02ecfee4f5a64e6aa6d29")
      (package! jsonrpc :pin "d8143c52679eaeebcca26dd41e015dc73d167b49")
      (package! xref :pin "9d7789ab2d66eba7beaa350cdccfa5f318a98acf")  ; needed by eglot
      (when (modulep! :completion vertico)
        (package! consult-eglot :pin "3e4d9a40911b897c0a2c5d20199d0f7c30bfc1c2"))
      ;; DEPRECATED: Remove when 29 support is dropped
      (when (and (< emacs-major-version 30) (modulep! +booster))
        (package! eglot-booster
          :recipe (:host github :repo "jdtsmith/eglot-booster")
          :pin "cab7803c4f0adc7fff9da6680f90110674bb7a22")))

  ;; lsp-mode must be rebuilt if this variable is changed, so expose it here so
  ;; users can change it from $DOOMDIR/packages.el.
  (eval-and-compile (defvar lsp-use-plists t))

  (package! lsp-mode
    :pin "5f36bd4da7bef0a01e9d067f992ea4c4ac9c7314"
    :env `(("LSP_USE_PLISTS" . ,(and lsp-use-plists "1"))))
  (package! lsp-ui :pin "ff349658ed69086bd18c336c8a071ba15f7fd574")
  (when (modulep! :completion ivy)
    (package! lsp-ivy :pin "8e0b8fdec086375fd7560857a84cd78f5047ad9d"))
  (when (modulep! :completion helm)
    (package! helm-lsp :pin "027897a957032e8752780600b21d2c0ea0cf3201"))
  (when (modulep! :completion vertico)
    (package! consult-lsp :pin "d11102c9db33c4ca7817296a2edafc3e26a61117")))
