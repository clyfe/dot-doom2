;;; bindings.el -*- lexical-binding: t; -*-

;; My verry much custom bindings

;; Paredit
(map! :after smartparens
      :map smartparens-mode-map
      "C-<left>" 'sp-backward-sexp
      "C-<right>" 'sp-forward-sexp)

;; Elisp
(map! :map emacs-lisp-mode-map
      "DEL" 'sp-backward-delete-char
      "C-<return>" 'eros-eval-last-sexp
      "M-<return>" 'eros-eval-defun
      "C-M-<return>" 'eval-buffer)

;; Elisp scratch
(map! :map lisp-interaction-mode-map
      "DEL" 'sp-backward-delete-char
      "C-<return>" 'eros-eval-last-sexp
      "M-<return>" 'eros-eval-defun
      "C-M-<return>" 'eval-buffer
      "C-j" nil)

;; Cider
(map! :after cider
      :map cider-mode-map
      "C-<return>" 'cider-eval-last-sexp
      "M-<return>" 'cider-eval-defun-at-point
      "C-M-<return>" 'cider-load-buffer
      "<tab>" 'cider-format-defun
      "C-M-j" 'cider-jack-in)

(map! :after cider
      :map cider-repl-mode-map
      "C-l" 'cider-repl-clear-buffer)

(map! :after ein
      :map poly-ein-mode-map
      "C-<return>" 'ein:worksheet-execute-cell-km
      "M-<return>" 'ein:worksheet-execute-cell-km
      "C-M-<return>" 'ein:worksheet-execute-all-cells)

;; Clojure
(map! :map clojure-mode-map
      "DEL" 'sp-backward-delete-char
      "C-M-j" 'cider-jack-in-clj)
