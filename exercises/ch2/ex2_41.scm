; 198
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))
(define (enumerate-interval low high)
  (if (> low high)
    '()
    (cons low (enumerate-interval (+ low 1) high))))
(define (unique-triples n)
  (accumulate append '()
    (accumulate append '() 
              (map 
                (lambda (i) 
                  (map 
                    (lambda (j) 
                      (map (lambda (k) (list i j k)) 
                           (enumerate-interval 1 (- j 1))))
                    (enumerate-interval 1 (- i 1))))
                (enumerate-interval 1 n)))))

(define (sum-list a-list) 
  (if (null? a-list) 
    0
    (+ (car a-list) (sum-list (cdr a-list)))))
(define (sums-to-s? s) (lambda (a-list) ( = (sum-list a-list) s )))
(define (triple-sum n s) (filter (sums-to-s? s) (unique-triples n)))

(triple-sum 15 10)

