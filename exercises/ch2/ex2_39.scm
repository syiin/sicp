(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) '() sequence))

(reverse (list 1 2 3 4 5 6))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) '() sequence))

(reverse (list 1 2 3 4 5 6))