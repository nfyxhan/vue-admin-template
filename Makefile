REGISTRY ?= registry.nfyxhan.com:5000/nfyxhan
IMAGE ?= node
TAG ?= dev
PORT ?= 9528
FULL_IMAGE = ${REGISTRY}/${IMAGE}:${TAG}

.SILENT: run

builder:
	docker build -t ${FULL_IMAGE} -f Dockerfile-builder .

docker-build:
	echo "use image: ${FULL_IMAGE}"
	docker build -t ${FULL_IMAGE} .

push:
	docker push ${FULL_IMAGE}

redeploy: docker-build push
	kubectl delete pod -l app=nodejs

run: docker-build
	echo ""
	echo "App running at:"
	echo "  - Local: http://localhost:${PORT}"
	echo ""
	docker run -itd --rm -p ${PORT}:80 ${FULL_IMAGE}


