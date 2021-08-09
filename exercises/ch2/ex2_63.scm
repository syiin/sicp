;

(define (make-tree entry left right)
  (list entry left right))
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))
    )
  )
  (copy-to-list tree '()))

; a. both procedures are equivalent - because they parse the tree in the same order, top to bottom

(define branch-1 (make-tree 3 (make-tree 1 '() '()) (make-tree 5 '() '())) )
(define branch-2 (make-tree 9 '() (make-tree 11 '() '())) )
(define tree (make-tree 7 branch-1 branch-2) )

(tree->list-1 tree) ;Value: (1 3 5 7 9 11)
(tree->list-2 tree) ;Value: (1 3 5 7 9 11)

(define branch-2 (make-tree 9 '() (make-tree 11 '() '())) )
(define branch-1 (make-tree 7 (make-tree 5 '() '()) branch-2 ) )
(define tree (make-tree 3 branch-1 branch-2) )

(tree->list-1 tree) ;Value: (5 7 9 11 3 9 11)
(tree->list-2 tree) ;Value: (5 7 9 11 3 9 11)

(define branch-1 (make-tree 9 (make-tree 7 '() '()) (make-tree 11 '() '())))
(define tree (make-tree 5 (make-tree 3 (make-tree 1 '() '()) '()) branch-1))

(tree->list-1 tree) ;Value: (1 3 5 7 9 11)
(tree->list-2 tree) ;Value: (1 3 5 7 9 11)


; b. tree->list-1 will take more time than tree->list-2 because append takes O(n). 

;APPENDIX WORK

; Note that (append '() (cons 1 '())) returns ;Value: (1). that's why tree->list-1 works
; Also that copy-to-list returns result-list if the left branch is nil which is why tree->list-2 works

;(tree->list-2 (3 (1 '() '()) (2 '() '())))
;(copy-to-list (1 '() '())
;              (cons 3
;                    (copy-to-list (2 '() '())
;                                  '())))
;(copy-to-list (1 '() '())
;              (cons 3
;                    (copy-to-list (2 () ()) '())))
;(copy-to-list '()
;              (cons 1
;                    (copy-to-list '()
;                          (cons 3
;                              (copy-to-list (2 '() '()))))))
;(copy-to-list '()
;              (cons 1
;                    (copy-to-list '()
;                          (cons 3
;                              (copy-to-list '()
;                                        (cons 2
;                                              (copy-to-list '()
;                                                            '())))))))
;(copy-to-list '()
;              (cons 1
;                    (copy-to-list '()
;                          (cons 3
;                              (copy-to-list '()
;                                        (cons 2 '()))))))
;(copy-to-list '() 
;                (cons 1
;                    (copy-to-list '()
;                          (cons 3 (cons 2 '())))))
;(copy-to-list '()
;              (cons 1 (cons 3 (cons 2 '()))))
;(cons 1 (cons 3 (cons 2 '())))