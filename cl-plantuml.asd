;;;; cl-plantuml.asd

(asdf:defsystem #:cl-plantuml
  :description "Simple server for generating plantuml diagrams"
  :author "Samuel Gagnon <samuel.gagnon92@gmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:uiop #:hunchentoot)
  :components ((:file "package")
               (:file "cl-plantuml")))
