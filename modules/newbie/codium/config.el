;;; newbie/codium/config.el -*- lexical-binding: t; -*-

;; Cua mode
(setopt cua-rectangle-mark-key (kbd "C-x r")) ; free C-<return> for other purposeses
(cua-mode +1)
(setopt cua-keep-region-after-copy t)

;; Advices
(newbie-codium/install)

(map! [escape] 'doom/escape)

;; Tabs and buffers
(if (modulep! :ui tabs)
    (map! "C-<prior>" 'centaur-tabs-backward
          "C-<next>" 'centaur-tabs-forward
          "C-S-<prior>" 'centaur-tabs-move-current-tab-to-left
          "C-S-<next>" 'centaur-tabs-move-current-tab-to-right)
  (map! "C-<prior>" 'previous-buffer
        "C-<next>" 'next-buffer))

;; Code navigation
(map! "M-<left>" 'better-jumper-jump-backward
      "M-<right>" 'better-jumper-jump-forward)

;; Code navigation
(map! "M-<left>" 'better-jumper-jump-backward
      "M-<right>" 'better-jumper-jump-forward)

;; Scroll
(map! "C-<up>" 'newbie-codium/scroll-up-in-place
      "C-<down>" 'newbie-codium/scroll-down-in-place)

;; Movement
(map! "<home>" 'doom/backward-to-bol-or-indent
      "<end>" 'doom/forward-to-last-non-comment-or-eol)

;; Selection
(map! "C-a" 'mark-whole-buffer)

;; Autocomplete
(map! "C-SPC" 'completion-at-point)

;; Undo/Redo
(map! "C-z" 'undo-fu-only-undo
      "C-S-z" 'undo-fu-only-redo)

;; Files
(map! "C-p" 'projectile-find-file
      "C-S-p" 'execute-extended-command
      "C-o" 'find-file
      "C-s" 'save-buffer
      "C-w" 'kill-current-buffer
      "C-S-t" 'newbie-codium/reopen-killed-file
      "C-r" 'projectile-switch-project)

(when (modulep! :ui tabs)
  (map! "C-n" 'centaur-tabs--create-new-empty-buffer))

;; Find
(map! "C-f" '+default/search-buffer
      "C-S-f" '+default/search-project)

;; Replace
(map! "C-h" 'anzu-query-replace
      "C-S-h" 'projectile-replace)

;; Term
(when (modulep! :term term)
  (map! "C-j" '+term/toggle))
(when (modulep! :term vterm)
  (map! "C-j" '+vterm/toggle))

;; More
(map! "C-g" 'goto-line
      "C-d" 'newbie-codium/duplicate-thing
      "C-/" 'newbie-codium/comment-dwim
      "C-\\" 'split-window-horizontally
      "C-," 'customize)
(when (modulep! :tools magit)
  (map! "C-S-g" 'magit))
(when (modulep! :ui treemacs)
  (map! "C-b" '+treemacs/toggle
        "C-S-e" 'newbie-codium/treemacs-open-or-go-to-it))
(when (modulep! :tools lsp)
  (map! "<f2>" 'lsp-rename))

;; Font
(map! "C-=" 'doom/increase-font-size
      "C--" 'doom/decrease-font-size)

;; Horizontal scroll
(map! "<wheel-left>" 'newbie-codium/scroll-right
      "<wheel-right>" 'newbie-codium/scroll-left)

;; Indent/Dedent
(map! :map prog-mode-map
      "<tab>" 'newbie-codium/keyboard-indent
      "<backtab>" 'newbie-codium/keyboard-unindent)

;; Undo Fu
(map! :after undo-fu
      :map undo-fu-mode-map
      ;; Free C-/ for commenting
      "C-/" nil)

;; Term
(map! :after term
      :map term-raw-map
      "C-j" '+term/toggle
      "C-S-c" 'kill-ring-save
      "C-S-v" 'term-paste)

;; VTerm
(map! :after vterm
      :map vterm-mode-map
      "C-j" '+vterm/toggle
      "C-S-v" 'vterm-yank)

;; Magit
(map! :after magit
      :map magit-mode-map
      ;; Free C-w for closing
      "C-w" nil)

;; Treemacs
(map! :after treemacs
      :map treemacs-mode-map
      ;; Free C-w for closing
      "<f2>" 'treemacs-rename-file)
