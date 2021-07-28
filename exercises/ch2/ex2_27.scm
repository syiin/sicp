(define (reverse a-list)
  (define (tracker list-so-far acc-list)
    (if (null? list-so-far)
      acc-list
      (tracker (cdr list-so-far) (cons (car list-so-far) acc-list))))
  (tracker a-list '() ))

(define (deep-reverse a-list)
  (map reverse a-list))

(define x (list (list 1 2) (list 3 4)))
(reverse x)
(deep-reverse x)