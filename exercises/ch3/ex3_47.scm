(define (make-mutex)
  (let ((cell (list false)))            
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
                 (the-mutex 'acquire))) ; retry
            ((eq? m 'release) (clear! cell))))
    the-mutex))
(define (clear! cell)
  (set-car! cell false))

(define (test-and-set! cell)
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))

;;; first attempt - doesn't really protect the acquired as the critical section
(define (make-semaphore n)
  (let ((acquired 0)
        (the-mutex (make-mutex)))
    (define (semaphore m)
      (cond ((eq? m 'acquire)
              (if (> acquired n)
                (begin (the-mutex 'acquire) (set! acquired (+ acquired 1)) false)
                (begin (set! acquired (+ acquired 1)) false)))
            ((eq? m 'release)
              (if (> acquired n)
                (set! acquired (- acquired 1))
                (the-mutex 'release)))))
  semaphore))


;;; second attempt
(define (make-semaphore n)
  (let ((acquired 0)
        (the-mutex (make-mutex)))
    (define (semaphore m)
      (cond ((eq? m 'acquire)
              (the-mutex 'acquired)
              (if (> acquired n)
                (begin (the-mutex 'release) (the-semaphore 'acquire))
                (begin (set! acquired (+ acquired 1)) (the-mutex 'release))))
            ((eq? m 'release)
              (the-mutex 'acquire)
              (- acquired 1)
              (the-mutex 'release))))
  semaphore))

