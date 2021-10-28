(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

(stream-ref (expand 1 7 10) 0) ;1
(stream-ref (expand 1 7 10) 1) ;4
(stream-ref (expand 1 7 10) 2) ;2
(stream-ref (expand 1 7 10) 3) ;8
(stream-ref (expand 1 7 10) 4) ;5
(stream-ref (expand 1 7 10) 5) ;7

(stream-ref (expand 3 8 10) 1) ;7
(stream-ref (expand 3 8 10) 2) ;5
(stream-ref (expand 3 8 10) 3) ;0

; It is division with increase precision of num / den in a given base
 (/ 1.0 7) ;Value: .14285714285714285
