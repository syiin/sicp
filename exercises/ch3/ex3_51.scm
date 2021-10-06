(define (stream-map proc . argstreams)
  (if (null? (car argstreams))
    the-empty-stream
    (cons (apply proc (map stream-car argstreams))
          (apply stream-map (cons proc (map stream-cdr argstreams))))))

(define (show x)
  (display-line x)
  x)

(define x 
  (stream-map show
    (stream-enumerate-interval 0 10)))

(stream-ref x 5) ; 1 2 3 4 5
(stream-ref x 7) ; 6 7

