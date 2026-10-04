;;; preview.el -*- lexical-binding: t; -*-

;;;; Preview tab

;;; Utilities

(defun clyfe/open-and-keep (&optional arg)
  "Open the file at point, then call `preview-tab-keep'."
  (interactive "P")
  (treemacs-visit-node-no-split arg)
  (preview-tab-keep))

(defun clyfe/treemacs-right-expand-or-down ()
  "Expand the current treemacs node if it's collapsed.
If it's already expanded (or is a leaf), move to the next line."
  (interactive)
  (let ((state (treemacs-button-get (treemacs-current-button) :state)))
    (pcase state
      ((or 'dir-node-closed 'file-node-closed 'tag-node-closed
           'root-node-closed)
       (treemacs-TAB-action))
      (_ (treemacs-next-line 1)))))

(defun clyfe/treemacs-left-collapse-or-up ()
  "Collapse the current treemacs node if it is open.
If it is already closed (or is a leaf), move up one line."
  (interactive)
  (let ((state (treemacs-button-get (treemacs-current-button) :state)))
    (pcase state
      ((or 'dir-node-open 'file-node-open 'tag-node-open 'root-node-open)
       (treemacs-TAB-action))
      (_ (treemacs-previous-line 1)))))

;;; Bindings

;; Treemacs
(map! :after treemacs
      :map treemacs-mode-map
      [mouse-1] 'treemacs-single-click-expand-action
      "<left>" 'clyfe/treemacs-left-collapse-or-up
      "<right>" 'clyfe/treemacs-right-expand-or-down
      [double-mouse-1] 'clyfe/open-and-keep)

;; Preview tab
(map! :after centaur-tabs
      :map centaur-tabs-mode-map
      [tab-line double-mouse-1] 'preview-tab-keep)
