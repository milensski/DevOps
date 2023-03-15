VERSION:=$(shell cat VERSION)

LDFLAGS="-X main.appVersion=$(VERSION)"

bin:
	CGO_ENABLED=0 go build -ldflags=$(LDFLAGS) -o goprom --installsuffix cgo main.go

all:
	CGO_ENABLED=0 go build -ldflags=$(LDFLAGS) -o goprom --installsuffix cgo main.go
	docker image build -t shekeriev/goprom:$(VERSION) .
