(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
    '()
     (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
                (cons x1 (intersection-set (cdr set1) (cdr set2))))
              ((< x1 x2)
                 (intersection-set (cdr set1) set2))
              ((< x2 x1)
                 (intersection-set set1 (cdr set2)))))))

(define (adjoin-set x set)
  (define (ordered-insert x first-half last-half)
    (if (> x (car last-half))
      (ordered-insert x (append first-half (list (car last-half))) (cdr last-half))
      (append first-half (cons x last-half))))
  (if (element-of-set? x set)
    set
    (ordered-insert x '() set)))

(adjoin-set 3 '(1 2 4))

