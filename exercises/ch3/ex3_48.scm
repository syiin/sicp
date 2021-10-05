; The deadlock avoidance method works because the deadlock arises from the fact that the 2 processes can acquire the locks in a 
; different order so neither process is allowed to complete and thereby, release the lock for the other process to run. 
; eg. P1 gets L1, P2 gets L2, P1 tries to get L2 but can't because P2 has it and P2 tries to get L1 but can't because P1 has it
; By giving priority to the lower number, at least one exchange procedure will complete releasing the lock. 



(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))


(define (make-account balance id)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance) balance)
            ((eq? m 'id) id)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

; first attempt, not great because procedures are not serialised anymore between the multiple shared resources of account1's balances
; and account2's balances
(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer))
        (a-num1 (account1 'id))
        (a-num2 (account2 'id))
        (difference (- (account1 'balance) (account2 'balance))))
    (if (< a-num1 a-num2)
        (begin (serializer1 (account1 'withdraw) difference) (serializer2 (account2 'deposit) difference))
        (begin (serializer2 (account2 'withdraw) difference) (serializer1 (account1 'deposit) difference)))))

; better, simpler, more obvious. just make sure the exchange is always executed in the same order
(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer))
        (a-num1 (account1 'id))
        (a-num2 (account2 'id))
        (difference (- (account1 'balance) (account2 'balance))))
    (if (< a-num1 a-num2)
        ((serializer2 (serializer1 exchange)) account1 account2)
        ((serializer1 (serializer2 exchange)) account2 account1))))
