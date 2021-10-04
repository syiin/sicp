(ns clojure-noob.core
  (:gen-class))

(defn my_cons [x, y] (fn [m] (m x y)))
(defn my_car [z] (z (fn [p q] p)))
(defn my_cdr [z] (z (fn [p q] q)))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]

  (def my_pair (my_cons 3 6))
  (println "The car of my pair is" (my_car my_pair))
  (println "The cdr of my pair is" (my_cdr my_pair))

  (println "Hello, World!"))
