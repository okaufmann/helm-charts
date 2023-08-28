.PHONY: test update set-version

test:
	@rm -Rf output/laravel-app/**/*.* || true
	@helm template --output-dir output . -f values.yaml --debug > output.txt

update:
	@helm dependency update

set-version:
	@if [ -z "$(VERSION)" ]; then \
		echo "VERSION is not set. Example usage: make set-version VERSION=1.2.3"; \
		exit 1; \
	fi
	@yq eval -i '.version = "$(VERSION)"' Chart.yaml
