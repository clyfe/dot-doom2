;;; newbie/codium/config.el -*- lexical-binding: t; -*-

;; Cua mode
(setq cua-rectangle-mark-key (kbd "C-x r")) ; free C-<return> for other purposeses
(cua-mode +1)
(setq cua-keep-region-after-copy t)

;; Advices
(newbie-codium/install)

;; Globals
(map! [escape] 'doom/escape

      ;; Tabs
      "C-<prior>" 'centaur-tabs-backward
      "C-<next>" 'centaur-tabs-forward
      "C-S-<prior>" 'centaur-tabs-move-current-tab-to-left
      "C-S-<next>" 'centaur-tabs-move-current-tab-to-right

      ;; Code navigation
      "M-<left>" 'better-jumper-jump-backward
      "M-<right>" 'better-jumper-jump-forward

      ;; Scroll
      "C-<up>" 'newbie-codium/scroll-up-in-place
      "C-<down>" 'newbie-codium/scroll-down-in-place

      ;; Movement
      "<home>" 'doom/backward-to-bol-or-indent
      "<end>" 'doom/forward-to-last-non-comment-or-eol

      ;; Selection
      "C-a" 'mark-whole-buffer

      ;; Undo/Redo
      "C-z" 'undo-fu-only-undo
      "C-S-z" 'undo-fu-only-redo

      ;; Files
      "C-p" 'projectile-find-file
      "C-S-p" 'execute-extended-command
      "C-o" 'find-file
      "C-s" 'save-buffer
      "C-w" 'kill-current-buffer
      "C-S-t" 'newbie-codium/reopen-killed-file
      "C-r" 'projectile-switch-project
      "C-n" 'centaur-tabs--create-new-empty-buffer

      ;; Find
      "C-f" '+default/search-buffer
      "C-S-f" '+default/search-project

      ;; Replace
      "C-h" 'anzu-query-replace
      "C-S-h" 'projectile-replace

      ;; Term
      "C-j" '+term/toggle

      ;; More
      "C-g" 'goto-line
      "C-d" 'newbie-codium/duplicate-thing
      "C-/" 'newbie-codium/comment-dwim
      "C-S-e" '+treemacs/toggle
      "C-b" '+treemacs/toggle
      "C-\\" 'split-window-horizontally

      "<wheel-left>" 'newbie-codium/scroll-right
      "<wheel-right>" 'newbie-codium/scroll-left)

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
