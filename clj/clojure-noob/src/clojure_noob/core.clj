(ns clojure-noob.core
  (:gen-class))

; my_cons implementation
(defn my_cons [x, y] (fn [m] (m x y)))
(defn my_car [z] (z (fn [p q] p)))
(defn my_cdr [z] (z (fn [p q] q)))

; my stream implementation
(defn delay-obj [proc] (fn [] proc))
(defn evaluate [delayed] (delayed))

(defn cons-stream [a b] (list a (delay-obj b)))
(defn stream-car [stream] (first stream))
(defn stream-cdr [stream] (evaluate (second stream)))
(defn stream-null? [stream] (empty? stream))
(def the-empty-stream '())

(defn stream-ref [s n]
  (if (= n 0)
    (stream-car s)
    (recur (stream-cdr s) (- n 1))))
(defn stream-map [proc stream] 
  (if (stream-null? stream)
    the-empty-stream
    (cons-stream (proc (stream-car stream))
                 (stream-map proc (stream-cdr stream)))))
(defn stream-for-each [proc stream] 
  (if (stream-null? stream) 
      'done 
      (do (proc (stream-car stream))
              (stream-for-each proc (stream-cdr stream)))))
(defn stream-filter [pred stream]
  (cond (stream-null? stream) the-empty-stream
        (pred (stream-car stream))
          (cons-stream (stream-car stream)
                        (stream-filter pred (stream-cdr stream)))
        :else (stream-filter pred (stream-cdr stream))
  )
)


(defn display-line [x]
  (println x))
(defn display-stream [stream]
  (stream-for-each display-line stream))



(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (def ^:dynamic sum 0)
  (binding [sum sum]
    ; Exercise 3.53
    (defn stream-enumerate-interval [low high]
      (if (> low high)
          the-empty-stream
          (cons-stream low (stream-enumerate-interval (+ low 1) high))))

    (println "sum at :61 is" sum)

    (defn accum [x] (set! sum (+ x sum)) sum)
    (def seq
      (stream-map accum
        (stream-enumerate-interval 1 20))) 

    (println "sum at :68 is" sum)
    
    (def y (stream-filter even? seq))
    (println "sum at :71 is" sum)
    (def z (stream-filter (fn [x] (= (mod x 5) 0)) seq))
    (println "sum at :73 is" sum)
    (display-stream y)
    (display-stream z)
  )

)
