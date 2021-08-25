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
(define (attach-tag type-tag contents)
  (if (number? type-tag)
      contents
      (cons type-tag contents)))
(define (type-tag datum)
  (cond ((number? datum) 'scheme-number)
        ((pair? datum) (car datum))
        (else (error "Bad tagged datum: TYPE-TAG" datum))))
(define (contents datum)
  (cond ((number? datum) datum)
        ((pair? datum) (cdr datum))
        (else (error "Bad tagged datum: CONTENTS" datum))))
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
  (let ((proc (get op type-tags)))
    (if proc
      (apply proc (map contents args))
      (error
        "No method for these types: APPLY-GENERIC"
        (list op type-tags))))))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))    
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))
  (put 'zero? '(scheme-number)
       (lambda (x) (= x 0)))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  'done)
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  (define (equ-rat x y)
    (and (= (numer x) (numer y))
         (= (denom x) (denom y))))
  (define (zero-rat x) (= (numer x) 0))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'equ? '(rational rational)
       (lambda (x y) (tag (equ-rat x y))))
  (put 'zero? '(rational)
       (lambda (x) (zero-rat x)))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done)
(define (make-rational n d)
  ((get 'make 'rational) n d))


(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (* r (cos a)) (* r (sin a))))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular 
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular 
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y) 
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar 
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)


