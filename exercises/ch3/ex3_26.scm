; Consider the tree from 2.65 - imagine each item as not just an integer but an key, value entry. 
; Sort them into an ordered set and construct the tree accordingly. 
; Or just work directly with the tree using left and right pointers

(define (make-record key value) (list (cons key value) '() '()))
(define (get-key record) (caar record))
(define (get-value record) (cdar record))
(define (overwrite-value! record value) (set-cdr! (car record) value))
(define (set-key! record key) (set-car! (car record) key))
(define (set-value! record value) (set-cdr! (car record) value))
(define (get-left record) (cadr record))
(define (get-right record) (caddr record))
(define (set-left! record new-left) (set-car! (cdr record) new-left))
(define (set-right! record new-left) (set-car! (cddr record) new-right))

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key) (get-value records))
        ((< key (get-key records)) (assoc (get-left records)))
        (else (assoc key (get-right records)))))

(define (add-record key value table)
  (define (iter record parent set-action)
    (cond ((null? record)       
            (let ((new-record (make-record key value))) 
                  (set-action parent new-record)
                  (car new-record)))
          ((equal? key (get-key record)) 
                  (set-value! record value)
                  (car record))
          ((< key (get-key record)) 
                  (iter (get-left record) record set-left!))
          (else 
                  (iter (get-right record) record set-right!))))
  (iter (cdr table) table set-cdr!))

(define (make-table)
  (let ((table (list '*table')))

  (define (lookup keys)
    (define (iter keys records)
      (if (null? keys) 
        records
        (let ((found (assoc (car keys) records)))
          (if found
            (iter (cdr keys) found)
            false))))
    (iter keys (cdr table)))

  (define (insert! keys value)
    (define (iter keys subtable)
      (if (null? (cdr keys))
          (add-record (car keys) value subtable)
          (let (new-record (add-record (car keys) '() subtable)) 
            (iter (cdr keys) new-record))))
    (iter keys table)
    'ok)

  (define (print) (display local-table) (newline)) 

  (define (dispatch m)
    (cond ((eq? m 'lookup) lookup)
          ((eq? m 'insert!) insert!)
          ((eq? m 'print) print)
          (error "Unknown operation TABLE" m)))
  dispatch
))

