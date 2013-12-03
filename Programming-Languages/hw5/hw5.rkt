;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1
(define (racketlist->mupllist rlist)
  (if (null? rlist)
      (aunit)
      (apair (car rlist) (racketlist->mupllist (cdr rlist)))))

;; Problem 2
(define (mupllist->racketlist mlist)
  (cond [(aunit? mlist) null]
        [#t (cons (apair-e1 mlist) (mupllist->racketlist (apair-e2 mlist)))]))

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(closure? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(int? e) e]
        [(mlet? e)
         (eval-under-env (mlet-body e) 
                         (cons (cons (mlet-var e) (eval-under-env (mlet-e e) env)) 
                               env))]
        [(apair? e)
         (apair (eval-under-env (apair-e1 e) env) 
                (eval-under-env (apair-e2 e) env))]
        [(fst? e)
         (let ([v1 (eval-under-env (fst-e e) env)]) 
           (if (apair? v1) 
               (apair-e1 v1) 
               (error "can not applied to non-pair")))]
        [(snd? e)
         (let ([v1 (eval-under-env (snd-e e) env)]) 
           (if (apair? v1) 
               (apair-e2 v1) 
               (error "can not applied to non-pair")))]
        [(isaunit? e)
         (let ([v1 (eval-under-env (isaunit-e e) env)])
           (if (aunit? v1) 
               (int 1) 
               (int 0)))]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)]) 
           (if (and (int? v1) 
                    (int? v2)) 
               (if (> (int-num v1) (int-num v2)) 
                   (eval-under-env (ifgreater-e3 e) env) 
                   (eval-under-env (ifgreater-e4 e) env)) 
               (error "comparison applied to non-int")))]
        [(fun? e) 
         (closure env e)]
        [(call? e) 
         (let ([f1 (eval-under-env (call-funexp e) env)]) 
           (if (closure? f1)
               (let ([name      (fun-nameopt (closure-fun f1))]
                     [arg-name  (fun-formal  (closure-fun f1))]
                     [arg-value (eval-under-env (call-actual e) env)]
                     [lex-scope (closure-env f1)]) 
                 (eval-under-env 
                  (fun-body (closure-fun f1)) 
                  (if (equal? #f name) 
                      (cons (cons arg-name arg-value) lex-scope)
                      (cons (cons name f1)
                            (cons (cons arg-name arg-value) lex-scope)))))
               (error "applied on non-closure")))]
        [(aunit? e) e]
        [#t (begin (error "bad MUPL expression"))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3

(define (ifaunit e1 e2 e3) 
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2) 
  (letrec ([let-helper (lambda (lst)
                      (if (null? lst) 
                          e2 
                          (mlet (car (car lst)) (cdr (car lst)) 
                                (let-helper (cdr lst)))))])
    (let-helper lstlst)))

(define (ifeq e1 e2 e3 e4) 
  (mlet* (list (cons "_x" e1)  
               (cons "_y" e2)) 
         (ifgreater (var "_x") (var "_y") 
                    e4 
                    (ifgreater (var "_y") (var "_x") 
                               e4 
                               e3))))

;; Problem 4

(define mupl-map 
  (fun #f "f"
       (fun "get-list" "l" 
            (ifaunit (var "l") 
                     (aunit) 
                     (apair (call (var "f") (fst (var "l"))) 
                            (call (var "get-list") (snd (var "l"))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun "addN" "i"
             (call (var "map") (fun #f "x" (add (var "i") (var "x")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))