(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  (define (magnitude z) (apply-generic 'magnitude z))
  (define (angle z) (apply-generic 'angle z))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))
  (define (equ-complex z1 z2)
    (and (= (magnitude z1) (magnitude z2))
         (= (angle z1) (angle z2))))
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'equ? '(complex complex)
       (lambda (z1 z2) (tag (equ-complex z1 z2))))
  (put 'zero? '(complex)
       (lambda (z) (= (magnitude z) 0)))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'real-part '(complex) real-part) 
  (put 'imag-part '(complex) imag-part) 
  (put 'magnitude '(complex) magnitude) 
  (put 'angle '(complex) angle)
  'done)
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

;;;; POLYNOMIALS
(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  ; variable checking
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (zero? z) (apply-generic 'zero? z))
  (define (sub x y) (apply-generic 'sub x y))
  ;; representation of terms and term lists

  (define (make-term order coeff) (list order coeff))
  (define (the-empty-termlist) '())
  (define (order term) (car term))
  (define (coeff term) (cadr term))
  (define (adjoin-term var term-list) 
    ((get 'adjoin-term (type-tag term-list)) var (contents term-list)))
  (define (empty-termlist? term-list) (apply-generic 'empty-termlist? term-list))
  (define (first-term term-list) (apply-generic 'first-term term-list))
  (define (rest-terms term-list) (apply-generic 'rest-terms term-list))

  ;ADDITION
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                    (add-terms (term-list p1)
                               (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
              (list p1 p2))))
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
          (let ((t1 (first-term L1)) (t2 (first-term L2)))
            (cond ((> (order t1) (order t2))
                    (adjoin-term t1 
                                 (add-terms (rest-terms L1) L2)))
                  ((< (order t1) (order t2))
                    (adjoin-term t2 
                                 (add-terms L1 (rest-terms L2))))
                  (else
                    (adjoin-term
                      (make-term (order t1)
                                 (add (coeff t1) (coeff t2)))
                      (add-terms (rest-terms L1)
                                 (rest-terms L2)))))))))
  ;MULTIPLICATION
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                         (mul-terms (term-list p1)
                             (term-list p2)))
        (error "Polys not in same var -- MUL-POLY"
              (list p1 p2))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (attach-tag (type-tag L1) (the-empty-termlist))
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (attach-tag (type-tag L) (the-empty-termlist))
        (let ((t2 (first-term L)))
          (adjoin-term
            (make-term (+ (order t1) (order t2))
                       (mul (coeff t1) (coeff t2)))
            (mul-term-by-all-terms t1 (rest-terms L))))))
  ;IS ZERO?
  (define (zero-poly? p)
    (define (iter-terms t-list)
      (if (null? (rest-terms t-list)) 
          (zero? (coeff (first-term t-list)))
          (and (zero? (coeff (first-term t-list))) (iter-terms (rest-terms t-list)))
      )
    )
    (iter-terms (term-list p))
  )
  ;SUBTRACTION
  (define (sub-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (sub-terms (term-list p1)
                             (term-list p2)))
        (error "Polys not in same var -- SUB-POLY"
              (list p1 p2))))
  (define (sub-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
          (let ((t1 (first-term L1)) (t2 (first-term L2)))
            (cond ((> (order t1) (order t2))
                    (adjoin-term t1 
                                 (sub-terms (rest-terms L1) L2)))
                  ((< (order t1) (order t2))
                    (adjoin-term t2 
                                 (sub-terms L1 (rest-terms L2))))
                  (else
                    (adjoin-term
                      (make-term (order t1)
                                 (sub (coeff t1) (coeff t2)))
                      (sub-terms (rest-terms L1)
                                 (rest-terms L2)))))))))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(polynomial polynomial) 
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'mul '(polynomial polynomial) 
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put 'zero? '(polynomial) 
       (lambda (p) (zero-poly? p)))
  'done)
(define (make-poly var terms)
  ((get 'make 'polynomial) var terms))

(define (install-sparse-package)
  ;;; term procedures
  (define (make-term-list term-list) term-list)
  (define (rest-terms term-list) (cdr term-list))
  (define (coeff term) (cadr term))
  (define (adjoin-term term term-list)
    (if (zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (first-term term-list) (car term-list))
  (define (zero? z) (apply-generic 'zero? z))
  (define (empty-termlist? term-list) (null? term-list))
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'sparse p))
  (put 'make-term-list 'sparse
       (lambda (terms) (tag (make-term-list terms))))
  (put 'rest-terms '(sparse)
       (lambda (term-list) (tag (rest-terms term-list))))
  (put 'adjoin-term 'sparse
       (lambda (var terms) (tag (adjoin-term var terms))))
  (put 'first-term '(sparse)
       (lambda (term-list) (first-term term-list)))
  (put 'empty-termlist? '(sparse)
       (lambda (term-list) (empty-termlist? term-list)))
  'done)

(define (install-dense-package)
  ;;; term procedures
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (make-term-list term-list) term-list)
  (define (rest-terms term-list) (cdr term-list))
  (define (coeff term) (cadr term))
  (define (adjoin-term term term-list) 
     (let ((coeff-term (coeff term)) 
           (order-term (order term)) 
           (length-terms (length term-list))) 
       (cond 
         ((= order-term length-terms) (cons coeff-term term-list)) 
         ((< order-term length-terms) (error "You can only add upwards!")) 
         (else (cons coeff-term (adjoin-term (make-term (- order-term 1) 0) term-list)))))) 
  (define (first-term term-list) 
     (make-term (- (length term-list) 1) 
                (car term-list)))
  (define (zero? z) (apply-generic 'zero? z))
  (define (empty-termlist? term-list) (null? term-list))
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'dense p))
  (put 'make-term-list 'dense
       (lambda (terms) (tag (make-term-list terms))))
  (put 'rest-terms '(dense)
       (lambda (term-list) (tag (rest-terms term-list))))
  (put 'adjoin-term 'dense
       (lambda (var terms) (tag (adjoin-term var terms))))
  (put 'first-term '(dense)
       (lambda (term-list) (first-term term-list)))
  (put 'empty-termlist? '(dense)
       (lambda (term-list) (empty-termlist? term-list)))
  'done)

(define (make-term-list-sparse terms)
  ((get 'make-term-list 'sparse) terms))
(define (make-term-list-dense terms)
  ((get 'make-term-list 'dense) terms))

(install-scheme-number-package)
(install-rational-package)
(install-rectangular-package)
(install-polar-package)
(install-complex-package)

(install-sparse-package)
(install-dense-package)
(install-polynomial-package)

(define (add x y) (apply-generic 'add x y))
(define (mul x y) (apply-generic 'mul x y))

(define polyA (make-poly 'x (make-term-list-sparse '((2 1) (1 1) (0 1))) ))
(define polyB (make-poly 'x (make-term-list-sparse '((1 3) (0 2)))))
(define polyZ (make-poly 'x (make-term-list-sparse '((3 0) (2 0) (1 0))) ))
(add polyA polyB)
(mul polyA polyB)

(define polyA (make-poly 'x (make-term-list-dense '(1 1 1))))
(define polyB (make-poly 'x (make-term-list-dense '(0 3 2))))
(add polyA polyB)
(mul polyA polyB)


;Types have to be assigned as closely as possible to the actual data that is that type 
;You can't define a polynomial subtype for sparse and dense on the polynomial structure itself. ie. (polynomial x (term stuff))
;You have to tag the term list itself since the operations depend on the term list for the closure property to hold 
;(ie. the result of adjoin-list is another term list)

;Problems with this solution is that bypassing apply-generic and calling get directly within the polynomial package feels like a
;leaky abstraction. Perhaps a better way to do it would be to write a special case of apply generic that takes only the type of the 
;1st argument allowing for a generic 2nd argument. Coercion would've made this better.
