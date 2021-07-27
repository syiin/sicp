
(define (reverse a-list)
  (define (tracker list-so-far acc-list)
    (if (null? list-so-far)
      acc-list
      (tracker (cdr list-so-far) (cons (car list-so-far) acc-list))))

  (tracker a-list (cons (car a-list) '()) )
)

(define some-list (list 1 4 9 16 25))
(reverse some-list)
