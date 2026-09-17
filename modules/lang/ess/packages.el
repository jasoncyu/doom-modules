;; -*- no-byte-compile: t; -*-
;;; lang/ess/packages.el

(package! ess :pin "c3960e09f37550d300437c46ca03fb28975378a1")
(package! ess-view-data :pin "831be384d0045ae9ff1f4b8ae2b5090377938475")
(package! poly-R :pin "fee0b6e99943fa49ca5ba8ae1a97cbed5ed51946")
(package! quarto-mode :pin "a7b974f7d22ef939eaed8b9919434bcf20b1438f")

;; REVIEW: Frozen until #8702 is resolved upstream.
(package! polymode :pin "14b1fd8d2a183f11b123f62e02801dc1139da9c1" :freeze t)

(when (modulep! +stan)
  (package! stan-mode :pin "2bfd1484e1a99f9971b1a8aa1b587cdca411ab55")
  (package! eldoc-stan :pin "2bfd1484e1a99f9971b1a8aa1b587cdca411ab55")
  (when (modulep! :completion company)
    (package! company-stan :pin "2bfd1484e1a99f9971b1a8aa1b587cdca411ab55"))
  (when (modulep! :checkers syntax -flymake)
    (package! flycheck-stan :pin "2bfd1484e1a99f9971b1a8aa1b587cdca411ab55")))

(when (< emacs-major-version 29)
  ;; See emacs-ess/ESS#1193
  (package! xterm-color :pin "86fab1d247eb5ebe6b40fa5073a70dfa487cd465"))
