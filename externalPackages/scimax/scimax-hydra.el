;;; scimax-hydra.el --- Hydras for scimax -*- lexical-binding: t; -*-

;;; Commentary:
;; The goal of this library is to emulate Spacemacs with hydras. You can access
;; a lot of the commands we use a lot with just 2-3 keystrokes. The hydras are
;; saved in a stack as you visit them so you can go to the previous one with ,
;; (comma). You can get to M-x by pressing x in any of these hydras, and / to
;; undo. Not every command will be shorter, e.g. C-a is shorter than f12 n a,
;; but this shows you tips of what you can do, and doesn't require any chording.
;;
;; This should not get in the way of any regular keybindings as you access all
;; of them through a single dispatch key (I use f12, which is remapped onto the
;; capslock key).
;;
;; At the moment this probably requires scimax, and has a number of Mac specific
;; things in it.

;; https://ericjmritz.wordpress.com/2015/10/14/some-personal-hydras-for-gnu-emacs/

(defgroup scimax-hydra nil
  "Customization for `scimax-hydra'."
  :tag "scimax-hydra")

(defcustom scimax-hydra-key "<f12>"
  "Key to bind `scimax/body' to."
  :type 'string
  :group 'scimax-hydra)

(global-set-key (kbd scimax-hydra-key) 'scimax/body)

;;* scimax-hydra utilities

;; Lexical closure to encapsulate the stack variable.
(lexical-let ((scimax-hydra-stack '()))
  (defun scimax-hydra-push (expr)
    "Push an EXPR onto the stack."
    (push expr scimax-hydra-stack))

  (defun scimax-hydra-pop ()
    "Pop an expression off the stack and call it."
    (interactive)
    (let ((x (pop scimax-hydra-stack)))
      (when x
	(call-interactively x))))

  (defun scimax-hydra ()
    "Show the current stack."
    (interactive)
    (with-help-window (help-buffer)
      (princ "Scimax-hydra-stack\n")
      (pp scimax-hydra-stack)))

  (defun scimax-hydra-reset ()
    "Reset the stack to empty."
    (interactive)
    (setq scimax-hydra-stack '())))

(defmacro scimax-open-hydra (hydra)
  "Push current HYDRA to a stack.
This is a macro so I don't have to quote the hydra name."
  `(progn
     (scimax-hydra-push hydra-curr-body-fn)
     (call-interactively ',hydra)))

(defun scimax-hydra-help ()
  "Show help buffer for current hydra."
  (interactive)
  (with-help-window (help-buffer)
    (with-current-buffer (help-buffer)
      (emacs-keybinding-command-tooltip-mode +1))
    (let ((s (format "Help for %s\n" hydra-curr-body-fn)))
      (princ s)
      (princ (make-string (length s) ?-))
      (princ "\n"))

    (princ (mapconcat
	    (lambda (head)
	      (format "%s%s"
		      ;;  key
		      (s-pad-right 10 " " (car head))
		      ;; command
		      (let* ((hint (if (stringp (nth 2 head))
				       (concat " " (nth 2 head))
				     ""))
			     (cmd (cond
				   ;; quit
				   ((null (nth 1 head))
				    "")
				   ;; a symbol
				   ((symbolp (nth 1 head))
				    (format "`%s'" (nth 1 head)))
				   ((and (listp (nth 1 head))
					 (eq 'scimax-open-hydra (car (nth 1 head))))
				    (format "`%s'" (nth 1 (nth 1 head))))
				   ((listp (nth 1 head))
				    (with-temp-buffer
				      (pp (nth 1 head) (current-buffer))
				      (let ((fill-prefix (make-string 10 ? )))
					(indent-code-rigidly
					 (save-excursion
					   (goto-char (point-min))
					   (forward-line)
					   (point))
					 (point-max) 10))
				      (buffer-string)))
				   (t
				    (format "%s" (nth 1 head)))))
			     (l1 (format "%s%s" (s-pad-right 50 " " (car (split-string cmd "\n"))) hint))
			     (s (s-join "\n" (append (list l1) (cdr (split-string cmd "\n"))))))
			(s-pad-right 50 " " s))))
	    (symbol-value
	     (intern
	      (replace-regexp-in-string
	       "/body$" "/heads"
	       (symbol-name  hydra-curr-body-fn))))
	    "\n"))))

