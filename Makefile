deps:
	go install github.com/terraform-docs/terraform-docs@v0.16.0
	go install github.com/hashicorp/terraform-config-inspect@latest

	curl -L https://github.com/terraform-linters/tflint/releases/download/v0.44.1/tflint_linux_amd64.zip -o tflint.zip && \
		unzip tflint.zip && \
		rm tflint.zip && \
		mv tflint "`go env GOPATH`/bin"
	curl -L https://github.com/tenable/terrascan/releases/download/v1.9.0/terrascan_1.9.0_Linux_x86_64.tar.gz -o terrascan.tar.gz && \
		tar -xf terrascan.tar.gz terrascan && \
		rm terrascan.tar.gz && \
		install terrascan "`go env GOPATH`/bin" && \
		rm terrascan

terraform-init: generate-terraform-providers
	find -name "*.tf" | xargs dirname | uniq | xargs -I% -P0 sh -c 'cd %; terraform init --backend=false' 1>/dev/null

clean:
	find -name ".terraform" -type d | xargs rm -rf
	find -name ".terraform.lock.hcl" -type f | xargs rm -f
