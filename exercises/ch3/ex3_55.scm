(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (partial-sums s)
  (add-streams s (cons-stream 0 (partial-sums s))))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define s1 (partial-sums integers))

(stream-car s1)
(stream-cdr s1)

(stream-car (stream-cdr s1))
(stream-cdr (stream-cdr s1))

(stream-car (stream-cdr (stream-cdr s1)))
(stream-cdr (stream-cdr (stream-cdr s1)))

(stream-car (stream-cdr (stream-cdr (stream-cdr s1))))
(stream-cdr (stream-cdr (stream-cdr (stream-cdr s1))))