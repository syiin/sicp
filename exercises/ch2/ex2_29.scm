(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (cadr mobile))
(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))

(define (visit-branch branch)
  (let ((structure (branch-structure branch)))
  (if (pair? structure) 
      (total-weight structure) ;this means it is a mobile
      structure                ;if it's not a mobile, it must be a weight
  )))

(define (total-weight mobile)
  (+ (visit-branch (left-branch mobile))
     (visit-branch (right-branch mobile)))
)

(define branch-left (make-branch 3 1))
(define branch-right (make-branch 6 3))
(define mobile-1 (make-mobile branch-left branch-right))

(define branch-right-2 (make-branch 9 mobile-1))
(define mobile-2 (make-mobile branch-left branch-right-2))

mobile-2
(total-weight mobile-1) ;4
(total-weight mobile-2) ;5