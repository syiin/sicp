(define (install-poly-dense-package)
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
  ; (term1...) => ((order, coefficient)... )
  (define (adjoin-term term term-list)
    (if (zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))
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
                                 (sub (coeff t1) (coeff t2)))
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
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
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
  (define (tag p) (attach-tag 'poly-dense p))
  (put 'add '(poly-dense poly-dense) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(poly-dense poly-dense) 
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'mul '(poly-dense poly-dense) 
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'poly-dense
       (lambda (var terms) (tag (make-poly var terms))))
  (put 'make-term 'poly-dense
       (lambda (order coeff) (make-term order coeff)))
  (put 'zero? '(poly-dense) 
       (lambda (p) (zero-poly? p)))
  'done)

(define (make-poly-dense var terms)
  ((get 'make 'poly-dense) var terms))
(define (make-term order coeff)
  ((get 'make-term 'poly-dense) order coeff))

(define (install-poly-sparse-package)
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
  (define (adjoin-term term term-list) 
     (let ((coeff-term (coeff term)) 
           (order-term (order term)) 
           (length-terms (length term-list))) 
       (cond 
         ((= order-term length-terms) (cons coeff-term term-list)) 
         ((< order-term length-terms) (error "You can only add upwards!")) 
         (else (cons coeff-term (adjoin-term (make-term (- order-term 1) 0) term-list)))))) 
  (define (the-empty-termlist) '())
  (define (first-term term-list) 
     (make-term (- (length term-list) 1) 
                (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))
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
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
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
  (define (tag p) (attach-tag 'poly-sparse p))
  (put 'add '(poly-sparse poly-sparse) 
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(poly-sparse poly-sparse) 
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'mul '(poly-sparse poly-sparse) 
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'poly-sparse
       (lambda (var terms) (tag (make-poly var terms))))
  (put 'make-term 'poly-sparse
       (lambda (order coeff) (make-term order coeff)))
  (put 'zero? '(poly-sparse) 
       (lambda (p) (zero-poly? p)))
  'done)















(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly-sparse x y)
    ((get 'make-poly-sparse 'poly-sparse) x y))
  (define (make-poly-dense r a)
    ((get 'make-poly-dense 'poly-dense) r a))

  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  ; variable checking
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (zero? z) (apply-generic 'zero? z))
  (define (sub x y) (apply-generic 'sub x y))
  ;; representation of terms and term lists
  ; (term1...) => ((order, coefficient)... )
  (define (adjoin-term var terms) (apply-generic 'adjoin-term var terms))
  (define (first-term term-list) (apply-generic 'first-term term-list))
  (define (the-empty-termlist) '())

  ;ADDITION
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly-dense (variable p1)
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
        (make-poly-dense (variable p1)
                         (mul-terms (term-list p1)
                             (term-list p2)))
        (error "Polys not in same var -- MUL-POLY"
              (list p1 p2))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
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
        (make-poly-sparse (variable p1)
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
  (put 'make-poly-dense 'polynomial
       (lambda (var terms) (tag (make-poly-dense var terms))))
  (put 'make-poly-sparse 'polynomial
       (lambda (var terms) (tag (make-poly-sparse var terms))))
  (put 'make-term 'polynomial
       (lambda (order coeff) (make-term order coeff)))
  (put 'zero? '(polynomial) 
       (lambda (p) (zero-poly? p)))
  'done)

(define (make-poly-dense var terms)
  ((get 'make-poly-dense 'polynomial) var terms))
(define (make-poly-sparse var terms)
  ((get 'make-poly-sparse 'polynomial) var terms))



(define (install-poly-dense-package)
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (zero? z) (apply-generic 'zero? z))
  ;;; term procedures
  (define (adjoin-term term term-list)
    (if (zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'poly-dense p))
  (put 'make 'poly-dense
       (lambda (var terms) (tag (make-poly var terms))))
  (put 'adjoin-term 'poly-dense
       (lambda (var terms) (adjoin-term var terms)))
  (put 'first-term 'poly-dense
       (lambda (term-list) (first-term term-list)))
  'done)

(define (install-poly-sparse-package)
  (define (make-poly variable term-list)
    (cons variable term-list))
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
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'poly-sparse p))
  rest-terms
  empty-termlist
  make-term
  (put 'make-poly-sparse 'poly-sparse
       (lambda (var terms) (tag (make-poly var terms))))
  (put 'adjoin-term '(poly-sparse)
       (lambda (var terms) (adjoin-term var terms)))
  (put 'first-term '(poly-sparse)
       (lambda (term-list) (first-term term-list)))
  'done)



  (define (term-list p) (apply-generic 'term-list p))
  (define (adjoin-term var terms) (apply-generic 'adjoin-term var terms))
  (define (first-term term-list) (apply-generic 'first-term term-list))
  (define (the-empty-termlist) (apply-generic 'adjoin-term var terms))
  (define (empty-termlist? term-list) (apply-generic 'empty-termlist? term-list))
  (define (make-term order coeff) (apply-generic 'make-term order coeff))
  (define (order term) (apply-generic 'order term))
  (define (coeff term) (apply-generic 'coeff term))