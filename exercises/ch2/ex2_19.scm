;169
(define (no-more? a-list) (null? a-list))
(define (first-denomination a-list) (car a-list))
(define (except-first-denomination a-list) (cdr a-list))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
  ((or (< amount 0) (no-more? coin-values)) 0)
  (else
    (+ (cc amount
          (except-first-denomination coin-values))
    (cc (- amount
          (first-denomination coin-values))
      coin-values)))))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(cc 100 us-coins) ;292
(cc 100 uk-coins) ;104561