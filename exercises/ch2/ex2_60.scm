(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set) (cons x set))

(define (make-unique set)
  (define (iter e s acc)
    (cond ((null? s) acc)
          ((element-of-set? e acc) (iter (car s) (cdr s) acc))
          (else (iter (car s) (cdr s) (adjoin-set e acc)))))
  (iter (car set) (cdr set) '()))

(define (intersection-set set1 set2)
  (define (intersection s1 s2)
          (cond ((or (null? s1) (null? s2)) '())
                ((element-of-set? (car s1) s2)
                (cons (car s1) (intersection (cdr s1) s2)))
                (else (intersection (cdr s1) s2))))
  (intersection (make-unique set1) (make-unique set2)))

(define (union-set set1 set2)
  (define (union s1 s2)
          (cond ((or (null? s1) (null? s2)) 
                  s2 )
                ((not (element-of-set? (car s1) s2))
                  (cons (car s1) (union (cdr s1) s2)))
                (else 
                  (union (cdr s1) s2))))
  (union (make-unique set1) (make-unique set2)))

(define set-1 '(2 3 2 1 3 2 2))
(define set-2 '(3 3 3 3 6 6 6))
(intersection-set set-1 set-2)
(union-set set-1 set-2)

; This is more efficient when adjoining new items to the set but much less efficient when querying the set 
; to get intersections/unions. This implementation would be preferred when data insertion occurs more frequently
; than data access