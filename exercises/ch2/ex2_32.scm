(define (subsets s)
  (if (null? s)
      (list '())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (append (list (car s)) x)) rest)))))

(subsets (list 1 2 3))

; the trick here is the recursion out means s stores the set elements and car means we only 
; get the outermost element - in effect, we get each element from inside out order

; (subsets '(1 2 3))
; rest ← (subsets '(2 3))
;        rest ← (subsets '(3))
;               rest ← (subsets '())
;                      '(())
;               (append '(()) (map (lambda (x) (append (list (car s)) x)) '(())))
;               '(() (3))
;        (append '(() (3)) (map (lambda (x) (append (list (car s)) x)) '(() (3))))
;        '(() (3) (2) (2 3))
; (append '(() (3) (2) (2 3)) (map (lambda (x) (append (list (car s)) x)) '(() (3) (2) (2 3))))
; '(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))

