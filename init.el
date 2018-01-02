;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     javascript
     python
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     auto-completion
     better-defaults
     emacs-lisp
     git
     markdown
     org
     common-lisp
     journal
     ;; semantic ;; spacemacs layer for srefactor SPC m r	srefactor: refactor thing at point. (can be very slow on init.el)
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     ;; syntax-checking
     ;; version-control
     ;; windows-defaults ;; kills the tab key
     pdf-tools
     lua
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(;;cl ;; not sure if this is causing problems, texmathp complained about need of cl at runtime
                                      ;;texmathp
                                      ;;cdlatex can't do subscripts, something wrong with install
                                      interleave
                                      ob-ipython
                                      zotxt
                                      key-chord ;; for hh escape binding -- doesn't work in visual mode..
                                      ;; TODO: emacs-ereader is causing some error messages during startup
                                      ;; (emacs-ereader :location (recipe :fetcher github :repo "bddean/emacs-ereader"))
                                      ;; (scimax-org-babel-ipython :location (recipe :fetcher github :repo "jkitchin/scimax") :files ("scimax-org-babel-ipython.el"))
                                      real-auto-save
                                      excorporate
                                      evil-smartparens
                                      helm-ag
                                      ;; f
                                      ;; srefactor ;; semantic refactoring, semantic-refactor at point
                                      )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https nil
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   ;; https://themegallery.robdor.com/
   dotspacemacs-themes '(afternoon
                         spacemacs-dark
                         spacemacs-light)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers t
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode t
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis t
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  ;;(setenv "PATH" (concat (getenv "PATH") "~/.spacemacs.d/extraSoftware"))
  (setq exec-path (append exec-path '("~/.spacemacs.d/extraSoftware")))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;I can never find user-config in this huge file, so here's an obnoxious marker ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

;; Use the file name for the window title
  (setq frame-title-format "%b")

  (define-key evil-normal-state-map "l" 'evil-substitute)
  (define-key evil-normal-state-map "s" 'evil-forward-char)

  ;;(setq evil-escape-key-sequence "hh")
  (require 'key-chord)
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "hh" 'evil-normal-state)
  ;; for when you type something dumb and want to undo it without going back to normal mode.
  ;; maybe "hhu" is not so bad..
  ;;(key-chord-define evil-insert-state-map "uu" 'undo-tree-undo)
  (key-chord-mode 1)

  ;; I do not know of any way to show the whole file path.  So defining this function.
  (defun show-file-path ()
    "Show the full path file name in the minibuffer."
    (interactive)
    (message (buffer-file-name))
    (kill-new (file-truename buffer-file-name))
    )

  (global-set-key "\C-cz" 'show-file-path)

  (visual-line-mode)
  (setq evil-wait-fine-undo t)
  (setq line-move-visual t)
  ;; fallback font for unicode symbols, otherwithe sympy pprint doesn't work
  (set-fontset-font "fontset-default" nil
                      (font-spec :size 40 :name "Symbola"))
  ;; (setq undo-tree-auto-save-history t) ;; might cause corrupted undo history, need to try https://github.com/syl20bnr/spacemacs/issues/774
  (smartparens-global-mode t) ; use smartpares in all types of buffers, even in org-mode
  (smartparens-global-strict-mode t)
  (global-prettify-symbols-mode +1) ;
  (evil-smartparens-mode)
  (defvar pdf-info-epdfinfo-program "~/.spacemacs.d/extraSoftware/epdfinfo.exe")
  ;; end global keybindings

  (custom-set-variables ;; this is for helm-ag to use platinum searcher pt
    '(helm-ag-base-command "pt -e --nocolor --nogroup"))
  ;; (require 'helm)
  ;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  ;; (define-key helm-map (kbd "C-z") 'helm-select-action)
  ;; (setq helm-ag-fuzzy-match t)

  (setq helm-locate-command "es %s -sort run-count %s")
  (defun helm-es-hook ()
    (when (and (equal (assoc-default 'name (helm-get-current-source)) "Locate")
               (string-match "\\`es" helm-locate-command))
      (mapc (lambda (file)
              (call-process "es" nil nil nil
                            "-inc-run-count" (convert-standard-filename file)))
            (helm-marked-candidates))))
  (add-hook 'helm-find-many-files-after-hook 'helm-es-hook)  
  
  (setq org-base-path "~/../../Documents/private/notes/")
  (setq org-snippets-path "~/../../Documents/private/snippets/")
  (setq org-base-path-tasks  (concat org-base-path   "tasks.org"))
  (setq org-base-path-journal (concat org-base-path   "journal.org"))
  (setq org-base-path-meetings (concat org-base-path   "meetings.org"))

  (with-eval-after-load 'org
     (sp-pair "\[" "\]") ;; for latex fragments in org-mode
     (defun org-insert-image-from-clipboard ()
     ;; TODO: combine with normal C-v, write a program to check what is in the buffer
    (interactive)
    (let* (
       (the-dir (file-name-directory buffer-file-name))
       (the-file (file-name-nondirectory buffer-file-name))
       (attachments-dir (concat the-dir the-file ".attachments"))
       (png-file-name (format-time-string "%Y-%m-%d_%H%M%S.png"))
       (png-path (concat attachments-dir "/" png-file-name))
       (temp-buffer-name "CbImage2File-buffer"))
       (print (cons 'the-dir  the-dir))
       (print (cons 'temp-buffer-name  temp-buffer-name))
       (print (cons 'png-path  png-path))
      (call-process "~/.spacemacs.d/extraSoftware/addClipboard/CbImage2File.exe" nil temp-buffer-name nil png-path)
      (message "CbImage2File finished")
      (let ((result (with-current-buffer temp-buffer-name (buffer-string))))
        (progn
      (kill-buffer temp-buffer-name)
      (if (string= result "")
          (progn 
            (insert (concat "[[./" the-file ".attachments/" png-file-name "]]"))
            (org-display-inline-images))
        (insert result))))))


    (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (python . t)
       (ipython . t)
       (haskell . t)
       (js . t)
       (lisp . t)
       (latex . t)
       (C . t)
       (sql . t)
       (ditaa . t)))
    ;; (require 'ess-site)
    ;; (require 'ob-R)
    (require 'ob-emacs-lisp)
    (require 'ob-latex)
    (require 'ox-latex)
    (setq org-latex-inputenc-alist '(("utf8" . "utf8x")))
    (add-to-list 'org-latex-packages-alist '("" "unicode-math"))
    ;; (require 'octave)
    (require 'ob-python)
    ;; (require 'ob-sql)
    ;; (require 'ob-shell)
    ;; (require 'ob-sqlite)
    ;; (require 'ob-julia)
    ;; (require 'ob-perl)
    (require 'ob-org)
    ;; (require 'ob-awk)
    ;; (require 'ob-sed)
    ;; (require 'ob-css)
    ;; (require 'ob-js)
    ;; (require 'ob-stata)
    (setq org-export-babel-evaluate nil)
    (setq org-startup-indented t)
    (setq org-image-actual-width nil)
    ;; increase imenu depth to include third level headings
    (setq org-imenu-depth 3)
    (add-to-list 'org-src-lang-modes '("ipython" . python)) ;;use in case ipython is not recognized as a language
    ;; Set sensible mode for editing dot files
    (add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
    ;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex) ;; TODO: check if this is still causing problems
    ;; Update images from babel code blocks automatically
    (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
    (add-to-list 'org-structure-template-alist '("i" "#+BEGIN_SRC ipython :session :results output drawer \n?\n#+END_SRC"))
    (add-to-list 'org-structure-template-alist '("p" "#+BEGIN_SRC python\n?\n#+END_SRC"))
    ;; (load-file "scimax-org-babel-ipython.el")
    (setq org-src-fontify-natively t)
    (setq org-src-tab-acts-natively t)
    (setq org-support-shift-select t)
    (setq org-src-preserve-indentation t)
    ;; global keybindings
    (cua-mode t) ;; this conflicts with C-return
    (define-key org-mode-map (kbd "C-S-v") 'org-insert-image-from-clipboard)
    ;; (define-key evil-org-mode-map (kbd "<f6>") 'org-babel-execute-src-block)
    (evil-define-key '(normal motion insert visual) org-mode-map (kbd "<C-return>") 'org-babel-execute-src-block)
    ;;(evil-define-key '(normal motion insert visual) org-mode-map (kbd "C-return") 'org-babel)
    ;; TODO: call org-babel-execute async python / ipython depending on the type of code block we are in
    (evil-define-key '(normal motion insert visual) org-mode-map (kbd "<C-S-return>") 'org-babel-execute-buffer) 
    (evil-define-key '(normal motion insert visual) org-mode-map (kbd "C-<f6>") ;; TODO: set to ctrl-shift-enter
      (lambda () (interactive) (call-process "jupyter" nil 0 0 "qtconsole"  "--existing" "emacs-default.json")))
    (setq org-confirm-babel-evaluate nil)
    (load-file "~/.spacemacs.d/externalPackages/scimax/scimax-org-babel-ipython.el")
    (load-file "~/.spacemacs.d/externalPackages/scimax/scimax-org-babel-python.el")
    (add-to-list 'org-ctrl-c-ctrl-c-hook 'org-babel-execute-async:ipython)
    (setq org-priority-faces '((?A . (:foreground "red" :weight 'bold))
                              (?B . (:foreground "yellow"))
                              (?C . (:foreground "green"))))

    ;;(setq org-latex-create-formula-image-program 'dvisvgm)
    (setq org-preview-latex-default-process 'dvisvgm) ;; same as org-latex-create-formula-image-program, which is obsolete
    (custom-set-variables
     `(org-directory ,org-base-path))

    (setq org-latex-to-pdf-process
                                        '("xelatex -interaction nonstopmode %f"
                                          "xelatex -interaction nonstopmode %f"))

     ;; '(ORG-agenda-files (list org-directory)) ;; this causes problems, b/c org-directory is not evaluated. TODO: quasiquote
     (setq org-preview-latex-process-alist
   (quote
    ((dvipng :programs
             ("lualatex" "dvipng")
             :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
             (1.0 . 1.0)
             :latex-compiler
             ("lualatex -output-format dvi -interaction nonstopmode -output-directory %o %f")
             :image-converter
             ("dvipng -fg %F -bg %B -D %D -T tight -o %O %f"))
     (dvisvgm :programs
              ("latex" "dvisvgm")
              :description "dvi > svg" :message "you need to install the programs: latex and dvisvgm." :use-xcolor t :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
              (1.7 . 1.5)
              :latex-compiler
              ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
              :image-converter
              ("dvisvgm %f -n -b min -c %S -o %O"))
     (imagemagick :programs
                  ("latex" "convert")
                  :description "pdf > png" :message "you need to install the programs: latex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                  (1.0 . 1.0)
                  :latex-compiler
                  ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                  :image-converter
                  ("convert -density %D -trim -antialias %f -quality 100 %O")))))
     
    (setq latex-run-command "xelatex")

    (setq org-latex-compiler "xelatex")
    (setq org-latex-to-mathml-convert-command ;; for odt export
          "java -jar %j -unicode -force -df %o %I"
          org-latex-to-mathml-jar-file
          "~/.spacemacs.d/extraSoftware/mathtoweb.jar")
    (setq org-odt-preferred-output-format 'doc) ;; save to doc
    (setq org-latex-pdf-process 
          '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f" "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f" "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f") )
    (setq org-capture-templates
          `(("t" "Todo" entry (file+headline ,org-base-path-tasks "Tasks") "* TODO %?\n  %U\n%i\n%a")
            ("k" "Knowledge" entry (file+headline (concat ,org-base-path "knowledge.org") "Knowledge") "* %?\n  %U\n%i\n%a")
            ("s" "Todo (scheduled)" entry (file+headline ,org-base-path-tasks "Tasks")
               "* TODO %?\n  %^{Due}T  %U\n%i\n%a")
            ("p" "org-python" plain  (file (concat "" (read-file-name "Enter filename" org-snippets-path )))
            ;; ,(f-read-text (concat "~/.spacemacs.d/" "python-template.org") 'utf-8))
             (file "~/.spacemacs.d/python-template.org" ))
            ("j" "Journal" entry (file+datetree ,org-base-path-journal) "* %?\nEntered on %U\n  %i\n  %a")
            ("m" "Meeting" entry (file+datetree ,org-base-path-meetings) "* %? :meeting: \nEntered on %U\n  %i\n  %a")
            ))

    (setq org-todo-keywords
        '((sequence "TODO(t)" "IDEA(i)" "WAITING(w)" "|" "DONE(d)" "SOMEDAY(s)")))
    (add-hook 'org-mode-hook 'real-auto-save-mode)

    (visual-line-mode)

    )

  
  ;; real-auto-save
  (require 'real-auto-save)
  (add-hook 'prog-mode-hook 'real-auto-save-mode)
  (add-hook 'text-mode-hook 'real-auto-save-mode)
  (setq real-auto-save-interval 10) ;; in seconds
  ;; end real-auto-save
  ;; Universally stop asking for permission to kill processes.
  ;; NOTE: This is superior to modifying kill-buffer-query-functions,
  ;;       which only impacts `SPC b d' (but not e.g. `SPC q q')
  (defadvice process-query-on-exit-flag
      (around advice--process-query-on-exit-flag--never activate) nil)
  ;; global keybindings
  (cua-mode t)
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ORG-agenda-files (list org-directory))
 '(custom-safe-themes
   (quote
    ("28ec8ccf6190f6a73812df9bc91df54ce1d6132f18b4c8fcc85d45298569eb53" default)))
 '(helm-ag-base-command "pt -e --nocolor --nogroup")
 '(org-agenda-files
   (quote
    ("~/../../Documents/org/notes.org")))
 '(org-directory "~/../../Documents/org/")
 '(org-preview-latex-process-alist
   (quote
    ((dvipng :programs
             ("lualatex" "dvipng")
             :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
             (1.0 . 1.0)
             :latex-compiler
             ("lualatex -output-format dvi -interaction nonstopmode -output-directory %o %f")
             :image-converter
             ("dvipng -fg %F -bg %B -D %D -T tight -o %O %f"))
     (dvisvgm :programs
              ("latex" "dvisvgm")
              :description "dvi > svg" :message "you need to install the programs: latex and dvisvgm." :use-xcolor t :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
              (1.7 . 1.5)
              :latex-compiler
              ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
              :image-converter
              ("dvisvgm %f -n -b min -c %S -o %O"))
     (imagemagick :programs
                  ("latex" "convert")
                  :description "pdf > png" :message "you need to install the programs: latex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                  (1.0 . 1.0)
                  :latex-compiler
                  ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                  :image-converter
                  ("convert -density %D -trim -antialias %f -quality 100 %O")))))
 '(package-selected-packages
   (quote
    (zenburn-theme zen-and-art-theme underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme toxi-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme railscasts-theme purple-haze-theme professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme lush-theme light-soap-theme jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme gandalf-theme flatui-theme flatland-theme farmhouse-theme espresso-theme dracula-theme django-theme darktooth-theme autothemer darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme web-beautify lua-mode livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc company-tern tern coffee-mode stickyfunc-enhance srefactor evil-smartparens excorporate url-http-ntlm soap-client fsm ntlm real-auto-save zotxt request-deferred deferred org-journal ob-ipython dash-functional diminish avy packed smartparens highlight evil helm helm-core projectile hydra f latex-math-preview interleave pdf-tools tablist recentf-ext jump-char iy-go-to-char buffer-move better-shell smeargle slime-company slime orgit org-projectile org-present org org-pomodoro alert log4e gntp org-download mmm-mode markdown-toc markdown-mode magit-gitflow htmlize helm-gitignore gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md evil-magit magit magit-popup git-commit with-editor common-lisp-snippets mwim helm-company helm-c-yasnippet company-statistics company-anaconda company auto-yasnippet yasnippet ac-ispell auto-complete yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode helm-pydoc cython-mode anaconda-mode pythonic ws-butler window-numbering which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spacemacs-theme spaceline restart-emacs request rainbow-delimiters quelpa popwin persp-mode pcre2el paradox org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint info+ indent-guide ido-vertical-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump define-word column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
