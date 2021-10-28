(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< s1car s2car)
                  (cons-stream s1car (merge (stream-cdr s1) s2)))
                 ((> s1car s2car)
                  (cons-stream s2car (merge s1 (stream-cdr s2))))
                 (else
                  (cons-stream s1car
                               (merge (stream-cdr s1)
                                      (stream-cdr s2)))))))))

; FIRST ATTEMPT
(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define twos (stream-filter (lambda (x) (= (remainder x 2) 0)) integers))
(define threes (stream-filter (lambda (x) (= (remainder x 3) 0)) integers))
(define fives (stream-filter (lambda (x) (= (remainder x 5) 0)) integers))
(define S (cons-stream 1 (merge (merge twos threes) fives)))

(stream-ref S 9)
(stream-ref S 10)
(stream-ref S 11)

; SECOND ATTEMPT? exactly what the book describes but misses 14 for some reason...? 
; What am I misunderstanding?
(define S (cons-stream 1 (merge (merge (scale-stream S 2) (scale-stream S 3)) 
                                 (scale-stream S 5))))

(stream-ref S 9)
(stream-ref S 10)
(stream-ref S 11)