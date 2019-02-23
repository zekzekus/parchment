;;; -*- lexical-binding: t -*-

;; Copyright © 2019 Alex Griffin <a@ajgrf.com>
;;
;;
;; Permission to use, copy, modify, and/or distribute this software for
;; any purpose with or without fee is hereby granted, provided that the
;; above copyright notice and this permission notice appear in all
;; copies.
;;
;; THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
;; REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY
;; SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
;; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

(deftheme parchment
  "A light colorscheme inspired by Acme and Leuven.")

(defvar parchment-want-modify-tty-colors nil
  "Whether to redefine the terminal colors that Emacs knows about.
Set to non-nil if you're using a matching parchment terminal theme.")

(defmacro style-theme (theme &rest styles)
  "Apply a list of face styles associated with theme THEME.
Wraps `custom-theme-set-faces' with a compact syntax.

Each STYLE should be one of the following forms:

  (FACE FOREGROUND BACKGROUND [ATTRIBUTES])
  (FACE SPEC)

SPEC is passed directly to custom-theme-set-faces. If FOREGROUND or
BACKGROUND are nil then they will be skipped."
  (declare (indent 1))
  (let (forms)
    (while styles
      (pcase (pop styles)
        (`(,face ,fg ,bg . ,attrs)
         (push `(,'\` (,face ((t ,@(when fg `(:foreground (,'\, ,fg)))
                                 ,@(when bg `(:background (,'\, ,bg)))
                                 ,@attrs))))
               forms))
        (`(,face ((,class . ,attrs) . ,rest))
         (push `(,'\` (,face ((,class ,@attrs) ,@rest)))
               forms))))
    `(custom-theme-set-faces
      ',theme
      ,@(nreverse forms))))

(let ((black   "#000000") (pale-gray    "#eaeaea")
      (red     "#880000") (pale-red     "#ffeaea")
      (green   "#005500") (pale-green   "#eaffea")
      (brown   "#663311") (yellow       "#eeee9e")
      (blue    "#004488") (pale-blue    "#cceeff")
      (magenta "#770077") (pale-magenta "#ffeaff")
      (cyan    "#007777") (pale-cyan    "#eaffff")
      (beige   "#eeeecc") (pale-yellow  "#ffffea"))

  (defun parchment-modify-tty-colors ()
    (tty-color-define "black"          0 (tty-color-standard-values black))
    (tty-color-define "red"            1 (tty-color-standard-values red))
    (tty-color-define "green"          2 (tty-color-standard-values green))
    (tty-color-define "yellow"         3 (tty-color-standard-values brown))
    (tty-color-define "blue"           4 (tty-color-standard-values blue))
    (tty-color-define "magenta"        5 (tty-color-standard-values magenta))
    (tty-color-define "cyan"           6 (tty-color-standard-values cyan))
    (tty-color-define "white"          7 (tty-color-standard-values beige))
    (tty-color-define "brightblack"    8 (tty-color-standard-values pale-gray))
    (tty-color-define "brightred"      9 (tty-color-standard-values pale-red))
    (tty-color-define "brightgreen"   10 (tty-color-standard-values pale-green))
    (tty-color-define "brightyellow"  11 (tty-color-standard-values yellow))
    (tty-color-define "brightblue"    12 (tty-color-standard-values pale-blue))
    (tty-color-define "brightmagenta" 13 (tty-color-standard-values pale-magenta))
    (tty-color-define "brightcyan"    14 (tty-color-standard-values pale-cyan))
    (tty-color-define "brightwhite"   15 (tty-color-standard-values pale-yellow)))

  (when parchment-want-modify-tty-colors
    (add-hook 'tty-setup-hook #'parchment-modify-tty-colors))

  (style-theme parchment
    ;; FACE                     FOREGROUND   BACKGROUND   ATTRIBUTES
    (default                    black        pale-yellow)
    (bold                       nil          nil          :weight bold)
    (italic                     nil          nil          :slant italic)
    (bold-italic                nil          nil          :weight bold :slant italic)
    (underline                  nil          nil          :underline t)
    (shadow ((((type tty)) :foreground ,cyan
              (t :foreground "#808075"))))
    (link                       blue         nil          :underline t)
    (link-visited               magenta      nil          :underline t)
    (error                      red          nil)
    (warning                    red          nil)
    (success                    green        nil)

    ;; standard interface elements
    (cursor                     nil          black)
    (fringe                     black        pale-gray)
    (header-line                nil          pale-cyan    :box t)
    (highlight                  nil          pale-blue)
    (hl-line                    nil          beige)
    (isearch                    nil          pale-blue    :weight bold)
    (isearch-fail               red          pale-red)
    (lazy-highlight             nil          nil          :weight bold)
    (line-number                black        pale-gray)
    (linum                      nil          nil          :inherit line-number)
    (match                      nil          yellow)
    (menu                       nil          pale-cyan    :weight bold)
    (tty-menu-disabled-face     cyan         pale-cyan)
    (tty-menu-enabled-face      nil          pale-cyan)
    (tty-menu-selected-face     pale-yellow  cyan         :weight bold)
    (minibuffer-prompt          blue         nil)
    (mode-line                  pale-blue    blue         :box ,black)
    (mode-line-inactive         nil          pale-gray    :box t)
    (mode-line-highlight        black        yellow)
    (mode-line-buffer-id        nil          nil          :inherit mode-line-emphasis)
    (mode-line-emphasis ((((type tty)) :weight bold)
                         (t :foreground ,pale-yellow :distant-foreground ,black :weight bold)))
    (region                     nil          yellow)
    (show-paren-match           nil          pale-blue)
    (show-paren-mismatch        pale-yellow  red)
    (trailing-whitespace        red          pale-red)
    (whitespace-line            nil          nil          :inherit trailing-whitespace)
    (whitespace-trailing        nil          nil          :inherit trailing-whitespace)

    ;; generic syntax highlighting
    (font-lock-warning-face     red          nil)
    (font-lock-function-name-face nil        nil)
    (font-lock-variable-name-face nil        nil)
    (font-lock-keyword-face     nil          nil)
    (font-lock-comment-face     brown        nil          :slant italic)
    (font-lock-type-face        blue         nil)
    (font-lock-constant-face    nil          nil)
    (font-lock-builtin-face     blue         nil)
    (font-lock-preprocessor-face magenta     nil)
    (font-lock-string-face      green        nil)
    (font-lock-doc-face         green        nil)

    ;; filetype syntax highlighting
    (ledger-font-posting-date-face blue      nil)
    (ledger-occur-xact-face     nil          beige)
    (markdown-header-face-1     black        pale-gray    :weight bold :height 1.3 :overline t)
    (markdown-header-face-2     blue         pale-cyan    :weight bold :overline t)
    (markdown-header-face-3     green        pale-green   :weight bold :overline t)
    (markdown-header-face-4     brown        nil          :weight bold)
    (markdown-header-face-5     magenta      nil          :weight bold)
    (markdown-header-face-6     cyan         nil          :weight bold :slant italic)
    (markdown-blockquote-face   green        nil)
    (markdown-inline-code-face  blue         nil          :inherit fixed-pitch)
    (markdown-language-keyword-face cyan     nil)
    (markdown-list-face         nil          nil)
    (markdown-pre-face          blue         nil          :inherit fixed-pitch)
    (markdown-reference-face    nil          nil)
    (markdown-table-face        green        nil          :inherit markdown-code-face)
    (markdown-url-face          blue         nil)
    (message-header-name        blue         nil)
    (message-header-other       nil          nil)
    (message-header-to          nil          nil)
    (message-header-subject     black        pale-gray    :weight bold :overline t)
    (org-document-title         black        nil          :weight bold :height 1.8)
    (org-document-info          nil          nil)
    (org-document-info-keyword  cyan         pale-cyan)
    (org-meta-line              cyan         pale-cyan)
    (org-block-begin-line       black        pale-gray    :underline t)
    (org-block-end-line         black        pale-gray    :underline t)
    (org-block ((((type tty)) :background ,beige)
                (t :background "#f7f7db")))
    (org-level-1                black        pale-gray    :weight bold :height 1.3 :overline t)
    (org-level-2                blue         pale-cyan    :weight bold :overline t)
    (org-level-3                green        pale-green   :weight bold :overline t)
    (org-level-4                brown        nil          :weight bold)
    (org-level-5                magenta      nil          :weight bold)
    (org-level-6                cyan         nil          :weight bold :slant italic)
    (org-level-7                green        nil          :weight bold :slant italic)
    (org-level-8                brown        nil          :weight bold :slant italic)
    (org-table                  green        pale-green)
    (org-todo                   red          pale-red     :weight bold :box t)
    (org-done                   cyan         pale-cyan    :weight bold :box t)
    (outline-1                  black        pale-gray    :weight bold :height 1.3 :overline t)
    (outline-2                  blue         pale-cyan    :weight bold :overline t)
    (outline-3                  green        pale-green   :weight bold :overline t)
    (outline-4                  brown        nil          :weight bold)
    (outline-5                  magenta      nil          :weight bold)
    (outline-6                  cyan         nil          :weight bold :slant italic)
    (outline-7                  green        nil          :weight bold :slant italic)
    (outline-8                  brown        nil          :weight bold :slant italic)
    (rainbow-delimiters-depth-1-face nil     nil)
    (rainbow-delimiters-depth-2-face black   pale-gray)
    (rainbow-delimiters-depth-3-face blue    pale-cyan)
    (rainbow-delimiters-depth-4-face green   pale-green)
    (rainbow-delimiters-depth-5-face brown   beige)
    (rainbow-delimiters-depth-6-face magenta pale-magenta)
    (rainbow-delimiters-depth-7-face cyan    pale-cyan)
    (rainbow-delimiters-depth-8-face green   nil)
    (rainbow-delimiters-depth-9-face brown   nil)
    (rainbow-delimiters-mismatched-face red  pale-red     :weight bold)
    (rainbow-delimiters-unmatched-face red   pale-red     :weight bold)
    (rst-adornment              cyan         nil)
    (rst-directive              magenta      nil)
    (rst-literal                green        nil)
    (rst-reference              blue         nil)
    (rst-level-1                black        pale-gray    :weight bold :height 1.3 :overline t)
    (rst-level-2                blue         pale-cyan    :weight bold :overline t)
    (rst-level-3                green        pale-green   :weight bold :overline t)
    (rst-level-4                brown        nil          :weight bold)
    (rst-level-5                magenta      nil          :weight bold)
    (rst-level-6                cyan         nil          :weight bold :slant italic)
    (sh-quoted-exec             nil          nil)
    (vimrc-number               nil          nil)

    ;; package interface elements
    (custom-button-pressed-unraised magenta  nil          :underline t)
    (custom-changed             nil          nil          :inverse-video t :inherit custom-set)
    (custom-comment             black        pale-gray)
    (custom-comment-tag         blue         nil)
    (custom-group-tag           blue         nil          :weight bold :height 1.2 :inherit variable-pitch)
    (custom-group-tag-1         red          nil          :inherit custom-group-tag)
    (custom-invalid             red          pale-red     :weight bold)
    (custom-modified            nil          nil          :inherit custom-changed)
    (custom-rogue               pale-red     black)
    (custom-set                 blue         nil)
    (custom-state               green        nil)
    (custom-themed              nil          nil          :inherit custom-changed)
    (custom-variable-tag        blue         nil          :weight bold)
    (comint-highlight-input     blue         nil          :weight bold)
    (comint-highlight-prompt    blue         nil          :weight bold)
    (dired-directory            blue         nil          :weight bold)
    (dired-header               blue         nil          :weight bold)
    (dired-ignored              brown        nil)
    (dired-symlink              cyan         nil          :weight bold)
    (elfeed-search-date-face    blue         nil)
    (elfeed-search-feed-face    brown        nil)
    (elfeed-search-tag-face     green        nil)
    (eshell-ls-archive          nil          nil)
    (eshell-ls-backup           brown        nil)
    (eshell-ls-clutter          brown        nil)
    (eshell-ls-directory        blue         nil          :weight bold)
    (eshell-ls-executable       green        nil          :weight bold)
    (eshell-ls-missing          red          nil          :strike-through t :slant italic)
    (eshell-ls-product          nil          nil)
    (eshell-ls-readonly         nil          nil)
    (eshell-ls-special          magenta      nil)
    (eshell-ls-symlink          cyan         nil          :weight bold)
    (eshell-ls-unreadable       red          nil)
    (eshell-prompt              blue         nil          :weight bold)
    (info-title-1               black        pale-gray    :weight bold :height 1.3 :overline t)
    (info-title-2               blue         pale-cyan    :weight bold :overline t)
    (info-title-3               green        pale-green   :weight bold :overline t)
    (info-title-4               brown        nil          :weight bold)
    (info-header-node           magenta      nil          :underline t)
    (info-menu-header           blue         pale-cyan    :weight bold :overline t)
    (info-menu-star             nil          nil)
    (info-node                  blue         nil          :underline t)
    (ivy-current-match          pale-yellow  blue         :weight bold)
    (ivy-minibuffer-match-face-1 nil         pale-gray)
    (ivy-minibuffer-match-face-2 nil         pale-magenta :weight bold)
    (ivy-minibuffer-match-face-3 nil         pale-blue    :weight bold)
    (ivy-minibuffer-match-face-4 nil         yellow       :weight bold)
    (ivy-org                    green        nil)
    (ivy-remote                 magenta      nil)
    (ivy-confirm-face           green        nil)
    (ivy-match-required-face    red          nil)
    (ivy-cursor                 pale-yellow  black        :weight bold)
    (git-commit-comment-file    nil          nil)
    (magit-bisect-bad           red          nil)
    (magit-bisect-good          green        nil)
    (magit-bisect-skip          cyan         nil)
    (magit-blame-date           blue         nil)
    (magit-blame-highlight      black        pale-gray)
    (magit-blame-name           magenta      nil)
    (magit-branch-local         blue         nil)
    (magit-branch-remote        green        nil)
    (magit-cherry-equivalent    magenta      nil)
    (magit-cherry-unmatched     cyan         nil)
    (magit-diff-added           green        pale-green)
    (magit-diff-added-highlight nil          nil          :inherit magit-diff-added)
    (magit-diff-base            brown        beige)
    (magit-diff-base-highlight  nil          nil          :inherit magit-diff-base)
    (magit-diff-context         black        pale-gray)
    (magit-diff-context-highlight nil        nil          :inherit magit-diff-context)
    (magit-diff-file-heading-selection nil   nil          :inherit magit-diff-file-heading-highlight)
    (magit-diff-hunk-heading    cyan         pale-cyan)
    (magit-diff-hunk-heading-highlight magenta pale-magenta)
    (magit-diff-hunk-heading-selection nil   nil          :inherit magit-diff-hunk-heading-highlight)
    (magit-diff-lines-heading   pale-magenta magenta      :weight bold)
    (magit-diff-removed         red          pale-red)
    (magit-diff-removed-highlight nil        nil          :inherit magit-diff-removed)
    (magit-diffstat-added       green        nil)
    (magit-diffstat-removed     red          nil)
    (magit-dimmed               nil          nil          :inherit shadow)
    (magit-hash                 cyan         nil)
    (magit-header-line          nil          nil          :weight bold)
    (magit-keyword              blue         nil)
    (magit-log-author           magenta      nil)
    (magit-log-date             blue         nil)
    (magit-log-graph            cyan         nil)
    (magit-mode-line-process-error pale-red  nil          :distant-foreground ,red :weight bold)
    (magit-popup-key            magenta      nil)
    (magit-process-ng           red          nil          :weight bold)
    (magit-process-ok           green        nil          :weight bold)
    (magit-reflog-amend         magenta      nil)
    (magit-reflog-checkout      blue         nil)
    (magit-reflog-cherry-pick   nil          nil          :inherit magit-reflog-commit)
    (magit-reflog-commit        green        nil)
    (magit-reflog-merge         nil          nil          :inherit magit-reflog-commit)
    (magit-reflog-other         cyan         nil)
    (magit-reflog-rebase        magenta      nil)
    (magit-reflog-remote        cyan         nil)
    (magit-reflog-reset         red          nil)
    (magit-refname              cyan         nil)
    (magit-section-heading      brown        nil          :weight bold)
    (magit-section-heading-selection brown   nil)
    (magit-section-highlight    nil          pale-gray)
    (magit-sequence-drop        red          nil)
    (magit-sequence-head        blue         nil)
    (magit-sequence-part        brown        nil)
    (magit-sequence-stop        green        nil)
    (magit-signature-bad        red          pale-red     :weight bold)
    (magit-signature-error      red          nil)
    (magit-signature-expired    brown        nil)
    (magit-signature-expired-key nil         nil          :inherit magit-signature-expired)
    (magit-signature-good       green        nil)
    (magit-signature-revoked    magenta      nil)
    (magit-signature-untrusted  cyan         nil)
    (magit-tag                  brown        nil)
    (mu4e-modeline-face         pale-green   nil          :weight bold :distant-foreground ,green)
    (pass-mode-directory-face   blue         nil          :weight bold)
    (term-color-black           black        pale-gray)
    (term-color-red             red          pale-red)
    (term-color-green           green        pale-green)
    (term-color-yellow          brown        yellow)
    (term-color-blue            blue         pale-blue)
    (term-color-magenta         magenta      pale-magenta)
    (term-color-cyan            cyan         pale-cyan)
    (term-color-white           beige        pale-yellow)
    (which-key-docstring-face   nil          nil          :inherit font-lock-doc-face)
    (which-key-group-description-face blue   nil)
    (which-key-key-face         magenta      nil)
    (which-key-note-face        nil          nil          :inherit font-lock-comment-face)
    (which-key-separator-face   nil          nil))

  (custom-theme-set-variables 'parchment
   ;; shell-mode colors
   `(ansi-color-names-vector
     [,black ,red ,green ,brown ,blue ,magenta ,cyan ,beige])))

;;;###autoload
(when (and (boundp 'custom-theme-load-path)
           load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'parchment)
