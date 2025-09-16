.PHONY: help
help:
	@echo "Make targets for jupytercon2025-3000-bots"
	@echo "make pdf - Make PDF of talk"
	@echo "make reveal - Make Reveal.js version of talk"
	@echo "make gh-pages - Make artifact for gh-pages (Reveal.js)"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker build -t athornton/export-org .

3000bots.pdf: 3000bots.org docker-container
	./exporter.sh pdf 3000bots.org

3000bots.html: 3000bots.org docker-container
	./exporter.sh reveal 3000bots.org

pdf: 3000bots.pdf

html: 3000bots.html

gh-pages: pdf html
	@mkdir -p ./gh-pages
	cp 3000bots.html ./gh-pages/index.html
	cp 3000bots.pdf ./gh-pages/3000bots.pdf
	cp -rp css ./gh-pages
	cp -rp assets ./gh-pages

clean:
	@rm -rf ./gh-pages
	@rm -f ./3000bots.html
	@rm -f ./3000bots.pdf
	@docker rmi athornton/export-org
