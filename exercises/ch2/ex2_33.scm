; 189
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))
      ))
(define (filter predicate sequence)
  (cond ((null? sequence) '())
        ((predicate (car sequence))
        (cons (car sequence)
              (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) '() sequence))

(map square (list 1 2 3 4)) ;Value: (1 4 9 16)

(define (append seq1 seq2)
  (accumulate cons seq2 seq1)) 

(append (list 1 2 3) (list 4 5 6)) ;;Value: (1 2 3 4 5 6)

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(length (list 1 2 3 4 5 6)) ;Value: 6

