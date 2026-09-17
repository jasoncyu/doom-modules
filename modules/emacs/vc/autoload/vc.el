;;; emacs/vc/autoload/vc.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;
;;; * Hacks

;; REVIEW: PR this upstream
;;;###autoload
(defun +vc--git-link-use-full-magit-rev-a (fn &rest args)
  "Expand 7-char commit hashes grabbed in magit contexts to their 40-char form.

This makes it consistent with hashes produced from git-timemachine and
`git-link--last-commit'."
  (defvar magit-buffer-revision)
  (letf! ((defun rev-parse (rev)
            (when rev
              (if (= 40 (string-width rev))
                  rev (magit-rev-parse rev))))
          (magit-buffer-revision
           (and (bound-and-true-p magit-buffer-revision)
                (rev-parse magit-buffer-revision)))
          (defadvice word-at-point (:filter-return (ret))
            (if (derived-mode-p 'magit-mode)
                (rev-parse (magit-commit-at-point))
              ret)))
    (apply fn args)))

;;;###autoload
(advice-add #'git-link--commit :around #'+vc--git-link-use-full-magit-rev-a)

;;;###autoload
(advice-add #'git-link-commit :around #'+vc--git-link-use-full-magit-rev-a)


;;
;;; Helpers

(defun +vc--git-link (&optional arg)
  (require 'git-link)
  (dlet ((git-link-use-commit
          (if arg (not git-link-use-commit) git-link-use-commit)))
    (apply #'git-link
           (git-link--remote)
           (or (and (doom-region-active-p)
                    (git-link--get-region))
               (list nil nil)))))

(defun +vc--git-link-commit (&optional arg)
  (require 'git-link)
  (dlet ((git-link-use-commit
          (if arg (not git-link-use-commit) git-link-use-commit)))
    (git-link-commit (git-link--select-remote))))

(defun +vc--git-link-homepage ()
  (require 'git-link)
  (git-link-homepage (git-link--remote)))


;;
;;; * Commands

;;;###autoload
(defun browse-at-remote--format-commit-url-as-codeberg (repo-url commithash)
  "Commit URL formatted for codeberg"
  (format "%s/src/commit/%s" repo-url commithash))


;;
;;; Commands

(defvar browse-at-remote-prefer-symbolic)
;;;###autoload
(defun +vc/browse-at-remote (&optional arg)
  "Open URL to current file (and line if selection is active) in browser.
If prefix ARG, negate the default value of `browse-at-remote-prefer-symbolic'."
  (interactive "P")
  (require 'browse-at-remote)
  (let ((vc-ignore-dir-regexp locate-dominating-stop-dir-regexp)
        (browse-at-remote-prefer-symbolic
         (if arg
             (not browse-at-remote-prefer-symbolic)
           browse-at-remote-prefer-symbolic)))
    (browse-at-remote)))

;;;###autoload
(defun +vc/browse-at-remote-kill (&optional arg interactive?)
  "Copy URL to current file (and line if selection is active) to clipboard.
If prefix ARG, negate the default value of `browse-at-remote-prefer-symbolic'."
  (interactive (list current-prefix-arg 'interactive))
  (require 'browse-at-remote)
  (let ((vc-ignore-dir-regexp locate-dominating-stop-dir-regexp)
        (browse-at-remote-prefer-symbolic
         (if arg
             (not browse-at-remote-prefer-symbolic)
           browse-at-remote-prefer-symbolic)))
    (browse-at-remote-kill)
    (if interactive? (message "Copied to clipboard"))))

;;;###autoload
(defun +vc/browse-at-remote-homepage ()
  "Open homepage for current project in browser."
  (interactive)
  (browse-url (+vc--remote-homepage)))

;;;###autoload
(defun +vc/browse-at-remote-kill-homepage ()
  "Copy homepage URL of current project to clipboard."
  (interactive)
  (let ((url (+vc--remote-homepage)))
    (kill-new url)
    (message "Copied to clipboard: %S" url)))
