;;; $DOOMDIR/+bindings/run.el -*- lexical-binding: t; -*-

;;;; Compile and run file

;;; Utilities

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
    (pop-to-buffer buf)))

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
    (pop-to-buffer buf)))

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
      "<f5>" 'clyfe/run-python-file
      :map python-ts-mode-map
      "<f5>" 'clyfe/run-python-file)
