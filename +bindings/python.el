;;; $DOOMDIR/+bindings/python.el -*- lexical-binding: t; -*-

;;;; My very much custom python bindings

;; Python
(map! :map python-mode-map
      "<backtab>" 'newbie-codium/keyboard-unindent)
(map! :map python-ts-mode-map
      "<backtab>" 'newbie-codium/keyboard-unindent)
(map! :after ein
      :map poly-ein-mode-map
      "C-<return>" 'ein:worksheet-execute-cell-km
      "M-<return>" 'ein:worksheet-execute-cell-km
      "C-M-<return>" 'ein:worksheet-execute-all-cells)
