(define (bad-random-generator x)(+ x 1))
(define (rand-init) 0)
(define rand-update bad-random-generator)

(define rand
  (let ((x (rand-init)))
    (define (rand-internal cmd)
      (cond ((eq? cmd 'generate)
              (begin 
                (set! x (rand-update x))
                x))
            ((eq? cmd 'reset)
              (lambda (new-x) (begin (set! x new-x) x)
            ))))
    rand-internal
))

(rand 'generate)
(rand 'generate)
((rand 'reset) 0)
(rand 'generate)

; Notice, rand is a variable, not a procedure. It has a state variable inside called x that holds a number. The python
; equivalent could be something like. The cmd/messages are function names that act on some internal state of the rand 
; variable which is not an object. 

; class Rand:
;   def __init__(self):
;     self.x = rand-init()
;   def self.generate(self):
;     self.x = rand_update(self.x)
;     return self.x
;   def self.reset(self, x):
;     self.x = x