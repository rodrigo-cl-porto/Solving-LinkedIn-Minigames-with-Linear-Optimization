restart-venv:
	deactivate
	rm -rf .venv
	uv venv
	source .venv/Scripts/activate

build-book:
	export NODE_TLS_REJECT_UNAUTHORIZED=0
	cd book
	jupyter-book build --html

deploy:
	cd ..
	jupyter-book init --gh-pages