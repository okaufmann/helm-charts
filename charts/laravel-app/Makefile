.PHONY: test

test:
	@rm -Rf output/laravel-app/**/*.* || true
	@helm template --output-dir output . -f values.yaml --debug > output.txt
