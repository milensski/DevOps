package main

import (
	"flag"
	"log"
	"net/http"
	"os"
	"time"
	"math/rand"
	"strconv"
	
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	appVersion string

	version    = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "version",
		Help: "Version information about this binary",
		ConstLabels: map[string]string{
			"version": appVersion,
		},
	})

	httpRequestsTotal = prometheus.NewCounterVec(prometheus.CounterOpts{
		Name: "http_requests_total",
		Help: "Count of all HTTP requests",
	}, []string{"code", "method"})

        jobsProcessedTotal = prometheus.NewCounterVec(prometheus.CounterOpts{
                Name: "jobs_processed_total",
                Help: "Count of all processed jobs",
        }, []string{"result"})

        jobsActive = prometheus.NewGauge(prometheus.GaugeOpts{
                Name: "jobs_active",
                Help: "Active jobs",
        })

	httpRequestDuration = prometheus.NewHistogramVec(prometheus.HistogramOpts{
		Name: "http_request_duration_seconds",
		Help: "Duration of all HTTP requests",
	}, []string{"code", "handler", "method"})
)

func main() {
	version.Set(1)
	bind := ""
	flagset := flag.NewFlagSet(os.Args[0], flag.ExitOnError)
	flagset.StringVar(&bind, "bind", ":8080", "The socket to bind to.")
	flagset.Parse(os.Args[1:])

	rand.Seed(time.Now().UnixNano())

	r := prometheus.NewRegistry()
	r.MustRegister(httpRequestsTotal)
	r.MustRegister(jobsProcessedTotal)
	r.MustRegister(jobsActive)
	r.MustRegister(httpRequestDuration)
	r.MustRegister(version)

	foundHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("Job processing application\n\n"))
		
		mode, ok := r.URL.Query()["slow"]
    
		if ok {
	                log.Println("Url Param 'slow' is passed: " + string(mode[0]))
	                n := 1 + rand.Intn(10)
	                log.Printf("Slow request. Sleeping %d seconds...\n", n)
			w.Write([]byte("Slow request. Sleeping " + strconv.Itoa(n) + " seconds...\n"))
	                time.Sleep(time.Duration(n)*time.Second)
    		}

		js := rand.Intn(5)
		w.Write([]byte("Jobs processed (success): " + strconv.Itoa(js) + "\n"))
    		jobsProcessedTotal.With(prometheus.Labels{"result":"success"}).Add(float64(js))

		jf := rand.Intn(5)
		w.Write([]byte("Jobs processed (fail): " + strconv.Itoa(jf) + "\n"))
		jobsProcessedTotal.With(prometheus.Labels{"result":"fail"}).Add(float64(jf))

                ja := rand.Intn(5)
                w.Write([]byte("Jobs active: " + strconv.Itoa(ja) + "\n"))
                jobsActive.Set(float64(ja))
	})

	notfoundHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusNotFound)
	})

	foundChain := promhttp.InstrumentHandlerDuration(
		httpRequestDuration.MustCurryWith(prometheus.Labels{"handler": "found"}),
		promhttp.InstrumentHandlerCounter(httpRequestsTotal, foundHandler),
	)

	mux := http.NewServeMux()
	mux.Handle("/", foundChain)
	mux.Handle("/err", promhttp.InstrumentHandlerCounter(httpRequestsTotal, notfoundHandler))
	mux.Handle("/metrics", promhttp.HandlerFor(r, promhttp.HandlerOpts{}))

	var srv *http.Server
	srv = &http.Server{Addr: bind, Handler: mux}

	log.Fatal(srv.ListenAndServe())
}
