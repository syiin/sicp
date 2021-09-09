(define counted-list '())
(define count 0)
(define (contains lsf i)
  (cond ((null? lsf) false)
        ((eq? (car lsf) i) true)
        (else (contains (cdr lsf) i))))
(define (has-counted? i)
  (contains counted-list i))
(define (count-item i) 
  (set! counted-list (cons i counted-list)))

; (define (count-pairs x)
;   (cond ((not (pair? x)) 0)
;         ((not (has-counted? (car x))) 
;           (begin 
;             (count-item (car x)) 
;             (+ 1 (count-pairs (cdr x)))))
;         (else (+ (count-pairs (car x)) 
;                  (count-pairs (cdr x)) 
;                  1))))

(define (count-pairs x)
  (cond ((not (pair? x)) 0)
        ((has-counted? x) 0)
        (else (begin 
                (count-item x)
                (+ (count-pairs (car x))
                  (count-pairs (cdr x))
                  1)))
  )
)


(count-pairs (list 'a 'b 'c))

(define second (cons 'a 'b))
(define third (cons 'a 'b))
(define first (cons second third))
(set-car! third second)
(count-pairs first)

(define third (cons 'a 'b))
(define second (cons third third))
(define first (cons second second))
(count-pairs first)

(define lst (list 'a 'b 'c)) 
(set-cdr! (cddr lst) lst) 
(count-pairs lst)  