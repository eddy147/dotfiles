{:user {:dependencies [[org.clojure/clojure "1.8.0"]
                       [org.clojure/tools.namespace "0.2.11"]
                       [org.clojure/tools.nrepl "0.2.13"]
                       [cljfmt "0.5.7"]
                       [spyscope "0.1.3"]
                       [criterium "0.4.1"]
                       [jonase/eastwood "0.2.8" :exclusions [org.clojure/clojure]]]
        :injections [(require '(clojure.tools.namespace repl find))
                     ; try/catch to workaround an issue where `lein repl` outside a project dir
                     ; will not load reader literal definitions correctly:
                     (try (require 'spyscope.core)
                          (catch RuntimeException e))]
        :plugins [[lein-pprint "1.1.1"]
                  [lein-ancient "0.6.15"]
                  [lein-cljfmt "0.6.1"]
                  [lein-clojars "0.9.1"]
                  [lein-create-template "0.2.0"]
                  [lein-marginalia "0.9.1"]
                  [lein-exec "0.3.7"]
                  [lein-midje "3.2.1"]
                  [lein-kibit "0.1.6"]
                  [nightlight/lein-nightlight "RELEASE"]
                  [lein-gorilla "0.4.0"]]}}
