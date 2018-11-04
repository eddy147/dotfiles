(set-env!
  :source-paths #{"src"}
  :dependencies '[[org.clojure/clojure "1.9.0"]
                  [boot-cljfmt "0.1.1" :scope "test"]
                  [nightlight "RELEASE" :scope "test"]])

(require '[nightlight.boot :refer [nightlight]])

(deftask run []
  (comp
    (wait)
    (nightlight :port 4000)))
