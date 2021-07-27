(define (last-pair a-list)
  (define (iter list-so-far last-res)
    (if (null? list-so-far) 
      last-res
      (iter (cdr list-so-far) (car list-so-far))))
  (iter (cdr a-list) (car a-list)))

(define some-list (list 1 2 3 4 5))

(last-pair some-list)