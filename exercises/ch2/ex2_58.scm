;;; a
(define (=number? exp num) (and (number? exp) (= exp num)))
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (sum? x) (and (pair? x) (eq? (cadr x) '+)))
(define (addend s) (car s))
(define (augend s) (caddr s))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
        (+ a1 a2))
        (else (list a1 '+ a2))))

(define (product? x) (and (pair? x) (eq? (cadr x) '*)))
(define (multiplier p) (car p))
(define (multiplicand p) (caddr p))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (deriv exp var)
  (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         ((sum? exp) (make-sum 
                        (deriv (addend exp) var)
                        (deriv (augend exp) var)))
         ((product? exp)
          (make-sum
            (make-product (multiplier exp)
                          (deriv (multiplicand exp) var))
            (make-product (deriv (multiplier exp) var)
                          (multiplicand exp))))
         (else
          (error "unknown expression type: DERIV" exp))))

(define expr '(x + (3 * (x + (y + 2)))))
(deriv expr 'x) ;Value: 4

(define expr '(x * (3 * (x + (y + 2)))))
(deriv expr 'x) ;Value: ((x * 3) + (3 * (x + (y + 2))))

;;; b
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

(define (sum? x) (and (pair? x) (eq? (cadr x) '+)))
(define (addend s) (car s))
(define (augend s) 
  (accumulate make-sum 0 (cddr s)))
(define (make-sum a1 a2)
  (cond ((or (=number? a1 0) (eq? '+ a1)) a2)
        ((or (=number? a2 0) (eq? '+ a2)) a1)
        ((and (number? a1) (number? a2))
        (+ a1 a2))
        (else (list a1 '+ a2))))

(define (product? x) (and (pair? x) (eq? (cadr x) '*)))
(define (multiplier p) (car p))
(define (augend s) 
  (accumulate make-product 1 (cddr s)))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((or (=number? m1 1) (eq? '* m1)) m2)
        ((or (=number? m2 1) (eq? '* m2)) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (deriv exp var)
  (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         ((sum? exp) (make-sum 
                        (deriv (addend exp) var)
                        (deriv (augend exp) var)))
         ((product? exp)
          (make-sum
            (make-product (multiplier exp)
                          (deriv (multiplicand exp) var))
            (make-product (deriv (multiplier exp) var)
                          (multiplicand exp))))
         (else
          (error "unknown expression type: DERIV" exp))))

(define expr '(x + 3 * (x + y + 2)) )
(deriv expr 'x)