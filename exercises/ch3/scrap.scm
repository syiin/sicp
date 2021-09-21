
(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (overwrite-record record value)
              (add-record-to-table (make-record key-2 value) subtable)
          ))
        (add-record-table-table (list key-1 (make-record key-2 value)) table)
    )
  )
  'ok)

(define (insert! keys value table)
  (let ((subtable-record (assoc (car keys) (cdr table))))
    (if (null? (cdr keys)) 
      (if subtable-record
        (overwrite-record record value)
        (add-record-to-table (make-record (car keys) value) subtable-record)
        )
      (insert! (cdr keys) value (cons (list (car keys)) (cdr table)))
    )
  )
)

(define (insert! keys value table)
      (let ((subtable (assoc (car keys) (cdr table))))
        (if (null? (cdr keys))
          (if subtable
            (overwrite-record subtable value)
            (add-record-to-table (make-record (car keys) value) subtable))
          (if subtable
            (insert! (cdr keys) value subtable)
            (set-cdr! subtable (cons (list (car keys)) (cdr subtable)))
          )
        )
      )
    )

(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))
          )
        )
        (set-cdr! table
                  (cons (list key-1
                              (cons key-2 value))
                        (cdr table)))))
  'ok)

(define (insert! keys value table)
      (let ((subtable (assoc (car keys) (cdr table))))
        (if (null? (cdr keys))
          (if subtable
            (set-cdr! record value)
            (set-cdr! subtable
                      (cons (cons (car keys) value)
                            (cdr subtable)))
          (if subtable
            (insert! (cdr keys) value subtable)
            (set-cdr! subtable (cons (list (car keys) (cons )) (cdr subtable)))
          )
        )
      )
    )

(define (insert! keys value table)
  (let ((subtable (assoc (car keys) (cdr table))))
    (if (null? (cdr keys))
      (if subtable
        (overwrite-record subtable value)
        (add-record (make-record (car keys) value) (cdr subtable))
      )
      (if subtable
        (insert! (cdr keys) value subtable)
        (add-record (make-nested keys value) subtable)
      )
    )
  )
)
