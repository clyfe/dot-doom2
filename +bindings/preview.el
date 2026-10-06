;;; preview.el -*- lexical-binding: t; -*-

;;;; Preview tab

;;; Utilities

(defun clyfe/open-and-keep (&optional arg)
  "Open the file at point, then call `preview-tab-keep'."
  (interactive "P")
  (treemacs-visit-node-no-split arg)
  (preview-tab-keep))

;;; Bindings

;; Treemacs
(map! :after treemacs
      :map treemacs-mode-map
      [double-mouse-1] 'clyfe/open-and-keep)

;; Preview tab
(map! :after centaur-tabs
      :map centaur-tabs-mode-map
      [tab-line double-mouse-1] 'preview-tab-keep)
