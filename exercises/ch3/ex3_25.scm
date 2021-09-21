(define table (list '*table*))
(define keys '(a b c))
(define values '(1 2 3))

(define (make-table) (list '*table*))
(define (make-subtable) (cons '() '()))

(define (make-record key value) (cons key value))
(define (overwrite-record record value) (set-cdr! record value))
(define (add-record record table)
  (if (null? (car table))
    (set-car! table record)
    (set-cdr! table
              (cons record (cdr table)))))
(define (make-nested keys value)
  (if (null? (cdr keys))
    (make-record (car keys) value)
    (list (car keys) (make-nested (cdr keys) value))))

(define (assoc key records)
      (cond ((null? records) false)
            ((equal? key (caar records)) (car records))
            (else (assoc key (cdr records)))))

(define (insert! keys value table)
  (let ((subtable (assoc (car keys) (cdr table))))
    (if (null? (cdr keys))
      ; if last key (ie. no longer nested)
      (if subtable
        (overwrite-record subtable value)
        (add-record (make-record (car keys) value) table)
      )
      ; if not last key insertion
      (if subtable
        (insert! (cdr keys) value subtable)
        (add-record (make-nested keys value) table)
      )
    )))

(define (lookup keys table)
  (let ((subtable (assoc (car keys) (cdr table))))
    (if (null? (cdr keys))
      (if subtable 
        (cdr subtable)
        false
      )
      (if subtable
        (lookup (cdr keys) subtable)
        false
      )
    )
  )
)

(define table (make-table))
(insert! '(a b c) 3 table)
(insert! '(a b d) 6 table)
(insert! '(a c d) 9 table)
(insert! '(a b c) 8 table)

table

(lookup '(a b c) table)
(lookup '(a b d) table)
(lookup '(a c d) table)

(lookup '(b b b) table)
