(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y) ;(1 2 3 4 5 6) - just appended into one list
(cons x y)   ;((1 2 3) 4 5 6) - a pair pointed to two lists
(list x y)   ;((1 2 3) (4 5 6)) - (list, list, nil)