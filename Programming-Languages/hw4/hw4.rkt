
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file


;; put your code below
(define (sequence low high stride)
    (if (> low high) 
        null 
        (cons low (sequence (+ low stride) high stride))))
; this is a helper function
(define ((myappend suffix) stem) (string-append stem suffix))
(define (string-append-map xs suffix) (map (myappend suffix) xs))
(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]        
        [(null? xs) (error "list-nth-mod: empty list")]
        [(= (remainder n (length xs)) 0) (car xs)]
        [#t (list-nth-mod (cdr xs) (- (remainder n (length xs)) 1))]))

(define (stream-for-n-steps s n)
  (cond [(= n 0) null]
        [#t (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))]
        ))

(define funny-number-stream
  (letrec ([f (lambda (x) (
               cond [(= (remainder x 5) 0) (cons (* x -1) (lambda () (f (+ x 1))))]
                    [#t (cons x (lambda() (f (+ x 1))))]
               ))]) (lambda () (f 1))))

; similar to previous function implementation
(define dan-then-dog (letrec ([f (lambda (x) (
               cond [(= (remainder x 2) 1) (cons "dan.jpg" (lambda () (f (+ x 1))))]
                    [#t (cons "dog.jpg" (lambda() (f (+ x 1))))]
               ))]) (lambda () (f 1))))

(define (stream-add-zero s)
  (letrec ([f (lambda (x) (cons (cons 0 (car x)) (lambda () (f ((cdr x))))))])
    (lambda () (f (s)))))

(define (cycle-lists xs ys) 
  (letrec ([f (lambda (n) (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
                                (lambda () (f (+ n 1)))
                                ))]) (lambda () (f 0))))

(define (vector-assoc v vec) 
  (letrec ([f (lambda (n) 
  (cond [(= n (vector-length vec)) #f]
        [(not (pair? (vector-ref vec n))) (f (+ n 1))]
        ;[(not (number? (car (vector-ref vec n)))) (f (+ n 1))]
        [(equal? v (car (vector-ref vec n))) (vector-ref vec n)]
        [#t (f (+ n 1))]
        ))]) (f 0)))

(define (cached-assoc xs n)
  (letrec ([memo (make-vector n #f)]
           [pos 0]
           [f (lambda (v)
                (let ([ans (vector-assoc v memo)])
                  (if ans ans (let ([new-ans (assoc v xs)])
                        (if new-ans (begin
                              (vector-set! memo pos new-ans)
                              (set! pos (remainder (+ pos 1) n))                              
                              new-ans) #f)))))]) f ))










