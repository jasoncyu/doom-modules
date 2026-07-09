;;; term/ghostel/config.el -*- lexical-binding: t; -*-

(use-package! ghostel
  :commands ghostel-mode
  :hook (ghostel-mode . mode-line-invisible-mode)
  :config
  (set-popup-rule! "^\\*doom:ghostel-popup" :size 0.25 :vslot -4 :select t :quit nil :ttl 0)

  (setq ghostel-kill-buffer-on-exit t)

  (setq-hook! 'ghostel-mode-hook
    confirm-kill-processes nil
    hscroll-margin 0))

(use-package! evil-ghostel
  :when (modulep! :editor evil)
  :hook (ghostel-mode . evil-ghostel-mode))
