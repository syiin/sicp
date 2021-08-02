; 200
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
    '()
    (cons low (enumerate-interval (+ low 1) high))))

(define empty-board '())
 (define (adjoin-position new-row k rest-of-queens) 
   (cons (list new-row k) rest-of-queens)) 
  
 (define (queen-in-k k positions) 
   (cond ((null? positions) '()) 
         ((= (cadar positions) k) (car positions)) ;queen in column, return that position
         (else (queen-in-k k (cdr positions))))) 
  
 (define (queens-not-k k positions) 
   (cond ((null? positions) '()) 
         ((= (cadar positions) k) (cdr positions)) ;queen in column, return other positions
         (else (cons (car positions) 
                     (queens-not-k k (cdr positions)))))) 
  
(define (safe? k positions) 
  (let ((queen-k (queen-in-k k positions))
        (o-queens (queens-not-k k positions)))
    (null? (filter (lambda (o-q) 
                     (or (= (car o-q) (car queen-k)) ; same row?
                         (= (- (car o-q) (cadr o-q)) 
                            (- (car queen-k) (cadr queen-k))) ;same right diagonal?
                         (= (+ (car o-q) (cadr o-q)) 
                            (+ (car queen-k) (cadr queen-k))))) ;same left diagonal?
                   o-queens))))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions))
        (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row) (adjoin-position new-row k rest-of-queens))
                  (enumerate-interval 1 board-size)
            )
          )
          (queen-cols (- k 1))
        )
      )))
  (queen-cols board-size))

(queens 4) ;Value: (((3 4) (1 3) (4 2) (2 1)) ((2 4) (4 3) (1 2) (3 1)))


;(define (safe? k positions) true) 
;this was the puzzling bit, figuring out what positions was
;positions is a list of possible positions the 4 queens could take  
;ie. ((4 4) (4 3) (4 2) (4 1))
;note that flatmap calls queen-cols so adjoin-position will create 
;every possible position before filter is called column by column for
;each column 
;((1 4) (2 3) (4 2) (4 1)) 
;((2 4) (2 3) (4 2) (4 1)) 
;((3 4) (2 3) (4 2) (4 1)) 
;((4 4) (2 3) (4 2) (4 1)) 
;((1 4) (3 3) (4 2) (4 1)) 
;((2 4) (3 3) (4 2) (4 1)) 
;((3 4) (3 3) (4 2) (4 1)) 
;((4 4) (3 3) (4 2) (4 1)) 
;((1 4) (4 3) (4 2) (4 1)) 
;((2 4) (4 3) (4 2) (4 1)) 
;((3 4) (4 3) (4 2) (4 1)) 
;((4 4) (4 3) (4 2) (4 1))
;remember that since positions is a list of positions,
;safe? only sees each set of positions at a time 
;ie. ((4 4) (4 3) (4 2) (4 1)) 
;and that filter will return an empty list if none match