(defhydra scimax-base (:color blue)
  "base"
  ("," scimax-hydra-pop "back" :color blue)
  ("x" counsel-M-x "M-x")
  ("<return>" save-buffer "Save")
  ("/" undo-tree-undo "undo" :color red)
  ("\\" undo-tree-redo "redo" :color red)
  ("8" (switch-to-buffer "*scratch*") "*scratch*")
  ("?" scimax-hydra-help "Menu help")
  ("." scimax-dispatch-mode-hydra "Major mode hydras")
  ("q" nil "quit"))

;;* scimax hydra

(defhydra scimax (:color blue :inherit (scimax-base/heads)
			 :columns 4 :body-pre (scimax-hydra-reset))
  "scimax"
  ("a" (scimax-open-hydra scimax-applications/body) "Applications")
  ("b" (scimax-open-hydra scimax-buffers/body) "Buffers")
  ;; c for user? compile?
  ;; d ?
  ("e" (scimax-open-hydra scimax-errors/body) "Edit/Errors")
  ("f" (scimax-open-hydra scimax-files/body) "Files")
  ("g" (scimax-open-hydra scimax-google/body) "Google")
  ("h" (scimax-open-hydra scimax-help/body) "Help")
  ("i" (scimax-open-hydra scimax-insert/body) "Insert")
  ("j" (scimax-open-hydra scimax-jump/body) "Jump")
  ("k" (scimax-open-hydra scimax-bookmarks/body) "Bookmarks")
  ("l" (scimax-open-hydra scimax-lisp/body) "Lisp")
  ("m" (scimax-open-hydra scimax-minor-modes/body) "Minor modes/mark")
  ("s-m" scimax-dispatch-mode-hydra "Major mode hydras")
  ("n" (scimax-open-hydra scimax-navigation/body) "Navigation")
  ("o" (scimax-open-hydra scimax-org/body) "org")
  ("p" (scimax-open-hydra hydra-projectile/body) "Project")
  ;; q is for quit, don't reassign
  ("r" (scimax-open-hydra scimax-registers/body) "Registers/resume")
  ("s" (scimax-open-hydra scimax-search/body) "Search")
  ("t" (scimax-open-hydra scimax-text/body) "Text")
  ;; u ?
  ("v" (scimax-open-hydra scimax-version-control/body) "Version control")
  ("w" (scimax-open-hydra scimax-windows/body) "Windows")
  ;; x is for M-x, don't reassign
  ;; y ?
  ("z" (scimax-open-hydra scimax-customize/body) "Customize"))


;;** applications

(defun scimax-app-hints ()
  "Calculate some variables for the applications hydra."
  (setq mu4e-unread
	(s-pad-right 12 " "
		     (format "email(%s)"
			     (shell-command-to-string
			      "echo -n $( mu find maildir:/INBOX flag:unread 2>/dev/null | wc -l )")))
	elfeed-count
	(s-pad-right 12 " "
		     (if (get-buffer "*elfeed-search*")
			 (format "RSS(%s)"
				 (car (s-split "/" (with-current-buffer "*elfeed-search*"
						     (elfeed-search--count-unread)))))
		       "RSS(?)"))))

(defhydra scimax-applications (:hint nil
				     :pre (scimax-app-hints)
				     :color blue
				     :inherit (scimax-base/heads))
  "
applications
Emacs             Mac            Web
-----------------------------------------------------
_n_: contacts     _a_: app       _c_: google calendar
_d_: dired        _f_: finder    _W_: tweetdeck
_e_: %12s`mu4e-unread _i_: iChat
_r_: %s`elfeed-count _o_: Office
_w_: twit         _s_: Safari
_j_: journal      _t_: Terminal
------------------------------------------------------
commands
_k_: list packages _m_: compose mail
------------------------------------------------------
"
  ("a" app)
  ("c" google-calendar)
  ("d" dired-x)
  ("e" (if (get-buffer "*mu4e-headers*")
	   (progn
	     (switch-to-buffer "*mu4e-headers*")
	     (delete-other-windows))
	 (mu4e)))
  ("f" finder)
  ("i" messages)
  ("j" journal/body)
  ("k" package-list-packages)
  ("m" compose-mail)
  ("n" ivy-contacts)
  ("r" elfeed)
  ("s" safari)
  ("t" terminal)
  ("w" twit)
  ("W" tweetdeck)
  ("o" (scimax-open-hydra scimax-office/body)))


(defhydra scimax-office (:color blue)
  "Office"
  ("e" excel"Excel")
  ("p" powerpoint "Powerpoint")
  ("w" word "Word"))

;;** buffers

