(car (cdr (cadr (cdr (list 1 3 (list 5 7) 9))))) ;7

(car (car (list (list 7)))) ;7

(define a-list (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))
(cadr (cadr (cadr (cadr (cadr (cadr a-list)))))) ;7
