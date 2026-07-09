;;; term/ghostel/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +ghostel/toggle (arg)
  "Toggle a terminal popup window at project root.

If prefix ARG is non-nil, recreate the ghostel buffer in the current
project's root.

Returns the ghostel buffer."
  (interactive "P")
  (+ghostel--configure-project-root-and-display
   arg
   (lambda ()
     (let ((buffer-name
            (format "*doom:ghostel-popup:%s*"
                    (if (bound-and-true-p persp-mode)
                        (safe-persp-name (get-current-persp))
                      "main")))
           current-prefix-arg)
       (when arg
         (let ((buffer (get-buffer buffer-name))
               (window (get-buffer-window buffer-name)))
           (when (buffer-live-p buffer)
             (kill-buffer buffer))
           (when (window-live-p window)
             (delete-window window))))
       (if-let* ((win (get-buffer-window buffer-name)))
           (delete-window win)
         (let ((buffer (or (and (fboundp 'ghostel--find-buffer-by-identity)
                                (ghostel--find-buffer-by-identity buffer-name))
                           (get-buffer-create buffer-name))))
           (require 'ghostel)
           (ghostel--load-module t)
           (ghostel--prepare-buffer buffer buffer-name)
           (pop-to-buffer buffer)
           (ghostel--init-buffer buffer buffer-name)))
       (get-buffer buffer-name)))))

;;;###autoload
(defun +ghostel/here (arg)
  "Open a terminal buffer in the current window at project root.

If prefix ARG is non-nil, cd into `default-directory' instead of project root.

Returns the ghostel buffer."
  (interactive "P")
  (+ghostel--configure-project-root-and-display
   arg
   (lambda ()
     (let (display-buffer-alist)
       (ghostel)))))

(defun +ghostel--configure-project-root-and-display (arg display-fn)
  "Set PROOT and display a terminal using DISPLAY-FN.

If prefix ARG is non-nil, cd into `default-directory' instead of project root."
  (let* ((project-root (or (doom-project-root) default-directory))
         (default-directory
           (if arg
               default-directory
             project-root)))
    (setenv "PROOT" project-root)
    (funcall display-fn)))
