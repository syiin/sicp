
;pg133

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
  guess
  (sqrt-iter (improve guess x) x)))

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2) (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
    (if (close-enough? guess next)
      next
      (try next))))
  (try first-guess))

;ITERATIVE-IMPROVE

(define (iterative-improve good-enough? improve-guess)
  (define (iter guess)
    (if (good-enough? guess (improve-guess guess)) 
      guess
      (iter (improve-guess guess))
    ))
  (lambda (x) (iter (improve-guess x))))

; SQRT METHODS
(define (improve x)
  (lambda (guess) ( average guess (/ x guess))))

(define (sqrt-good-enough? x)
  (lambda (guess last_guess) (< (abs (- (square guess) x)) 0.001)))

(define (sqrt n)
  ((iterative-improve (sqrt-good-enough? n) (improve n)) 1))

(sqrt 4) ;21523361/10761680 = 2.00000009292
(sqrt 9) ;65537/21845 = 3.00009155413

; FIXED POINT

(define tolerance 0.00001)
(define dx 0.00001)

(define (fp-good-enough? guess last_guess) 
  (< (abs (- guess last_guess)) tolerance))

(define (fixed-point f first-guess)
  ((iterative-improve fp-good-enough? f) first-guess))

(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define (newton-transform g)
  (lambda (x) (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define (cubic_fact a b c)
  (lambda (x) (+ (+ (+ (* x x x ) (* a x x)) (* b x)) c))
)

(newtons-method (cubic_fact 3 2 1) 1) ; a function to approximate zeros of the cubic x3 + ax2 + bx + c, 
                                      ; ~= -2.32471