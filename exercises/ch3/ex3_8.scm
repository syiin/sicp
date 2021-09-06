(define num 0)
(define times-called 0)
(define (f x)
  (if (and (> times-called 0) (= num 0)) 
    num
    (begin 
      (set! times-called (+ times-called 1)) 
      (if (= num 1) 
        (set! num 0) 
        (set! num x))
      num)))

(f 1)
(f 0)
