(in-package :cl-user)
(defpackage searching
  (:use :cl
        :searching.errors
        :searching.types)
  (:export 
    :next
    :systematic-search))
(in-package :searching)



(defmethod next ((x t))
  (error "next method must be implemented for subclass of state" ))


(defmethod systematic-search ((search-type iterative-deepening))
  (labels 
    ((inner (state pred limit) 

       (when (zerop limit)
         (error (make-condition 'search-limit-error)))
       (when (funcall pred state)
         (return-from inner state))

        (handler-case 

         (let (err)
           (loop 
             for each in (next state) 
             for ret = (handler-case (inner each pred (1- limit)) 
                                     (search-limit-error (c) c)) 
             do 
             (if (typep ret 'search-limit-error) 
               (setf err t)
               (when ret (return-from inner ret))))

           (if err
             (error (make-condition 'search-limit-error))
             (return-from inner nil)))

         (dead-end (c) (return-from inner nil)))))

    (with-slots (initstate pred) search-type
      (loop 
        for level from 1 do 
        (handler-case 
          (return-from systematic-search 
                       (values (inner initstate pred level) (1- level)))
          (search-limit-error (c)
             (declare (ignore c))))))))
