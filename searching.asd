#|
  This file is a part of searching project.
|#

(in-package :cl-user)
(defpackage searching-asd
  (:use :cl :asdf))
(in-package :searching-asd)

(defsystem searching
  :version "0.1"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "errors")
                 (:file "types")
                 (:file "searching"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op searching-test))))
