; NOTE, with the books manual implementation of streams (ie. below), you cannot recursively define a stream (ie. (define ones (cons-stream 1 ones)) will throw an error)
; I think this has something to do with the applicative evaluation - the arguments are evaluate first. 

; (define (delay x) (lambda () x))
; (define (force delayed-object)
;   (delayed-object))

; (define (cons-stream a b) (cons a (delay b)))
; (define (stream-ref s n)
;   (if (= n 0)
;       (stream-car s)
;       (stream-ref (stream-cdr s) (- n 1))))
; (define (stream-map proc . argstreams)
;   (if (null? (car argstreams))
;     the-empty-stream
;     (cons-stream (apply proc (map stream-car argstreams))
;                  (apply stream-map (cons proc (map stream-cdr argstreams))))))
; (define (stream-for-each proc s)
;   (if (stream-null? s)
;       'done
;       (begin (proc (stream-car s))
;              (stream-for-each proc (stream-cdr s)))))
; (define (stream-car stream) (car stream))
; (define (stream-cdr stream) (force (cdr stream)))
; (define (stream-filter pred stream)
;   (cond ((stream-null? stream) the-empty-stream)
;         ((pred (stream-car stream))
;          (cons-stream (stream-car stream)
;                       (stream-filter pred (stream-cdr stream))))
;         (else (stream-filter pred (stream-cdr stream)))))


(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x)
  (newline)
  (display x))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define s1 (stream-enumerate-interval 1 9))
(define s2 (stream-enumerate-interval 1 9))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

(define factorials (cons-stream 1 (mul-streams factorials integers)))

(stream-ref factorials 2)
(stream-ref factorials 3)
(stream-ref factorials 4)