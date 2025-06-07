;; ---------------------------------
;; ┌─┐┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐  ┬┌┐┌┬┌┬┐
;; ├─┘├─┤│  ├┴┐├─┤│ ┬├┤   │││││ │ 
;; ┴  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘  ┴┘└┘┴ ┴ 
;; ---------------------------------
(require 'package)

;; パッケージリポジトリを追加
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; 読み込み
(require 'org-bullets)

;;カラースキーム
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme 'zenburn t)
(load-theme 'apropospriate-dark t)


;; ---------------------------------
;; ┌─┐┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐
;; ├─┘├─┤│  ├┴┐├─┤│ ┬├┤ 
;; ┴  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘
;; ---------------------------------
;; ---------------------------------
;; org-bullets
;; ---------------------------------
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; org textエクスポート時のバレットの記号
(setq org-ascii-bullets '((ascii ?- ?- ?-) (latin1 ?- ?- ?-) (utf-8 ?- ?- ?-)))
(setq org-bullets-bullet-list '("●" "●" "●" "・" "・" "・"))


;; ---------------------------------
;; ┌┐ ┌─┐┌─┐┬┌─┐
;; ├┴┐├─┤└─┐││  
;; └─┘┴ ┴└─┘┴└─┘
;; ---------------------------------
(prefer-coding-system 'utf-8)
;; 行頭の kill-line (C-k) で行ごと削除
(setq kill-whole-line t) 
;;cua-mode
(cua-mode t) 
(setq cua-enable-cua-keys nil) 
;; バックアップファイルを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
;; ツールバー非表示
(tool-bar-mode -1)
(global-display-line-numbers-mode)
(show-paren-mode t)
(setq inhibit-startup-message t) 
(setq initial-scratch-message "")
(setq echo-keystrokes .1)
;;デフォルトのワーキングディレクトリをデスクトップにする
(setq default-directory (expand-file-name "~/org/"))

;; Emacsに等幅フォントを設定
(set-face-attribute 'default nil :family "Myrica M" :height 140)


;; ---------------------------------
;; ┬┌─┌─┐┬ ┬┌┐ ┬┌┐┌┌┬┐┬┌┐┌┌─┐┌─┐
;; ├┴┐├┤ └┬┘├┴┐││││ │││││││ ┬└─┐
;; ┴ ┴└─┘ ┴ └─┘┴┘└┘─┴┘┴┘└┘└─┘└─┘
;; ---------------------------------
(global-set-key [f12] (lambda () (interactive) (load-file (expand-file-name "~/.emacs.d/init.el"))))
(global-set-key [f11] (lambda () (interactive) (find-file-other-window (expand-file-name "~/.emacs.d/init.el"))))


;; ---------------------------------
;; ┌─┐┬─┐┌─┐
;; │ │├┬┘│ ┬
;; └─┘┴└─└─┘
;; ---------------------------------
(add-hook 'org-mode-hook 'org-indent-mode)
;;orgを解釈して表示 OFF
(setq org-pretty-entities nil)
;; 画像をインライン表示する/しない
(setq org-startup-with-inline-images nil)
;; 作成日付を記入しない
(setq org-export-with-timestamps nil)
(setq org-export-time-stamp-file nil)
;; subscript を無効に
(setq org-export-with-sub-superscripts nil)
;; 見出しに番号を振らない
(setq org-export-with-section-numbers nil)
(setq org-beamer-outline-frame-title "Customized Title")
;; 見出しをフォールドしない
(setq org-startup-folded nil)
;; ?
(setq org-ascii-text-width 1000)
;; 改行を保持する
(setq org-export-preserve-breaks t)
(setq org-ascii-text-width most-positive-fixnum)
(setq org-ascii-headline-spacing nil)
(setq split-width-threshold 0)
(setq split-height-threshold nil)
;; disable indentation
(setq org-adapt-indentation nil)
;; https://emacs.stackexchange.com/questions/64019/how-can-i-suppress-the-message-when-done-with-this-frame-type-c-x-5-0
(setq server-client-instructions nil)

;;タブでのインデント
(setq indent-tabs-mode t)
(setq left-fringe-width 28)
(set-fringe-style (quote (20 . 20)))
;;(custom-set-variables
;; '(package-selected-packages '(apropospriate-theme zenburn-theme org-bullets)))
(setq org-ascii-bullets '((ascii ?* ?+ ?-) (latin1 ?・ ?・ ?・) (utf-8 ?▀  ?●  ?・)))
;; TODO種類
(setq org-todo-keywords
  '((sequence "TODO" "WIP" "|" "DONE")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("WIP" . (:foreground "yellow" :weight bold))
        ("DONE" . (:foreground "black" :weight bold))))
