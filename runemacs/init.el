;; Runemacs config!
;;
;; A fairly minimal evil-oriented config
;;
;; Adapted from the System Crafter's getting-started config, video 3:
;;   https://github.com/daviwil/emacs-from-scratch/blob/82d24eea516e7799ead20cf068542e2b5ecb270e/init.el

(defvar runemacs/default-font-size 115)

(setq inhibit-startup-message t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; SET up the visible bell
(setq visible-bell t)

;; Menlo is the default font of the alacritty terminal
(set-face-attribute 'default nil :font "Menlo" :height runemacs/default-font-size)

;; Initialize package sources
(require 'package)

;; Corporate DNS can't resolve external hosts; use fwdproxy so the
;; proxy handles DNS resolution for us.
(when (or (getenv "https_proxy") (getenv "HTTPS_PROXY"))
  (require 'url)
  (setq url-proxy-services
        `(("http"  . ,(replace-regexp-in-string "^https?://" "" (or (getenv "http_proxy") (getenv "HTTP_PROXY") "")))
          ("https" . ,(replace-regexp-in-string "^https?://" "" (or (getenv "https_proxy") (getenv "HTTPS_PROXY") "")))
          ("no_proxy" . "^\\(localhost\\|127\\.0\\.0\\.1\\)"))))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode
  :defer t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons
  :defer t)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-solarized-light t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  ;; use normal emacs bindings in insert mode
  (setq evil-disable-insert-state-bindings t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; By default emacs treats _ as non-word character. Some folks actually like this
;; but it drives me nuts because of inconsistency with vim and most vim emulators
(modify-syntax-entry ?_ "w")

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ** Hydra **
;;
;; Tool for making interactive commands. We define a little text-scaling tool
;; just to illustrate how it works
;;
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;;
;; languages setup
;;


(use-package rustic
  :defer t)

(use-package eglot
  :ensure t
  :hook ((python-mode python-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
    `((python-ts-mode python-mode) . ("pyrefly" "lsp"))))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

;;
;; general agent integration
;;

;; auto suggestions are terrible for editor integrations
;; - this will disable claude code
;; - for codex, there's a setting to do it in config.toml
(setenv "CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION" "false")

(use-package vterm
  :ensure t
  :defer t
  :init
  (setq vterm-module-cmake-args
        (concat "-DCMAKE_BUILD_RPATH="
                (expand-file-name "~/.nix-profile/lib"))))

(use-package ai-code
  :bind (("C-c a" . ai-code-menu))
  :config
  (ai-code-set-backend 'claude-code)
  ;; Stay in the current buffer after sending a prompt
  (advice-add 'ai-code--send-prompt :override
    (lambda (full-prompt)
      (ai-code-cli-send-command full-prompt)
      (message "Prompt sent to AI."))))
(rune/leader-keys
  "d" '(ai-code-menu :which-key "ai-code menu"))

;; =============== END ===================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((claude-code-ide :url
		      "https://github.com/manzaltu/claude-code-ide.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
