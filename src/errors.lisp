
(in-package :cl-user)
(defpackage searching.errors
  (:use :cl)
  (:export 
    :search-error
    :search-limit-error
    :dead-end))
(in-package :searching.errors)



(define-condition search-error (error)
  ())


(define-condition search-limit-error (search-error)
  ())

(define-condition dead-end (search-error)
  ())
