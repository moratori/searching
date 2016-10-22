(in-package :cl-user)
(defpackage searching.types
  (:use :cl)
  (:export

    :state

    :search-type
    :initstate-of
    :pred-of
    :initstate
    :pred

    :iterative-deepening
    )
  )
(in-package :searching.types)


(defclass state ()
  ())



(defclass search-type ()
  ((initstate 
     :initarg  :initstate
     :initform (error "initial state object is required")
     :accessor initstate-of
     :type state)
   (pred 
     :initarg :pred
     :initform (error "pred function is required")
     :accessor pred-of
     :type function)))

(defclass iterative-deepening (search-type)
  ())
 
