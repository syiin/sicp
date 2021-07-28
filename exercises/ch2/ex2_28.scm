(define (fringe tree)
  (define (iter tsf acc) 
    (cond ((null? tsf) acc)
          ((not (pair? tsf)) tsf)
          (else 
            (iter (cdr tsf) (append acc (car tsf))))
    )
  )
  (iter tree '())
)

(define (fringe tree)
  (cond ((null? tree) tree)
          ((not (pair? tree)) (list tree))
          (else 
            (append (fringe (car tree)) 
                    (fringe (cdr tree)))
          )
    )
)

(define x (list (list 1 2) (list 3 4)))
(fringe x)
(fringe (list x x))
