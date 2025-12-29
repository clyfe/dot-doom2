;;; newbie/codium/autoload.el -*- lexical-binding: t; -*-

;;; Comment

;;;###autoload
(defun newbie-codium/comment-dwim ()
  ;; From https://www.emacswiki.org/emacs/CommentingCode
  "Like `comment-dwim' but comments lines at beginning."
  (interactive)
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (when (or (not transient-mark-mode) (region-active-p))
      (setq start (save-excursion
                    (goto-char (region-beginning))
                    (beginning-of-line)
                    (point))
            end (save-excursion
                  (goto-char (region-end))
                  (end-of-line)
                  (point))))
    (comment-or-uncomment-region start end)))

;;; Scroll in place

;;;###autoload
(defun newbie-codium/scroll-down-in-place (n)
  "Scroll down keeping the point in place."
  (interactive "p")
  (save-excursion
    (scroll-up n)))

;;;###autoload
(defun newbie-codium/scroll-up-in-place (n)
  "Scroll up keeping the point in place."
  (interactive "p")
  (save-excursion
    (scroll-down n)))

;;; Jumper follow

(require 'better-jumper)

;;;###autoload
(defun newbie-codium/better-jumper-set-jump (&optional pos)
  "Like `better-jumper-set-jump' but does not `push-mark'."
  (unless (or
           better-jumper--jumping
           (better-jumper--ignore-persp-change))
    ;; clear out intermediary jumps when a new one is set
    (let* ((struct (better-jumper--get-struct))
           (jump-list (better-jumper--get-struct-jump-list struct))
           (idx (better-jumper-jump-list-struct-idx struct)))
      (when (eq better-jumper-add-jump-behavior 'replace)
        (cl-loop repeat idx
                 do (ring-remove jump-list 0)))
      (setf (better-jumper-jump-list-struct-idx struct) -1))
    (save-excursion
      (when pos
        (goto-char pos))
      (better-jumper--push))))

;;;###autoload
(defun newbie-codium/better-jumper-advice (&rest _args)
  (newbie-codium/better-jumper-set-jump))

;;; Deselect arrows

(defvar newbie-codium/shift-selection-just-deactivated-mark nil)

;;;###autoload
(defun newbie-codium/handle-shift-selection-before ()
  (if (and (not (and shift-select-mode this-command-keys-shift-translated))
           (eq (car-safe transient-mark-mode) 'only))
      (setq newbie-codium/shift-selection-just-deactivated-mark t)))

;;;###autoload
(defun newbie-codium/call-interactively-after (&rest _args)
  (if newbie-codium/shift-selection-just-deactivated-mark
      (setq newbie-codium/shift-selection-just-deactivated-mark nil)))

;;;###autoload
(defun newbie-codium/left-char-around (f &rest args)
  "If text selected, on pressing left arrow deselects and moves point to left of
  selection."
  (if newbie-codium/shift-selection-just-deactivated-mark
      (goto-char (min (mark) (point)))
    (apply f args)))

;;;###autoload
(defun newbie-codium/right-char-around (f &rest args)
  "If text selected, on pressing left arrow deselects and moves point to right
  of selection."
  (if newbie-codium/shift-selection-just-deactivated-mark
      (goto-char (max (mark) (point)))
    (apply f args)))

;;; Duplicate thing

;;;###autoload
(defun newbie-codium/duplicate-thing (n)
  "Like `duplicate-thing' but maintains the cursor column."
  (interactive "P")
  (let ((col (current-column)))
    (duplicate-thing n)
    (forward-line -1)
    (goto-char (+ (point) col))
    (deactivate-mark)))

;;; Scroll

;;;###autoload
(defun newbie-codium/scroll-right()
  (interactive)
  (save-selected-window
    (select-window (window-at (cadr (mouse-position))
                              (cddr (mouse-position))
                              (car (mouse-position))))
    (scroll-right 2)))

;;;###autoload
(defun newbie-codium/scroll-left()
  (interactive)
  (save-selected-window
    (select-window (window-at (cadr (mouse-position))
                              (cddr (mouse-position))
                              (car (mouse-position))))
    (scroll-left 2)))

;;; Reopen closed

;; https://emacs.stackexchange.com/questions/3330/how-to-reopen-just-killed-buffer-like-c-s-t-in-firefox-browser

(defvar newbie-codium/killed-file-list nil
  "List of recently killed files.")

(defun newbie-codium/add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name newbie-codium/killed-file-list)))

;;;###autoload
(defun newbie-codium/reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (when newbie-codium/killed-file-list
    (find-file (pop newbie-codium/killed-file-list))))

;;; Treemacs

;;;###autoload
(defun newbie-codium/treemacs-open-or-go-to-it ()
  "Open Treemacs and/or go to it."
  (interactive)
  (pcase (treemacs-current-visibility)
    (`visible (other-popup))
    (_ (+treemacs/toggle))))

;;; Indent/Dedent

;; https://emacs.stackexchange.com/questions/36646/what-prevents-emacs-from-indenting-and-how-can-i-force-it-to

(defun newbie-codium/region-line-beg ()
  (if (region-active-p)
      (save-excursion (goto-char (region-beginning)) (line-beginning-position))
    (line-beginning-position)))

(defun newbie-codium/region-line-end ()
  (if (region-active-p)
      (save-excursion (goto-char (region-end)) (line-end-position))
    (line-end-position)))

;;;###autoload
(defun newbie-codium/keyboard-indent (&optional arg)
  (interactive)
  (let ((deactivate-mark nil))  ; keep region
    (indent-rigidly (newbie-codium/region-line-beg)
                    (newbie-codium/region-line-end)
                    (* (or arg 1) tab-width))))

;;;###autoload
(defun newbie-codium/keyboard-unindent (&optional arg)
  (interactive)
  (newbie-codium/keyboard-indent (* -1 (or arg 1))))

;;; ON/OFF

;;;###autoload
(defun newbie-codium/install ()
  "Enables advices when `newbie-codium' mode is activated."
  (progn
    ;; Hooks
    (add-hook 'kill-buffer-hook #'newbie-codium/add-file-to-killed-file-list)

    ;; Jumper follow
    (advice-add 'push-mark :after #'newbie-codium/better-jumper-advice)
    (advice-add 'switch-to-buffer :after #'newbie-codium/better-jumper-advice)
    (advice-add 'find-file :after #'newbie-codium/better-jumper-advice)
    (advice-add '+lookup/definition :after #'newbie-codium/better-jumper-advice)

    ;; Deselect arrows
    (advice-add 'handle-shift-selection :before #'newbie-codium/handle-shift-selection-before)
    (advice-add 'call-interactively :after #'newbie-codium/call-interactively-after)
    (advice-add 'left-char :around #'newbie-codium/left-char-around)
    (advice-add 'right-char :around #'newbie-codium/right-char-around)))

;;;###autoload
(defun newbie-codium/uninstall ()
  "Remove advices when `newbie-codium' mode is deactivated."
  (progn
    ;; Hooks
    (remove-hook 'kill-buffer-hook #'newbie-codium/add-file-to-killed-file-list)

    ;; Jumper follow
    (advice-remove 'push-mark #'newbie-codium/better-jumper-advice)
    (advice-remove 'switch-to-buffer #'newbie-codium/better-jumper-advice)
    (advice-remove 'find-file #'newbie-codium/better-jumper-advice)
    (advice-remove '+lookup/definition #'newbie-codium/better-jumper-advice)

    ;; Deselect arrows
    (advice-remove 'handle-shift-selection #'newbie-codium/handle-shift-selection-before)
    (advice-remove 'call-interactively #'newbie-codium/call-interactively-after)
    (advice-remove 'left-char #'newbie-codium/left-char-around)
    (advice-remove 'right-char #'newbie-codium/right-char-around)))
