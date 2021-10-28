(define (div-series s1 s2)
  (if (= (stream-car s2) 0) 
      (error "denom constant cannot be 0!")
      (mul-series (invert-unit-series s2) s1)))