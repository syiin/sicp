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

(list->tree '(1 3 5 7 9 11))

;;; a

;     5
;   /   \
; 1      9
;   \   / \
;    3 7   11


; Think of the tree as being built from bottom to top, left to right:
; 1. Partial tree returns this structure (branch tree, elements)
; 2. Left size and right size set the number of items in each branch so when n is 0, branch tree is nil
; 4. ie. if left-size = 0 and right-size=0, right-result=nil and left-result=nil
; 3. Because we take (n-1)/2/n - (n-1)/2 as the left/right sizes, the depth will be log_2 n
; 4. At any given depth, we first create the left tree, get back the elements not used in that tree
; 5. Car off the element not used in that left tree and pass the rest to construct the right tree
; 6. Construct the remaining 

; IN PYTHON
; def partial_tree(elts n)
;   if n == 0:
;     return (None, elts) 
;   left_size = quotient((n - 1), 2) #ie. how many items on this branch
;   right_size = n - (left_size + 1)
;
;   # make left tree
;   left_result = partial_tree(elts, left_size)
;   left_tree = left_result[0]
;   non_left_elts = elts[1:]
;
;   # make right tree
;   right_result = partial_tree(non_left_elts, right_size)
;   right_tree = right_result[0]
;   remaining_elts = right_result[1:]
;
;   # remove the current node entry and pass the remaining elements back
;   this_entry = non_left_elts[0]
;   return (make_tree (this-entry, left_tree, right_tree) remaining_elts)


;;; b

; O(n) because each element is visited exactly once