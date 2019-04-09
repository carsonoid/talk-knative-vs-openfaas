# Knative Vs OpenFaaS (vs Lambda)

## Slides

The slides are found here in PDF version. A live version is shared on [google docs](https://docs.google.com/presentation/d/1ExXpbMiS79PXYvOp86iyPVrE8V3HVKc84I1kXHZwrSM/edit?usp=sharing)

## Demo

The demo is self-contained and minimal. The only requirements to run the demo cluster are Docker and docker-compose.

### Run the Demo

* `cd demo`
* `./start-and-watch.sh`
* `./demo.sh` - requires `pv` in order for demo-magic to work.
* Optional. Use `./cleanup.sh` to fully clean up and delete the demo cluster

### Tools

* [Docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)
* [k3s](https://github.com/rancher/k3s)
* [demo-magic](https://github.com/paxtonhare/demo-magic)
* [vegeta](https://github.com/tsenart/vegeta)