(defhydra scimax-buffers (:color blue :inherit (scimax-base/heads) :columns 3 :hint nil)
  "
buffer
Switch                  ^Kill                Split        Misc
------------------------------------------------------------------
 _a_: ace-window        _k_: kill           _2_: below   _l_: list (%(length (buffer-list)))
 _b_: switch buffer     _K_: kill others    _3_: right   _r_: rename
 _o_: other-window      _A_: kill all
 _O_: switch other win  _m_: kill matching
 _n_: next buffer       _0_: delete win
 _p_: prev buffer       _1_: delete other
 _s_: scratch           _4_: kill buf/win
 _f_: other frame       _6_: kill some
 _F_: buf in frame      _y_: bury
------------------------------------------------------------------
"
  ("0" delete-window)
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)
  ("5" make-frame-command)
  ("4" kill-buffer-and-window)
  ("6" kill-some-buffers)
  ("a" ace-window :color red)
  ("b" switch-to-buffer)
  ("A" kill-all-buffers)
  ("f" other-frame :color red)
  ("F" switch-to-buffer-other-frame)
  ("k" kill-this-buffer :color red)
  ("K" kill-other-buffers)
  ("l" ibuffer)
  ("m" kill-matching-buffers :color red)
  ("n" next-buffer :color red)
  ("o" other-window :color red)
  ("O" switch-to-buffer-other-window :color red)
  ("p" previous-buffer :color red)
  ("s" (switch-to-buffer "*scratch*"))
  ("r" rename-buffer)
  ("y" bury-buffer))

;;** drag


(defhydra scimax-drag (:color red :inherit (scimax-base/heads)  :hint nil)
  ("<left>" drag-stuff-left :color red)
  ("<right>" drag-stuff-right :color red)
  ("<up>" drag-stuff-up :color red)
  ("<down>" drag-stuff-down :color red))


;;** edit/errors

(defhydra scimax-errors (:color blue :inherit (scimax-base/heads) :columns 3 :hint nil)
  "
edit/errors
Edit                Errors
------------------------------------------------------------------
_a_: edit abbrevs   _n_: next error
_c_: copy (dwim)    _p_: prev error
_k_: kill (dwim)
_v_: paste
_V_: paste ring
------------------------------------------------------------------
"
  ("a" edit-abbrevs)
  ("c" scimax-copy-dwim)
  ("v" yank)
  ("V" counsel-yank-pop)
  ("k" scimax-kill-dwim)
  ("n" next-error :color red)
  ("p" previous-error :color red))


;;** files
(defhydra scimax-files (:color blue :inherit (scimax-base/heads) :columns 3 :hint nil)
  "
files
------------------------------------------------------------------
_f_: find file     _R_: rename  _r_: recentf
_4_: other window  _k_: close   _l_: locate
_5_: other frame   _d_: dired
_p_: ffap
------------------------------------------------------------------"
  ("4" find-file-other-window)
  ("5" find-file-other-frame)
  ("b" describe-file)
  ("d" (dired default-directory))
  ("f" find-file)
  ("k" kill-this-buffer)
  ("l" counsel-locate)
  ("p" ffap)
  ("r" counsel-recentf)
  ("R" write-file))


;;** google
(defhydra scimax-google (:color blue :inherit (scimax-base/heads) :columns 3)
  "google"
  ("e" google-this-error "Error")
  ("f" google-this-forecast "Forecast")
  ("g" google-this-region "Region")
  ("k" google-this-lucky-search "Lucky")
  ("l" google-this-line "Line")
  ("m" google-maps "Maps")
  ("r" google-this-ray "Ray")
  ("s" google-this-search "Search")
  ("t" google-this "This")
  ("w" google-this-word "Word")
  ("y" google-this-symbol "Symbol"))

;;** help

(defhydra scimax-help (:color blue :inherit (scimax-base/heads) :columns 3)
  "help"
  ("a" apropos "Apropos")
  ("c" describe-command "Command")
  ("e" info-emacs-manual "Emacs manual")
  ("f" describe-function "Function")
  ("g" view-echo-area-messages "Messages")
  ("h" describe-theme "Theme")
  ("i" info "Info")
  ("k" describe-key "Key")
  ("K" describe-keymap "Keymap")
  ("m" describe-mode "Mode")
  ("o" ore "Org explorer")
  ("p" describe-package "Package")
  ("s" describe-syntax "Syntax")
  ("t" describe-text-properties "Text properties")
  ("T" help-with-tutorial "Emacs tutorial")
  ("v" describe-variable "Variable")
  ("S" scimax-help "Scimax help")
  ("w" woman "Woman"))


;;** insert

