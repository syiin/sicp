(define (gcd a b)
  (if (= b 0)
  a
  (gcd b (remainder a b)))
)

; Applicative-order case, there are 4 calls to remainder
; (gcd 206 40)
; (gcd 40 (remainder 206 40))
; (gcd 40 6)
; (gcd 6 (remainder 40 6))
; (gcd 6 4)
; (gcd 4 (remainder 6 4))
; (gcd 4 2)
; (gcd 2 (remainder 4 2))
; (gcd 2 0)
; 2

; Normal-order case, there are 18 calls. Remember that the if statement is a special form so it is evaluated 
; first before expanding the procedure call further in the normal order

; (gcd 206 40)
;  
; (gcd 40 (remainder 206 40))
; 
; (if (= (remainder 206 40) 0)
;     40
;     (gcd (remainder 206 40) (remainder 40 (remainder 206 40))))
;     
; (gcd (remainder 206 40) (remainder 40 (remainder 206 40))
; 
; (if (= (remainder 40 (remainder 206 40)) 0)
;     (remainder 206 40)
;     (gcd (remainder 40 (remainder 206 40))
;          (remainder (remainder 206 40)
;                     (remainder 40 (remainder 206 40)))))
; 
; (gcd (remainder 40 (remainder 206 40))
;      (remainder (remainder 206 40)
;                 (remainder 40 (remainder 206 40))))
; 
; (if (= (remainder (remainder 206 40)
;                   (remainder 40 (remainder 206 40)))
;        0)
;     (remainder 40 (remainder 206 40))
;     (gcd (remainder (remainder 206 40)
;                     (remainder 40 (remainder 206 40)))
;          (remainder (remainder 40 (remainder 206 40))
;                     (remainder (remainder 206 40)
;                                (remainder 40 (remainder 206 40))))))
; 
; (gcd (remainder (remainder 206 40)
;                 (remainder 40 (remainder 206 40)))
;      (remainder (remainder 40 (remainder 206 40))
;                 (remainder (remainder 206 40)
;                            (remainder 40 (remainder 206 40))))))
; 
; (if (= (remainder (remainder 40 (remainder 206 40))
;                   (remainder (remainder 206 40)
;                              (remainder 40 (remainder 206 40))))
;        0)
;     (remainder (remainder 206 40)
;                (remainder 40 (remainder 206 40)))
;     (gcd (remainder (remainder 40 (remainder 206 40))
;                     (remainder (remainder 206 40)
;                                (remainder 40 (remainder 206 40))))
;          (remainder (remainder (remainder 206 40)
;                                (remainder 40 (remainder 206 40)))
;                     (remainder (remainder 40 (remainder 206 40))
;                                (remainder (remainder 206 40)
;                                           (remainder 40 (remainder 206 40)))))))
; (remainder (remainder 206 40)
;            (remainder 40 (remainder 206 40)))
; 
; 2
