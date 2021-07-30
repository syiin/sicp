(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    '()
    (cons (accumulate op init (map car seqs) )
          (accumulate-n op init (map cdr seqs)))))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define m (list (list 1 2 3)
                (list 4 5 6)
                (list 6 7 8)))
(define n (list (list 1 2 3)
                (list 4 5 6)
                (list 6 7 8)))
(define v (list 1 2 3))
(define w (list 2 2 2))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product v x)) m))

(matrix-*-vector m v) ;Value: (14 32 44)

(define (transpose mat)
  (accumulate-n cons '() mat))

(transpose m) ;Value: ((1 4 6) 
                    ;  (2 5 7) 
                    ;  (3 6 8))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
  (map (lambda (w) (matrix-*-vector cols w)) m)))

(matrix-*-matrix m n) ;Value: ((27 33 39) 
                            ;  (60 75 90) 
                            ;  (82 103 124))