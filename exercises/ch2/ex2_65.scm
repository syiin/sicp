(define (make-tree entry left right)
  (list entry left right))
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

(define (union-lists list1 list2)
  (cond ((and (null? list1) (null? list2)) '())
         ((and (null? list1) (not (null? list2))) list2)
         ((and (not (null? list1)) (null? list2)) list1)
         (else (let ((x1 (car list1)) (x2 (car list2)))
                (cond ((= x1 x2)
                        (union-lists (cdr list1) list2))
                      ((< x1 x2)
                        (cons x1 (union-lists (cdr list1) list2)))
                      ((< x2 x1)
                        (cons x2 (union-lists list1 (cdr list2)))))))))

(define (union-set set1 set2)
  (list->tree (union-lists (tree->list set1) (tree->list set2))))

(define (intersection-lists set1 set2)
  (if (or (null? set1) (null? set2))
    '()
     (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
                (cons x1 (intersection-lists (cdr set1) (cdr set2))))
              ((< x1 x2)
                 (intersection-lists (cdr set1) set2))
              ((< x2 x1)
                 (intersection-lists set1 (cdr set2)))))))

(define (intersection-set set1 set2)
  (list->tree (intersection-lists (tree->list set1) (tree->list set2))))

(define set1 (list->tree '(1 3 5 7 9)))
(define set2 (list->tree '(2 4 6 8 10)))
(define set3 (list->tree '(1 2 3 4 5)))

(union-set set1 set2)         ;Value: (6 (3 (1 () (2 () ())) (4 () (5 () ()))) (9 (7 () (8 () ())) (11 (10 () ()) (12 () ()))))
(intersection-set set1 set3)  ;Value: (3 (1 () ()) (5 () ()))
