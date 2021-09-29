; This order must be used as wires have interdependencies. Changing the order of wires firing changes
; the output. For example, imagine this list of action procedures  ((lambda () (set-signal! output 0)) (lambda () (set-signal! output 1))) 


(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)
(define (logical-and s1 s2) 
  (if (and (= s1 1) (= s2 1)) 
        1 
        0)) 