(defhydra scimax-insert (:color blue :inherit (scimax-base/heads) :columns 3)
  "help"
  ("b" insert-buffer "Buffer")
  ("c" insert-char "Char")
  ("e" ivy-insert-org-entity "Org-entity")
  ("f" insert-file "File")
  ("l" lorem-ipsum-insert-paragraphs "Lorem ipsum" :color red)
  ("p" insert-parentheses "Parentheses")
  ("r" insert-register "Register")
  ("s" screenshot "org screenshot")
  ("t" org-time-stamp "Timestamp"))

;;** jump

(defhydra scimax-jump (:color blue :inherit (scimax-base/heads) :columns 3)
  "jump"
  ("<" beginning-of-buffer "Beginning of buffer")
  (">" end-of-buffer "End of buffer")
  ("a" beginning-of-line "Beginning of line")
  ("d" ace-window "Ace window")
  ("e" end-of-line "End of line")
  ("c" (scimax-open-hydra scimax-jump-char/body) "Char")
  ("g" goto-line "Goto line")
  ("h" org-db-open-heading "org-db-heading")
  ("l" (scimax-open-hydra scimax-jump-line/body) "Line")
  ("k" ace-link "Link")
  ("o" (scimax-open-hydra scimax-jump-org/body) "Org")
  ("s" (scimax-open-hydra scimax-jump-symbol/body) "Symbol" )
  ("w" (scimax-open-hydra scimax-jump-word/body) "Word"))


(defhydra scimax-jump-char (:color blue :inherit (scimax-base/heads) :columns 3)
  "char"
  ("c" avy-goto-char "Char")
  ("l" avy-goto-char-in-line "In line")
  ("t" avy-goto-char-timer "Timer")
  ("2" avy-goto-char-2 "Char2")
  ("a" avy-goto-char-2-above "Above")
  ("b" avy-goto-char-2-below "Below"))


(defhydra scimax-jump-line (:color blue :inherit (scimax-base/heads) :columns 3)
  "line"
  ("a" avy-goto-line-above "Above")
  ("b" avy-goto-line-below "Below")
  ("l" avy-goto-line "Line"))


(defhydra scimax-jump-org (:color blue :inherit (scimax-base/heads) :columns 3)
  "org"
  ("a" ivy-org-jump-to-agenda-heading "Agenda heading")
  ("d" ivy-org-jump-to-heading-in-directory "Directory heading")
  ("h" ivy-org-jump-to-heading "Heading")
  ("o" ivy-org-jump-to-open-headline "Open heading")
  ("p" ivy-org-jump-to-project-headline "Project heading")
  ("v" ivy-org-jump-to-visible-headline "Visible heading"))


(defhydra scimax-jump-word (:color blue :inherit (scimax-base/heads) :columns 3)
  "word"
  ("0" avy-goto-word-0 "word0")
  ("1" avy-goto-word-1 "word1")
  ("a" avy-goto-word-0-above "above-0")
  ("A" avy-goto-word-1-above "above-1")
  ("b" avy-goto-word-0-below "below0")
  ("B" avy-goto-word-1-below "below1")
  ("o" avy-goto-word-or-subword-1 "word or subword")
  ("s" avy-subword-0 "subword-0")
  ("S" avy-subword-1 "subword-1"))


(defhydra scimax-jump-symbol (:color blue :inherit (scimax-base/heads) :columns 3)
  "symbol"
  ("a" avy-goto-symbol-1-above "Above")
  ("b" avy-goto-symbol-1-below "below")
  ("s" avy-goto-symbol-1 "symbol"))

;;** bookmarks

(defhydra scimax-bookmarks (:color blue :inherit (scimax-base/heads) :columns 3)
  "bookmarks"
  ("j" bookmark-jump "jump")
  ("l" bookmark-bmenu-list "list")
  ("n" bookmark-set "new"))

;;** lisp

