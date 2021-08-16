(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;;; a
; in an underlying package for the operation type type (ie. +, -...etc), there is a table of procedures defined according to 
; operation. 
; eg. (put 'deriv '(+) sum_deriv)
; get will dispatch on the type and get the function in the package that will act on operands 
; eg. (get 'deriv '+)
; you can't use this for number? and same-variable? because numbers and symbols are primitives so they cannot be expressed as
; a list with an operator as the first item.

;;; b

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))))
        (set-cdr! table
                  (cons (list key-1
                              (cons key-2 value))
                        (cdr table)))))
  'ok)

(define (lookup key-1 key-2 table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (cdr record)
              false))
        false)))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))



; SUMMING
(define (install-sum-package)
  (define (=number? exp num) (and (number? exp) (= exp num)))
  (define (addend s) (car s)) ;remember that deriv already cars/cadrs out the operators/operands
  (define (augend s) (cadr s))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2))
          (+ a1 a2))
          (else (list '+ a1 a2))))
  (define (deriv-sum exp var) 
     (make-sum (deriv (addend exp) var) (deriv (augend exp) var))) 
  ;interface 
  (put 'deriv '+ deriv-sum)
)

; PRODUCTS
(define (install-product-package)
  (define (=number? exp num) (and (number? exp) (= exp num)))
  (define (multiplier p) (car p))
  (define (multiplicand p) (cadr p))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2))
          (+ a1 a2))
          (else (list '+ a1 a2))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) (* m1 m2))
          (else (list '* m1 m2))))
  (define (deriv-prod exp var) 
     (make-sum (make-product (multiplier exp)
                             (deriv (multiplicand exp) var))
               (make-product (deriv (multiplier exp) var)
                             (multiplicand exp))))
  ; interface
  (put 'deriv '* deriv-prod)
)

(install-sum-package)
(install-product-package)

(deriv '(+ x y) 'x)
(deriv '(* x y) 'x)


;;; c

; EXPONENTIATION
(define (install-expt-package)
  (define (=number? exp num) (and (number? exp) (= exp num)))
  (define (exponentiation? x) (eq? '** (car x)))
  (define (base x) (car x))
  (define (exponent x) (cadr x))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2))
          (+ a1 a2))
          (else (list '+ a1 a2))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) (* m1 m2))
          (else (list '* m1 m2))))
  (define (make-exponentiation base expt) 
    (cond ((=number? expt 0) 1)
          ((=number? expt 1) x)
          ((and (number? base) (number? expt)) (fast_expt base expt))
          (else (list '** base expt))))
  (define (make-subtract a1 a2) 
    (cond ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (- a1 a2))
          (else (list '- a1 a2))))
  (define (deriv-expt exp var) 
    (make-product (make-product (exponent exp)
                                (make-exponentiation (base exp) (make-subtract (exponent exp) 1)))
                  (deriv (base exp) var)))
  ; interface
  (put 'deriv '** deriv-expt)
)

(install-expt-package)
(deriv '(** x 3) 'x)

;;; d
; We would just need to swap the 'deriv and operator (ie. '+, '-) positions inside the put statements
; eg. (put 'deriv deriv-expt '**)
