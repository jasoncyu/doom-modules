;;; term/ghostel/config.el -*- lexical-binding: t; -*-

(use-package! ghostel
  :commands ghostel-mode
  :hook (ghostel-mode . mode-line-invisible-mode)
  :config
  (set-popup-rule! "^\\*\\(?:doom:\\)?ghostel" :height 0.5 :vslot -4 :select t :quit nil :ttl 0)

  ;; HACK: See dakra/ghostel#456. Persp-mode stores buffers by name, so if
  ;;   ghostel renames a buffer, persp-mode will lose track of it.
  (when (modulep! :ui workspaces)
    ;; Ensure this runs as late as possible so that the user can't override us.
    (with-eval-after-load 'ghostel
      (setq ghostel-buffer-name-function nil)))

  ;; HACK: direnv will silently no-op in ghostel shells if direnv.el/envrc.el
  ;;   has already run, or if Emacs was launched from a direnv'ed environment,
  ;;   so unset its init vars to allow it to run again as needed.
  ;; REVIEW: PR this upstream?
  (add-hook! 'ghostel-pre-spawn-hook
    (defun +ghostel-strip-direnv-initvars-h (&rest _)
      (when (getenv "DIRENV_FILE")
        (setq-local process-environment
                    (seq-remove (fn! (string-prefix-p "DIRENV_" %))
                                process-environment))))))


(use-package! ghostel-eshell
  :when (modulep! +everywhere)
  :hook (eshell-load . ghostel-eshell-visual-command-mode)
  :init
  (with-eval-after-load 'em-term
    (add-to-list 'eshell-visual-commands "btop" t)))

  (setq-hook! 'ghostel-mode-hook
    confirm-kill-processes nil
    hscroll-margin 0)

(use-package! evil-ghostel
  :when (modulep! :editor evil)
  :hook (ghostel-mode . evil-ghostel-mode))