(defhydra scimax-lisp (:color blue :inherit (scimax-base/heads) :columns 3 :hint nil)
  "lisp"
  ("a" eval-buffer "eval buffer")
  ("c" byte-recompile-file "byte-compile file")
  ("d" (eval-defun t) "debug defun")
  ("z" (eval-defun nil) "stop edebug")
  ("e" eval-defun "eval defun")
  ("v" eval-last-sexp "eval last sexp")
  ("g" (eval-region (point-min) (point)) "eval region")
  ("h" (describe-function 'lispy-mode) "lispy help")
  ("i" ielm "ielm")
  ("l" load-file "load file")
  ("r" eval-region "region")
  ("t" toggle-debug-on-error "toggle debug")
  ("y" edebug-on-entry "debug on entry"))

;;** mark/minor modes

(defhydra scimax-minor-modes (:color blue :inherit (scimax-base/heads) :columns 3 :hint nil)
  "
minor modes and marks
Marks                     minor-modes
------------------------------------------------------------------
_w_: mark word            _i_: aggressive indent
_n_: mark sentence        _b_: org-bullets
_p_: mark paragraph       _k_: emacs-keybindings
_g_: mark page            _l_: nlinum
_s_: mark sexp            _r_: rainbow
_d_: mark defun           _on_: org-numbered-headings
_a_: mark buffer
_e_: mark org-element
_m_: set mark
_j_: jump to mark
------------------------------------------------------------------
"
  ("i" aggressive-indent-mode)
  ("b" org-bullets-mode)
  ("k" emacs-keybinding-command-tooltip-mode)
  ("l" nlinum-mode)
  ("r" rainbow-mode)

  ("a" mark-whole-buffer)
  ("d" mark-defun)
  ("e" org-mark-element)
  ("g" mark-page)
  ("j" pop-to-mark-command)
  ("m" set-mark-command)
  ("n" mark-end-of-sentence)
  ("on" scimax-numbered-org-mode)
  ("p" mark-paragraph)
  ("s" mark-sexp)
  ("w" mark-word))


;;** navigation

(defhydra scimax-navigation (:color red :inherit (scimax-base/heads) :columns 4 :hint nil)
  "
navigation
-----------------------------------------------------------------------------------
_j_: ← _k_: ↑ _l_: ↓ _;_: →  _i_: imenu
_a_: beginning of line _e_: end of line _<_: beginning of buffer _>_: end of buffer

_H-w_: beginning of word _H-s_: beginning of sentence _H-p_: beginning of paragraph
_s-w_: end of word _s-s_: end of sentence _s-p_: end of paragraph

_f_: delete forward _d_: delete backward
_t_: transpose chars
_w_: word mode _s_: sentence mode _p_: paragraph mode
-----------------------------------------------------------------------------------
"
  ("j" backward-char)
  (";" forward-char)
  ("k" previous-line)
  ("l" next-line)
  ("i" counsel-imenu)
  ("a" beginning-of-line)
  ("e" end-of-line)
  ("f" delete-char :color red)
  ("d" backward-delete-char :color red)
  ("<" beginning-of-buffer)
  (">" end-of-buffer)
  ("t" transpose-chars)
  ("H-w" backward-word)
  ("H-s" backward-sentence)
  ("H-p" backward-paragraph)
  ("s-w" forward-word)
  ("s-s" forward-sentence)
  ("s-p" forward-paragraph)
  ("p" (scimax-open-hydra scimax-nav-paragraph/body) :color blue)
  ("w" (scimax-open-hydra scimax-nav-word/body) :color blue)
  ("s" (scimax-open-hydra scimax-nav-sentence/body) :color blue))


(defhydra scimax-nav-word (:color red :inherit (scimax-base/heads) :columns 4 :hint nil)
  "
word
----------------------------
_j_: ← _k_: ↑ _l_: ↓ _;_: →
_f_: kill forward _d_: kill backward
_t_: transpose words
------------------------------------------------------------------"
  ("j" backward-word)
  (";" forward-word)
  ("k" previous-line)
  ("l" next-line)
  ("f" (kill-word 1))
  ("d" backward-kill-word)
  ("t" transpose-words))


(defhydra scimax-nav-sentence (:color red :inherit (scimax-base/heads) :columns 4 :hint nil)
  "
sentence
_j_: ← _k_: ↑ _l_: ↓ _;_: →
_f_: kill forward _d_: kill backward
_t_: transpose sentences
------------------------------------------------------------------"
  ("j" backward-sentence)
  (";" forward-sentence)
  ("k" previous-line)
  ("l" next-line)
  ("d" (kill-sentence -1))
  ("f" kill-sentence)
  ("t" transpose-sentences))


(defhydra scimax-nav-paragraph (:color red :inherit (scimax-base/heads) :columns 4 :hint nil)
  "
paragraph
_j_: ← _k_: ↑ _l_: ↓ _;_: →
_f_: kill forward _d_: kill backward
_t_: transpose paragraphs
------------------------------------------------------------------"
  ("j" backward-paragraph)
  (";" forward-paragraph)
  ("k" previous-line)
  ("l" next-line)
  ("d" (kill-paragraph -1))
  ("f" (kill-paragraph nil))
  ("t" transpose-paragraphs))

;;** org

(defhydra scimax-org (:color blue :inherit (scimax-base/heads) :columns 3)
  "org-mode"
  ("'" org-edit-special "edit")
  ("a" org-agenda "agenda")
  ("b" (scimax-open-hydra scimax-org-block/body) "block")
  ("c" org-ctrl-c-ctrl-c "C-c C-c")
  ("d" (scimax-open-hydra scimax-org-db/body) "database")
  ("e" org-export-dispatch "Export")
  ("E" (scimax-open-hydra hydra-ox/body) "export")
  ("g" org-babel-tangle "tangle")
  ("h" ivy-org-jump-to-heading)
  ("i" org-clock-in)
  ("o" org-clock-out)
  ("m" (scimax-open-hydra scimac-email/body :color red))
  ("n" outline-next-heading "next heading" :color red)
  ("p" outline-previous-heading "previous heading" :color red)
  ("r" (scimax-open-hydra scimax-org-ref/body) "org-ref")
  ("t" (scimax-open-hydra scimax-org-toggle/body) "toggle"))

(defhydra scimax-email (:color red :inherit (scimax-base/heads))
  ("b" )
  )

(defhydra scimax-org-block (:color blue :inherit (scimax-base/heads) :columns 3)
  "org blocks"
  ("c" org-babel-remove-result "clear result")
  ("e" org-babel-execute-src-block "execute")
  ("n" org-next-block "next block")
  ("p" org-previous-block "previous block"))


(defhydra scimax-org-ref (:color blue :inherit (scimax-base/heads) :columns 3)
  "org-ref"
  ("b" org-ref-insert-bibliography-link "bibliography")
  ("c" org-ref-insert-link "cite")
  ("l" (org-ref-insert-link '(16)) "label")
  ("r" (org-ref-insert-link '(4)) "ref")
  ("o" org-ref "org-ref"))


(defhydra scimax-org-db (:color blue :inherit (scimax-base/heads) :columns 3)
  "org-db"
  ("h" org-db-open-heading "heading")
  ("f" org-db-open-file "file")
  ("l" org-db-open-link-in-file "link")
  ("r" org-db-open-recent-file "recent file"))


(defhydra scimax-org-toggle (:color blue :inherit (scimax-base/heads) :columns 3)
  "toggle"
  ("e" org-toggle-pretty-entities "pretty entities")
  ("i" org-toggle-inline-images "images")
  ("l" org-toggle-latex-fragment "latex"))

;; *** export

;; adapted from https://github.com/abo-abo/hydra/blob/master/hydra-ox.el

(defhydradio hydra-ox ()
  (body-only "Export only the body.")
  (export-scope "Export scope." [buffer subtree])
  (async-export "When non-nil, export async.")
  (visible-only "When non-nil, export visible only")
  (force-publishing "Toggle force publishing"))


(defhydra hydra-ox-html (:color blue)
  "ox-html"
  ("H" (org-html-export-as-html
        hydra-ox/async-export
        (eq hydra-ox/export-scope 'subtree)
        hydra-ox/visible-only
        hydra-ox/body-only)
   "As HTML buffer")
  ("h" (org-html-export-to-html
        hydra-ox/async-export
        (eq hydra-ox/export-scope 'subtree)
        hydra-ox/visible-only
        hydra-ox/body-only) "As HTML file")
  ("o" (org-open-file
        (org-html-export-to-html
         hydra-ox/async-export
         (eq hydra-ox/export-scope 'subtree)
         hydra-ox/visible-only
         hydra-ox/body-only)) "As HTML file and open")
  ("q" nil "quit"))


(defhydra hydra-ox-latex (:color blue)
  "ox-latex"
  ("L" org-latex-export-as-latex "As LaTeX buffer")
  ("l" org-latex-export-to-latex "As LaTeX file")
  ("p" org-latex-export-to-pdf "As PDF file")
  ("o" (org-open-file (org-latex-export-to-pdf)) "As PDF file and open")
  ("b" hydra-ox/body "back")
  ("q" nil "quit"))


(defhydra hydra-ox ()
  "
_C-b_ Body only:    % -15`hydra-ox/body-only^^^ _C-v_ Visible only:     %`hydra-ox/visible-only
_C-s_ Export scope: % -15`hydra-ox/export-scope _C-f_ Force publishing: %`hydra-ox/force-publishing
_C-a_ Async export: %`hydra-ox/async-export
"
  ("C-b" (hydra-ox/body-only) nil)
  ("C-v" (hydra-ox/visible-only) nil)
  ("C-s" (hydra-ox/export-scope) nil)
  ("C-f" (hydra-ox/force-publishing) nil)
  ("C-a" (hydra-ox/async-export) nil)
  ("h" hydra-ox-html/body "Export to HTML" :exit t)
  ("l" hydra-ox-latex/body "Export to LaTeX" :exit t)
  ("n" ox-ipynb-export-to-ipynb-file-and-open "Jupyter" :exit t)
  ("q" nil "quit"))


;;** project
;; https://github.com/abo-abo/hydra/wiki/Projectile

(defhydra hydra-projectile-other-window (:color teal)
  "projectile-other-window"
  ("f"  projectile-find-file-other-window        "file")
  ("g"  projectile-find-file-dwim-other-window   "file dwim")
  ("d"  projectile-find-dir-other-window         "dir")
  ("b"  projectile-switch-to-buffer-other-window "buffer")
  ("q"  nil                                      "cancel" :color blue))


(defhydra hydra-projectile (:color teal :hint nil)
  "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
 _fd_: file curr dir   _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
  _r_: recent file                                               ^^^^_z_: cache current
  _d_: dir

"
  ("a"   projectile-ag)
  ("b"   projectile-switch-to-buffer)
  ("c"   projectile-invalidate-cache)
  ("d"   projectile-find-dir)
  ("s-f" projectile-find-file)
  ("ff"  projectile-find-file-dwim)
  ("fd"  projectile-find-file-in-directory)
  ("g"   ggtags-update-tags)
  ("s-g" ggtags-update-tags)
  ("i"   projectile-ibuffer)
  ("K"   projectile-kill-buffers)
  ("s-k" projectile-kill-buffers)
  ("m"   projectile-multi-occur)
  ("o"   projectile-multi-occur)
  ("s-p" projectile-switch-project "switch project")
  ("p"   projectile-switch-project)
  ("s"   projectile-switch-project)
  ("r"   projectile-recentf)
  ("x"   projectile-remove-known-project)
  ("X"   projectile-cleanup-known-projects)
  ("z"   projectile-cache-current-file)
  ("`"   hydra-projectile-other-window/body "other window")
  ("q"   nil "cancel" :color blue))


;;** registers/resume/replace

(defhydra scimax-registers (:color blue :inherit (scimax-base/heads) :columns 3)
  "
register/resume/replace
Register                     Resume             Replace
------------------------------------------------------------------
_j_: jump to register        _h_: helm resume   _q_: query replace
_i_: insert regester         _v_: ivy resume    _x_: regexp replace
_c_: copy to register
_a_: append to register
_n_: number to register
_p_: point to register
_w_: window conf to register
_f_: frameset to register
_l_: list registers
------------------------------------------------------------------"
  ("a" append-to-register)
  ("c" copy-to-register)
  ("f" frameset-to-register)
  ("h" helm-resume)
  ("i" insert-register)
  ("j" jump-to-register)
  ("l" list-registers)
  ("n" number-to-register)
  ("p" point-to-register)
  ("q" query-replace)
  ("v" ivy-resume)
  ("w" window-configuration-to-register)
  ("x" query-replace-regexp))


;;** search

(defhydra scimax-search (:color blue :inherit (scimax-base/heads) :columns 3)
  "search"
  ("a" counsel-ag "ag")
  ("g" counsel-git-grep "grep")
  ("m" multioccur "moccur")
  ("o" occur "occur")
  ("p" projectile-grep "project grep")
  ("r" isearch-backward "search back")
  ("s" counsel-grep-or-swiper "search")
  ("t" counsel-pt "pt"))


;;** text

(defhydra scimax-text (:color blue :inherit (scimax-base/heads) :columns 3)
  "text"
  ("A" (mark-whole-buffer) "Select all")
  ("c" kill-ring-save "Copy")
  ("C" capitalize-dwim "Capitalize" :color red)
  ("d" downcase-dwim "Downcase" :color red)
  ("k" kill-region "Cut")
  ("l" kill-whole-line "Kill line" :color red)
  ("m" set-mark-command "Set mark" :color red)
  ("n" (scimax-open-hydra scimax-narrow/body) "narrow")
  ("s" (scimax-open-hydra scimax-spellcheck/body) "spell-check")
  ("S" sentence-case-region "Sentence case" :color red)
  ("t" (scimax-open-hydra scimax-transpose/body) "transpose")
  ("u" upcase-dwim "Upcase" :color red)
  ("v" yank "paste")
  ("w" count-words "count words")
  ("y" counsel-yank-pop "yank ring")
  (";" comment-dwim "comment")
  (":" uncomment-region "uncomment")
  ("b" comment-box "comment-box"))


(defhydra scimax-kill (:color blue :inherit (scimax-base/heads) :columns 3)
  "kill"
  ("c" kill-comment "comment")
  ("d" scimax-kill-dwim "kill dwim")
  ("l" kill-whole-line "line")
  ("p" kill-paragraph "paragraph")
  ("r" kill-region "region")
  ("s" kill-sentence "sentence")
  ("v" kill-visual-line "visual line")
  ("w" kill-word "word")
  ("x" kill-sexp "sexp"))


(defhydra scimax-narrow (:color blue :inherit (scimax-base/heads) :columns 3)
  "narrow"
  ("b" org-narrow-to-block "org-block")
  ("d" narrow-to-defun "defun")
  ("e" org-narrow-to-element "org element")
  ("p" narrow-to-page)
  ("r" narrow-to-region "region")
  ("s" org-narrow-to-subtree "org subtree")
  ("w" widen "widen"))


(defhydra scimax-spellcheck (:color red :inherit (scimax-base/heads) :columns 3)
  "spell"
  ("b" ispell-buffer "buffer")
  ("p" flyspell-correct-previous-word-generic "previous correct")
  ("n" flyspell-correct-next-word-generic "next correct")
  ("w" ispell-word "word"))


(defhydra scimax-transpose (:color red :inherit (scimax-base/heads) :columns 3)
  "transpose"
  ("c" transpose-chars "chars")
  ("l" transpose-lines "lines")
  ("p" transpose-paragraphs "paragraphs")
  ("s" transpose-sentences "sentences")
  ("x" transpose-sexps "sexps")
  ("w" transpose-words "words"))


;;** version control

(defhydra scimax-version-control (:color blue :inherit (scimax-base/heads) :columns 4)
  "vc"
  ("b" magit-branch-popup "Branch")
  ("c" magit-commit-popup "Commit")
  ("d" magit-diff-popup "Diff")
  ("f" magit-fetch-popup "Fetch")
  ("k" magit-checkout "Checkout")
  ("l" magit-log-all "Log")
  ("n" vc-next-action "Next action")
  ("p" magit-push-popup "Push")
  ("P" magit-pull-popup "Pull")
  ("r" magit-revert-popup "Revert")
  ("s" magit-stage "Stage")
  ("v" magit-status "Magit"))


;;** windows

(defhydra scimax-windows (:color blue :inherit (scimax-base/heads) :columns 4 :hint nil)
  "
Windows:
Switch             Delete               Split
------------------------------------------------------------------
_a_: ace-window    _0_: delete window   _2_: split below
_o_: other window  _1_: delete others   _3_: split right
_5_: other frame   _y_: bury buffer
_b_: buffers       _%_: delete frame
------------------------------------------------------------------
"
  ("a" ace-window)
  ("0" delete-window)
  ("b" (scimax-open-hydra scimax-buffers/body))
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)
  ("o" other-window)
  ("5" other-frame)
  ("%" delete-frame)
  ("y" bury-buffer))


;;** Customize

(defhydra scimax-customize (:color blue :inherit (scimax-base/heads) :hint nil :columns 3)
  "
Customize               Font
--------------------------------------------------------------
_t_: Theme              _+_: increase size
_c_: Customize Emacs    _-_: decrease size
_u_: Scimax user.el     _0_: reset size
_z_: Customize scimax   _f_: change font
---------------------------------------------------------------
"
  ("+" text-scale-increase :color red)
  ("-" text-scale-decrease :color red)
  ("0" (text-scale-adjust 0))
  ("c" customize)
  ("f" (ivy-read "Font: " (x-list-fonts "*")
		 :action
		 (lambda (font)
		   (set-frame-font font 'keep-size t))))
  ("t" helm-themes)
  ("u" scimax-customize-user)
  ("z" (customize-apropos "scimax")))



;;* Mode specific hydras
(defun scimax-dispatch-mode-hydra ()
  (interactive)
  (pcase major-mode
    ('emacs-lisp-mode (scimax-open-hydra scimax-lisp/body))
    ('elfeed-search-mode (scimax-open-hydra scimax-elfeed/body))
    ('mu4e-headers-mode (scimax-open-hydra scimax-mu4e/body))
    ('org-mode (message "org"))
    (_ (message "no mode-specific hydra found"))))

(global-set-key (kbd "<H-f12>") 'scimax-dispatch-mode-hydra)

(defhydra scimax-mu4e (:color red :hint nil)
  "
mu4e
_u_: Update"
  ("u" mu4e-update-mail-and-index))

(defhydra scimax-elfeed (:color red :hint nil)
  "
elfeed
_u_: Update"
  ("u" elfeed-update))

;;* the end

(provide 'scimax-hydra)

;;; scimax-hydra.el ends here
