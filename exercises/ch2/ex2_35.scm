;191

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
              (count-leaves (cdr x))))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))
      ))

(define (fringe tree)
  (cond ((null? tree) tree)
         ((not (pair? tree)) (list tree))
         (else 
           (append (fringe (car tree)) 
                   (fringe (cdr tree))))))
(define (count-leaves t)
  (accumulate +
              0
              (map (lambda (x) (if (null? x) 0 1))
                   (fringe t))))

(define tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))
(fringe tree)
(count-leaves tree)