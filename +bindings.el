;;; bindings.el -*- lexical-binding: t; -*-

;;;; My verry much custom bindings

;;; Utilities

(defun clyfe/clear-repl ()
  "Like `cider-repl-clear-buffer' but can be called from the Clojure buffer."
  (interactive)
  (if-let ((buffer (cider-current-repl)))
      (with-current-buffer buffer
        (cider-repl-clear-buffer))))

(defun clyfe/open-and-keep (&optional arg)
  "Open the file at point, then call `preview-tab-keep'."
  (interactive "P")
  (treemacs-visit-node-no-split arg)
  (preview-tab-keep))

(defun clyfe/compile-and-run-c-or-cpp ()
  "Compile and run the current C or C++ file, then focus the compilation buffer."
  (interactive)
  (unless buffer-file-name
    (user-error "Buffer is not visiting a file"))
  (save-buffer)
  (let* ((file (file-name-nondirectory buffer-file-name))
         (base (file-name-sans-extension file))
         (ext  (file-name-extension file))
         (compiler (cond ((member ext '("c"))
                          (or (getenv "CC") "gcc"))
                         ((member ext '("cpp" "cc" "cxx" "C"))
                          (or (getenv "CXX") "g++"))
                         (t (user-error "Not a C/C++ file: %s" file))))
         (flags (if (equal ext "c")
                    "-Wall -Wextra -g"
                  "-Wall -Wextra -g -std=c++17"))
         (out (concat "./" base))
         (cmd (format "%s %s %s -o %s && %s"
                      compiler flags
                      (shell-quote-argument file)
                      (shell-quote-argument base)
                      (shell-quote-argument out)))
         (default-directory (file-name-directory buffer-file-name))
         (buf (compile cmd t)))
    (when-let ((win (get-buffer-window buf)))
      (select-window win))))

(defun clyfe/compile-and-run-java ()
  "Compile and run the Java file in the current buffer."
  (interactive)
  (unless buffer-file-name
    (user-error "Buffer is not visiting a file"))
  (save-buffer)
  (let* ((file (file-name-nondirectory buffer-file-name))
         (class (file-name-sans-extension file))
         (default-directory (file-name-directory buffer-file-name))
         (cmd (format "javac %s && java %s"
                      (shell-quote-argument file)
                      (shell-quote-argument class)))
         (buf (compile cmd t)))
    (when-let ((win (get-buffer-window buf)))
      (select-window win))))

(defun clyfe/run-python-file ()
  "Save the current buffer, run its file with Python, and focus the output."
  (interactive)
  (unless buffer-file-name
    (user-error "Buffer is not visiting a file"))
  (save-buffer)
  (let* ((file (shell-quote-argument buffer-file-name))
         (python (or (executable-find "python3")
                     (executable-find "python")
                     (user-error "No Python interpreter found")))
         (default-directory (file-name-directory buffer-file-name))
         (buf (compile (format "%s %s" (shell-quote-argument python) file) t)))
    (pop-to-buffer buf)))

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

;; Treemacs
(map! :after treemacs
      :map treemacs-mode-map
      [mouse-1] 'treemacs-single-click-expand-action
      [double-mouse-1] 'clyfe/open-and-keep)

;; Preview tab
(map! :after centaur-tabs
      :map centaur-tabs-mode-map
      [tab-line double-mouse-1] 'preview-tab-keep)

;; Compile and run
(map! :map c-mode-base-map
      "<f5>" 'clyfe/compile-and-run-c-or-cpp
      :map c++-ts-mode-map
      "<f5>" 'clyfe/compile-and-run-c-or-cpp)
(map! :map java-mode-map
      "<f5>" 'clyfe/compile-and-run-java
      :map java-ts-mode-map
      "<f5>" 'clyfe/compile-and-run-java)
(map! :map python-mode-map
      "<f5>" 'clyfe/run-python-file)
