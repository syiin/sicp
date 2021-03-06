; this process is recursive
; (+ 4 5)
; (inc (+ 3 5))
; (inc (inc (+ 2 5)))
; (inc (inc (inc (+ 1 5))))
; (inc (inc (inc (inc (+ 0 5)))))
; (inc (inc (inc (inc 5))))

(define (+ a b)
  (if (= a 0) 
    b 
    (inc (+ (dec a) b)))
)

; this process is iterative
; (+ 4 5)
; (+ 3 6)
; (+ 2 7)
; (+ 1 8)
; (+ 0 9)
(define (+ a b)
  (if (= a 0) 
    b 
    (+ (dec a) (inc b)))
)