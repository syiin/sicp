; ie. (cons 9 (cons 4 (cons 1 nil)))
; because cons can only concatenate items to the front of the list, 
; a recursive function accumulating using cons will always add the 
; first items in the beginning of the output list

; Reversing the parameters does not change the above
; ie. (cons (cons (1 nil) 4) 9)
