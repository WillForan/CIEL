#|
  This file is a part of ciel project.
|#

(asdf:defsystem "ciel"
  :version "0.1"
  :author "vindarel"
  :license "MIT"
  :homepage "https://github.com/ciel-lang/CIEL/"
  :depends-on (
               :cl-reexport ;; for us
               :cl-ansi-text

               :access
               :alexandria
               :arrow-macros
               :fof  ;; file-object-finder

               ;; threads
               :bordeaux-threads
               :trivial-monitored-thread
               :moira
               :lparallel
               :cl-cron

               :closer-mop
               :cl-ansi-text
               :cl-csv
               :shasht
               :dissect
               :fset
               :generic-cl

               ;; web
               :dexador
               :hunchentoot
               :easy-routes ;; better route definition for Hunchentoot.
               :quri
               :lquery

               ;; GUI
               :ltk

               :local-time
               :modf

               ;; number parsing
               :parse-float
               :parse-number

               ;; database
               :dbi  ;; connects and executes queries.
               :sxql ;; SQL generator from lispy syntax.

               ;; numerical
               :vgplot

               ;; regexp
               :cl-ppcre

               ;; string manipulation
               :str

               ;;;
               ;;; Language extensions.
               ;;;
               ;; triple quotes
               :pythonic-string-reader

               ;; pattern matching
               :trivia
               :trivial-arguments
               :trivial-package-local-nicknames
               :trivial-types

               ;; extended let
               :metabang-bind

               ;; type declarations
               :defstar

               ;; iteration
               :for
               :trivial-do

               ;; lambda shorthands
               :fn
               :cl-punch

               :cmd
               :serapeum
               :shlex

               ;; tests
               :fiveam

               :which

               ;;;
               ;;; Debugging, developer utilities.
               ;;;
               :log4cl
               :printv
               :repl-utilities ;; see readme, summary, doc, package-apropos, trace-package etc

               ;;;
               ;;; User helpers.
               ;;; ;TODO: we don't want these dependencies when we build a binary.
               ;;;
               :named-readtables
               :clesh  ;; shell pass-through
               :quicksearch  ;; search on GitHub, Cliki, Quickdocs.
               )
  :components ((:module "src"
                        :components
                        ((:file "packages")
                         (:file "ciel")))
               (:module "src/more-docstrings"
                        :components
                        ((:file "docstrings"))))

  :description "CIEL Is an Extended Lisp.")

(asdf:defsystem "ciel/repl"
  :depends-on (;; :ciel  ;; let's avoid, it could run side effects twice (like a defparameter set then reset).
               ;; deps
               :cl-readline
               :cffi  ;; "tmp", for cl-readline add history
               :lisp-critic  ;; it would be nice to integrate it with Slime.
               :magic-ed)
  :components ((:file "repl")
               (:file "shell-utils")
               (:file "repl-utils"))

  :build-operation "program-op"
  :build-pathname "ciel-repl"
  :entry-point "sbcli::repl"

  :description "readline REPL for CIEL.")

;; Use compression: from 114M, 0.02s startup time to 27M and 0.42s (SBCL 2.0.10).
#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))
