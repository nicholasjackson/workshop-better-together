REPO=nicholasjackson/workshop-better-together
VERSION=v0.0.1

build_codeserver:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx create --name vscode || true
	docker buildx use vscode
	docker buildx inspect --bootstrap
	docker buildx build --platform linux/arm64,linux/amd64 \
		-t ${REPO}:${VERSION} \
	  -f ./Dockerfiles/code-server/Dockerfile \
		--no-cache \
	  ./Dockerfiles/code-server \
		--push
	
functional_test:
	dagger -m ./dagger call functional-test --src . --working-directory jumppad --runtime docker

build_packer:
	cd ./instruqt_vm && packer build -var-file=./main.pkrvars.hcl ./main.pkr.hcl