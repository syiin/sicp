; If new types are going to be added more often, then the message-passing style is better. Because then
; each type can encapsulate its own operations. Note that new operations introduced would probably need to be 
; implemented in all existing types.
; If new operations are going to be added more often, then data-directed style is better as each operation
; can be added independent of prior operations for a more constant set of types.
; Explicit dispatch has the worst of both, you need to edit all old code each time a new type or new operation 
; is introduced.