;;; $DOOMDIR/+bindings/lisps.el -*- lexical-binding: t; -*-

;;;; My very much custom bindings

;;; Utilities

(defun clyfe/clear-repl ()
  "Like `cider-repl-clear-buffer' but can be called from the Clojure buffer."
  (interactive)
  (if-let ((buffer (cider-current-repl)))
      (with-current-buffer buffer
        (cider-repl-clear-buffer))))

;;; Bindings

;; Paredit
(map! :after smartparens
      :map smartparens-mode-map
      "C-<left>" 'sp-backward-sexp
      "C-<right>" 'sp-forward-sexp)

;; Elisp
(map! :map emacs-lisp-mode-map
      "<tab>" 'indent-pp-sexp
      "C-<return>" 'eros-eval-last-sexp
      "M-<return>" 'eros-eval-defun
      "C-M-<return>" 'eval-buffer
      "M-d" 'sp-kill-sexp)

;; Elisp scratch
(map! :map lisp-interaction-mode-map
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
      "C-M-j" 'cider-jack-in
      "C-l" 'clyfe/clear-repl)

(map! :after cider
      :map cider-repl-mode-map
      "C-l" 'cider-repl-clear-buffer)

;; Clojure
(map! :after clojure-mode
      :map clojure-mode-map
      "C-M-j" 'cider-jack-in-clj)
(map! :after clojure-ts-mode
      :map clojure-ts-mode-map
      "M-d" 'sp-kill-sexp)
