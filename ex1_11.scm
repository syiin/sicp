(define (f_recur n)
  (if ( < n 3)
    n
    ( + 
      ( + 
          ( f_recur ( - n 1 ) )
          ( * 2 ( f_recur (- n 2 ) ) )
      )
      ( * 3 ( f_recur (- n 3 ) ) )
    )
  )
)

(define (iter n_1 n_2 n_3 counter max_count)
  (
    if ( > counter max_count ) 
    n_1
    (iter 
      (+ n_1 (+ (* n_2 2 ) (* n_3 3 )))
      n_1
      n_2
      (+ counter 1 )
      max_count
    )
  )
)

(define (f_iter n)
  (if ( < n 3)
    n 
    (iter 2 1 0 1 (- n 2))
  )
)

(f_recur 2)
(f_recur 6)

(f_iter 2)
(f_iter 6)





