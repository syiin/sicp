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
;;; DECODING 
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
;;; ENCODING 
(define (encode message tree) 
  (if (null? message) 
      '() 
      (append (encode-symbol (car message) tree) 
              (encode (cdr message) tree)))) 

(define (encode-symbol sym tree) 
  (if (leaf? tree) 
      (if (eq? sym (symbol-leaf tree)) 
          '() 
          (error "missing symbol: ENCODE-SYMBOL" sym)) 
      (let ((left (left-branch tree))) 
        (if (memq sym (symbols left)) 
            (cons 0 (encode-symbol sym left)) 
            (cons 1 (encode-symbol sym (right-branch tree))))))) 

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)    ; symbol
                               (cadr pair))  ; frequency
                    (make-leaf-set (cdr pairs))))))

(define (successive-merge leaf-set) 
   (if (= (length leaf-set) 1) 
       (car leaf-set) 
       (let ((first (car leaf-set)) 
             (second (cadr leaf-set)) 
             (rest (cddr leaf-set))) 
         (successive-merge (adjoin-set (make-code-tree first second) 
                                       rest))))) 

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define pairs (list (list 'a 2) (list 'boom 1) (list 'get 2) (list 'job 2) (list 'na 16) (list 'sha 3) (list 'yip 9) (list 'wah 1)))
(define tree (generate-huffman-tree pairs))
(define message (list 'get 'a 'job 'sha 'na 'na 'na 'na 'na 'na 'na 'na 'get 'a 'job 'sha 'na 'na 'na 'na 'na 'na 'na 'na 'wah 'yip 'yip 'yip 'yip 'yip 'yip 'yip 'yip 'yip 'sha 'boom))

(decode (encode message tree) tree)

(length (encode message tree)) ;220 bits were required to encode this with huffman trees
(* 3 (length message))         ;108 bits for fixed length code?