#|
  This file is a part of searching project.
|#

(in-package :cl-user)
(defpackage searching-test-asd
  (:use :cl :asdf))
(in-package :searching-test-asd)

(defsystem searching-test
  :author ""
  :license ""
  :depends-on (:searching
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "searching"))))
  :description "Test system for searching"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
