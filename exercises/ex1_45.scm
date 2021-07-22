;pg133
(define tolerance 0.00001)

(define (fast_expt b n)
  (cond ((= n 0) 1)
  ((even? n) (square (fast_expt b (/ n 2))))
  (else (* b (fast_expt b (- n 1)))))
)

(define (compose f g) (lambda (x) (f (g x))))

(define (repeated f n)
  (define (iter counter res)
    (if (= counter n)
      res
      (iter (+ counter 1) (compose f res))))
  (iter 1 f))

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2) (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
    (if (close-enough? guess next)
      next
      (try next))))
  (try first-guess))

(define (average x y)
  (/ (+ x y) 2))
  
(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (mult x) (lambda (y) (* x y)))

(define (exp_fn x n) (lambda (y) ( / x (fast_expt y n) )))

(define (log2 x) (/ (log x) (log 2))) 

(define (n_root n x) 
  (fixed-point ((repeated average-damp (floor (log2 n))) (exp_fn x (- n 1))) 1.0))

(n_root 6 64)

;remember the order! we want to repeat average-damp ON exp_fn not repeat an average-damped exp_fn many times
;(avg-damp(avg-damp(avg-damp exp_fn))) VS ((avg-damp (exp_fn))((avg-damp (exp_fn))(avg-damp (exp_fn))))
; it is the difference between composing with the lambda underneath average damp and the average damp itself

;exp_fn -> avg-damp -> repeated -> fixed-point 
;               VS
;avg-damp -> repeated <- exp_fn 
;               |
;           fixed-point

; Notice the below are all equivalent
;((repeated (average-damp (exp_fn 8 3)) 2) 1)
;((average-damp (exp_fn 8 3))((average-damp (exp_fn 8 3)) 1))
;((average-damp (exp_fn 8 3))(/ 9 2))

; Why?
;(
;  (average-damp (exp_fn 8 3)) ;(lambda (x) (average x ((lambda (y) ( / 8 (fast_expt y 3) )) x))))
;  (
;    (average-damp (exp_fn 8 3)) 1 ;((lambda (x) (average x ((lambda (y) ( / 8 (fast_expt y 3) )) x)))) 1)
;  )                               ;(average 1 ((lambda (y) ( / 8 (fast_expt y 3) )) 1))))
;)                                 ;(average 1  ( / 8 (fast_expt 1 3) )))))
                                   ;9/2

