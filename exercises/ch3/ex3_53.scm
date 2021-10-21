; (define s (cons-stream 1 (add-streams s s)))

; (add-streams (cons-stream 1 (add-streams s s)) (cons-stream 1 (add-streams s s)))
; (stream-map + (cons-stream 1 (add-streams s s)) (cons-stream 1 (add-streams s s)))
; (cons-stream (+ 1 1) (stream-map + (add-streams s s) (add-streams s s)))

; Note, s is now (cons-stream 2 (add-streams s s))
; Then, it will become (cons-stream 4 (add-streams s s))
; ...etc

; Therefore,
; (car s) 1
; (cdr s) 2 4 8 ...etc