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

;;; first attempt - doesn't work properly
; because the tree doesn't end up ordered properly because the non-leaf node weights are not considered
(define (successive-merge leaf-pairs)
  (if (null? (cdr leaf-pairs))
    (car leaf-pairs)
    (make-code-tree (car leaf-pairs) 
                    (successive-merge (cdr leaf-pairs)))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define pairs (list (list 'a 1) (list 'b 2) (list 'c 4) (list 'd 3)))
(generate-huffman-tree pairs) 

;; this works
 (define (successive-merge leaf-set) 
   (if (= (length leaf-set) 1) 
       (car leaf-set) 
       (let ((first (car leaf-set)) 
             (second (cadr leaf-set)) 
             (rest (cddr leaf-set))) 
         (successive-merge (adjoin-set (make-code-tree first second) rest))))) 

(generate-huffman-tree pairs) 
; How does it work?
; adjoin-set will work on because of the weight abstraction - it doesn't matter whether the set is represented
; as a list or tree. so what happens is successive-merge will go through each element - it will join adjacent items in 
; the leaf-set 2 at a time then adjoin-set will compare the weight of the resulting root to every other leaf. Note that
; leaf-set will eventually hold sub-trees that will eventually be joined by adjoin-set. 
; It's a little tricky because of this ambiguity between the data types - the fact that leaf-set could hold either subtrees 
; or leaf pairs