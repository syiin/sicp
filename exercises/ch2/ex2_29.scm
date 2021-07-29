(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (cadr mobile))
(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))

(define (total-weight mobile)
  (define (visit-branch branch)
  (let ((structure (branch-structure branch)))
  (if (pair? structure) 
      (total-weight structure) ;this means it is a mobile
      structure                ;if it's not a mobile, it must be a weight
  )))
  (+ (visit-branch (left-branch mobile))
     (visit-branch (right-branch mobile))))

(define branch-left (make-branch 3 1))
(define branch-right (make-branch 6 3))
(define mobile-1 (make-mobile branch-left branch-right))

(define branch-right-2 (make-branch 9 mobile-1))
(define mobile-2 (make-mobile branch-left branch-right-2))

mobile-2
(total-weight mobile-1) ;4
(total-weight mobile-2) ;5

(define balanced-mobile (make-mobile 
                         (make-branch 1 (make-mobile (make-branch 3 3) (make-branch 3 3))) 
                         (make-branch 1 (make-mobile (make-branch 3 3) (make-branch 3 3)))))
(define more-balanced-mobile (make-mobile 
                              (make-branch 1 balanced-mobile)
                              (make-branch 1 balanced-mobile)))

(define imbalanced-mobile (make-mobile 
                         (make-branch 3 (make-mobile (make-branch 12 2) (make-branch 2 12))) 
                         (make-branch 13 (make-mobile (make-branch 8 8) (make-branch 4 6)))))
(define more-imbalanced-mobile (make-mobile 
                              (make-branch 1 imbalanced-mobile)
                              (make-branch 1 imbalanced-mobile)))


(define (handle-branch branch)
  (define (branch-torque branch)
    (let ((branch-len (branch-length branch))
          (branch-struct (branch-structure branch)))
    (if (pair? branch-struct) 
        (* branch-len (total-weight (branch-structure branch)))
        (* branch-len branch-struct))))
  (define (structure-is-balanced? structure)
    (= (branch-torque (left-branch structure))
      (branch-torque (right-branch structure))))

  (let ((structure (branch-structure branch)))
  (if (pair? (branch-structure (branch-structure structure))) 
      (is-balanced? structure)
      (structure-is-balanced? structure))))

(define (is-balanced? mobile) 
  (and (handle-branch (left-branch mobile)) (handle-branch (right-branch mobile))))


(is-balanced? imbalanced-mobile)      ;#f
(is-balanced? balanced-mobile)        ;#t
(is-balanced? more-balanced-mobile)   ;#t
(is-balanced? more-imbalanced-mobile) ;#f

