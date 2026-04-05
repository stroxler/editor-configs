;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setenv "CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION" "false")

(setq vterm-module-cmake-args
      (concat "-DCMAKE_BUILD_RPATH="
              (expand-file-name "~/.nix-profile/lib")))

(defun my/set-agent-command (command-string)
  "Set the ai-code agent command from COMMAND-STRING.
Format: \"program --flag1 --flag2\" (first token is the binary, rest are switches)."
  (interactive "sAgent command: ")
  (let* ((parts (split-string command-string))
         (program (car parts))
         (switches (cdr parts)))
    (setq ai-code-claude-code-program program
          ai-code-claude-code-program-switches switches)
    (message "Agent command set to: %s" command-string)))

(use-package! ai-code
  :config
  (ai-code-set-backend 'claude-code)
  (when-let ((agent-cmd (getenv "AGENT_COMMAND")))
    (my/set-agent-command agent-cmd))
  (map! "C-c a" #'ai-code-menu)
  (advice-add 'ai-code--send-prompt :override
    (lambda (full-prompt)
      (ai-code-cli-send-command full-prompt)
      ;; Force vterm redraw after a short delay to prevent garbled display
      (run-with-timer 1.0 nil
        (lambda ()
          (dolist (buf (buffer-list))
            (with-current-buffer buf
              (when (derived-mode-p 'vterm-mode)
                (vterm--invalidate))))))
      (message "Prompt sent to AI."))))

(map! :leader
      :desc "ai-code menu"
      "d" #'ai-code-menu)

;; Make M-m, M-SPC, and C-SPC act as doom leader in all modes
;; Remap set-mark (normally C-SPC) to C-M
(setq doom-leader-alt-key "M-m")
(map! :nvig "M-m" doom-leader-map)
(map! :nvig "M-SPC" doom-leader-map)
;; Bind both C-@ and C-SPC: terminals send C-@ for Ctrl-Space,
;; but GUI Emacs sees C-SPC as a distinct key.
(map! :nvig "C-@" doom-leader-map)
(map! :nvig "C-SPC" doom-leader-map)
(map! :nvig "C-M" #'set-mark-command)

;; Make C-w trigger window actions in insert mode and vterm
(map! :i "C-w" evil-window-map)
(after! evil-collection-vterm
  (evil-define-key 'insert vterm-mode-map (kbd "C-w") evil-window-map))

;; Make M-SPC and C-SPC act as doom leader in vterm insert mode
(after! evil-collection-vterm
  (evil-define-key 'insert vterm-mode-map (kbd "M-SPC") doom-leader-map)
  ;; Same C-@ / C-SPC dual binding for vterm (see comment above)
  (evil-define-key 'insert vterm-mode-map (kbd "C-@") doom-leader-map)
  (evil-define-key 'insert vterm-mode-map (kbd "C-SPC") doom-leader-map))

;; Remap SPC SPC to ai-code-send-command
(map! :leader :desc "Send command to ai" "SPC" #'ai-code-send-command)

(use-package! evil-terminal-cursor-changer
  :config
  (evil-terminal-cursor-changer-activate) ; Enable the package
  (setq evil-visual-state-cursor 'box)    ; Customization
  (setq evil-insert-state-cursor 'bar)
  (setq evil-emacs-state-cursor  'hbar))

;; Move private config bindings from SPC f {p,P} to SPC f {m,M}
;; and repurpose SPC f p for projectile-find-file
(map! :leader
      (:prefix "f"
       :desc "Find file in private config" "m" #'doom/find-file-in-private-config
       :desc "Browse private config"       "M" #'doom/open-private-config
       :desc "Projectile find file"        "p" #'projectile-find-file
       :desc "Fuzzy find file"            "z" #'consult-find
       "P" nil))
