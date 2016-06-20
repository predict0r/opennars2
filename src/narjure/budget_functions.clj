
(ns narjure.budget-functions
  (:require
    [nal.deriver.truth :refer [t-or t-and w2c]]
    [narjure.global-atoms :refer :all]
    [narjure.control-utils :refer [round2]]
    [nal.term_utils :refer [syntactic-complexity]]
    [nal.deriver.truth :refer [expectation]]))

(defn occurrence-penalty-tr [occ]
  (let [k 0.0001]
    (if (= occ :eternal)
      1.0
      (/ 1.0 (+ 1.0 (* k (Math/abs (- @nars-time occ))))))))

(defn derived-budget
  "
  "
  ;TRADITIONAL BUDGET INFERENCE (DERIVED TASK PART)
  [task derived-task bLink]
  (let    [priority (first (:budget task))
           durability (* (second (:budget task))
                         (/ 1.0 (+ 1.0 (syntactic-complexity (:statement derived-task)))))
           priority' (if bLink (t-or priority (first bLink)) priority)
           durability' (if bLink (t-and durability (second bLink)) durability)
           complexity (syntactic-complexity (:statement derived-task))
           budget [(round2 4 (* priority' (occurrence-penalty-tr (:occurrence derived-task))))
                   (round2 4 durability')
                   (round2 4(if (:truth derived-task)
                              (/ (expectation (:truth derived-task))
                                 complexity)
                              (w2c 1.0)))
                   ]
           ]
    budget))