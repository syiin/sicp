(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit -- CHOOSE-BRANCH" bit))))
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

;;; ENCODING PROCEDURES 

;;; first attempt, works here but doesn't work in ex2.70
(define (idx sym lst)
  (define (iter sym lst i) 
    (cond ((null? lst) 0)
          ((eq? sym (car lst)) i)
          (else (iter sym (cdr lst) (+ i 1)))))
  (iter sym lst 1))

(define (get-median-idx lst)
  (if (= (length lst) 2)
      1
      (quotient (- (length lst) 1) 2)))

(define (encode-symbol symbol tree)
  (define (which-branch sym tree)
    (let ((sym_idx (idx sym (symbols tree)))
          (median_idx  (get-median-idx (symbols tree))))
    (if (> sym_idx median_idx)
          (cons 1 (right-branch tree))
          (cons 0 (left-branch tree)))))
  (define (iter sym tree acc)
    (let ((branch-res (which-branch sym tree)))
    (let ((bit (car branch-res))
          (next-branch (cdr branch-res)))
    (if (leaf? tree)
      acc
      (iter sym next-branch (append acc (list bit)))))))
  (iter symbol tree '()))

;;; this works 
(define (encode-symbol sym tree) 
  (if (leaf? tree) 
      (if (eq? sym (symbol-leaf tree)) 
          '() 
          (error "missing symbol: ENCODE-SYMBOL" sym)) 
      (let ((left (left-branch tree))) 
        (if (memq sym (symbols left)) 
            (cons 0 (encode-symbol sym left)) 
            (cons 1 (encode-symbol sym (right-branch tree))))))) 

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                  (make-leaf 'B 2)
                  (make-code-tree (make-leaf 'D 1)
                                  (make-leaf 'C 1)))))

(encode '(a b c a a d) sample-tree)
(decode '(0 1 0 1 1 1 0 0 1 1 0)  sample-tree) 
(decode (encode '(a b c a a d a c d b) sample-tree) sample-tree)