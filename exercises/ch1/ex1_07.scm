// 1.7 for small numbers, 0.001 in good-enough? may be quite big and cause large errors 
//     for large numbers, you become prone to overflow and the last digits can be quite large
(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (improve guess x) guess))
     (abs (* guess 0.001))))