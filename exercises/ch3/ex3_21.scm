; because the front pointer points to the null at the end of the list but the rear pointer still points to the whole pair.
; when you try to print, the rear pointer points to (b . null) and the front pointer points to null and scheme displays them 
; from car to cdr order . hence, (null b). ie. the queue isn't just a list of elements, it is a pair pointing to the beginning 
; and end of a list

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))

(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue)))) 

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue))) 

;;; First attempt
(define (print-queue q)
  (define (iter-list lst)
    (if (null? (cdr lst))
      (display (car lst))
      (begin 
        (newline)
        (display (car lst))
        (newline)
        (iter-list (cdr lst)))))
  (iter-list (front-ptr q)))

;;; Cleaner second attempt
(define (print-queue q)
  (newline)
  (display (car q)))


(define q1 (make-queue))
(insert-queue! q1 'a)
(insert-queue! q1 'b)
(insert-queue! q1 'c)

(print-queue q1)

(delete-queue! q1)

(print-queue q1)

(delete-queue! q1)

(print-queue q1)