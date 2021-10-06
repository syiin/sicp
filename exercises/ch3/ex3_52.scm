(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum) ; sum = 0
(define seq
  (stream-map accum
    (stream-enumerate-interval 1 20))) ; sum = 1 (0 + 1)
(define y (stream-filter even? seq)) ; sum = 6 (1 + 2 + 3)
(define z
  (stream-filter (lambda (x) (= (remainder x 5) 0))
                  seq))  ; sum = 10 (6 + 4)
(stream-ref y 7) ; sum = 15 (10 + 5)
(display-stream z) ; sum = 210 (sum of numbers up to 20)