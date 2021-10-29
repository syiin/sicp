(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (partial-sums s)
  (add-streams s (cons-stream 0 (partial-sums s))))

(define (ln-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (ln-summands (+ n 1)))))
(define ln-stream
  (partial-sums (ln-summands 1)))


(define (stream-limit s tol)
  (define (iter guess sofar)
    (if (< (abs (- guess (stream-car sofar))) tol)
      guess
      (iter (stream-car sofar) (stream-cdr sofar))
    )
  )
  (iter (stream-car s) (stream-cdr s))
)

(define (ln tolerance)
  (stream-limit ln-stream tolerance))

(ln 0.001)