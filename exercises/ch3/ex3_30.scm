(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

(define (empty-wire-list) '())


(define (make-n-wires count acc))
  (if (= count 0)
    acc
    (make-n-wires (- count 1) (cons (make-wire) acc)))


;;; first attempt - incorrect because it doesn't take the inputs, not used to circuit component model
(define (ripple-carry-adder n c0 s-outs)
  (let (a-wires (make-n-wires n))
       (b-wires (make-n-wires n))
       (c-in-wires ( make-n-wires n))
       (c-out-wires (cons c0 ( make-n-wires (- n 1))) )
  (define (iter-wire a b c-in c-out count)
    (if (= count 0)
      'done
      (begin
        (full-adder (car a) 
                    (car b) 
                    (car c-in) 
                    (car s-outs) 
                    (car c-out))
        (iter-wire (cdr a) 
                   (cdr b) 
                   (cdr c-in) 
                   (cdr s-outs) 
                   (cdr c-out) 
                   (- count 0)))))
  )
  (iter-wire a-wires b-wires c-in-wires c-out-wires n)
  'ok)

;;; second much cleaner attempt using map

(define (ripple-carry-adder as bs ss c-out)
  (let ((cs (make-n-wires (length as))
       (c0 (make-wire))))
    (map full-adder 
          as 
          bs
          (append cs (list c0))
          ss
          (cons c-out cs))
  'ok))