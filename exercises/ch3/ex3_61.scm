(define (invert-unit-series s)
  (define inverted-stream
    (cons-stream 1 (stream-scale (mul-streams (stream-cdr s) 
                                              inverted-stream) 
                    -1))
  )
  inverted-stream
)