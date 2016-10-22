(in-package :cl-user)
(defpackage searching-test
  (:use :cl
        :searching
        :searching.errors
        :searching.types
        :prove))
(in-package :searching-test)

;; NOTE: To run this test file, execute `(asdf:test-system :searching)' in your Lisp.


(defclass node (state)
  ((value
     :initform 0
     :accessor value-of
     :initarg :value)
   (left
     :initform nil
     :accessor left-of
     :initarg :left)
   (right
     :initform nil
     :accessor right-of
     :initarg :right)))

(defclass num-node (state)
  ((value 
     :initform 1
     :accessor value-of
     :initarg :value)))

(defclass city (state)
  ((value 
     :initform 1
     :accessor value-of
     :initarg :value)
   (from 
     :initform nil
     :accessor from-of
     :initarg :from)))


(defmethod next ((x city))
  (let ((city-map
          '((1 . (2 3))
            (2 . (1 6 7))
            (3 . (1 4 5 6))
            (4 . (3 6 7))
            (5 . (3))
            (6 . (2 3 4))
            (7 . (4)))))
    (mapcar 
      (lambda (y)
        (make-instance 'city
                       :value y
                       :from (cons (value-of x) (from-of x))))
      (cdr (assoc (value-of x) city-map)))))

(defmethod next ((x node))
  (let ((target  (remove-if #'null (list (left-of x) (right-of x)))))
    (when (null target) (error (make-condition 'dead-end :mes x)))
    target))

(defmethod next ((x num-node))
  (with-slots (value) x
    (list 
      (make-instance 'num-node :value (+ value value))
      (make-instance 'num-node :value (+ value value 1)))))
 



(plan 4)


(multiple-value-bind (value deepth) 
  (systematic-search 
    (make-instance 'iterative-deepening 
                   :initstate (make-instance 'node 
                                             :value 1 
                                             :left  (make-instance 'node 
                                                                   :value 2 
                                                                   :left nil 
                                                                   :right (make-instance 'node 
                                                                                         :value 10 
                                                                                         :left nil 
                                                                                         :right nil))  
                                             :right (make-instance 'node :value 3 :left nil :right nil))
                   :pred (lambda (node) (zerop (mod (value-of node) 100)))))
  (declare (ignore deepth))
  (ok (not value)))

(multiple-value-bind (value deepth) 
  (systematic-search 
    (make-instance 'iterative-deepening 
                   :initstate (make-instance 'node 
                                             :value 1 
                                             :left  (make-instance 'node 
                                                                   :value 2 
                                                                   :left nil 
                                                                   :right (make-instance 'node 
                                                                                         :value 10 
                                                                                         :left nil 
                                                                                         :right nil))  
                                             :right (make-instance 'node :value 3 :left nil :right nil))
                   :pred (lambda (node) (zerop (mod (value-of node) 3)))))
  (declare (ignore deepth))
  (ok value))

(multiple-value-bind (value deepth)
    (systematic-search 
      (make-instance 'iterative-deepening 
                     :initstate (make-instance 'num-node :value 1)
                     :pred (lambda (x) (= (value-of x) 3100000))))
    (declare (ignore deepth))
    (ok value))

(multiple-value-bind (value deepth)
    (systematic-search 
    (make-instance 'iterative-deepening 
                   :initstate (make-instance 'city)
                   :pred (lambda (x) (= (value-of x) 7))))
    (declare (ignore deepth))
    (ok value))


(finalize)

