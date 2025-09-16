.PHONY: help
help:
	@echo "Make targets for jupytercon2025-3000-bots"
	@echo "make pdf - Make PDF of talk"
	@echo "make reveal - Make Reveal.js version of talk"
	@echo "make site - Make Reveal.js website directory"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker build -t athornton/export-org .

3000bots.pdf: 3000bots.org docker-container
	./exporter.sh pdf 3000bots.org

3000bots.html: 3000bots.org docker-container
	./exporter.sh html 3000bots.org

pdf: 3000bots.pdf

html: 3000bots.html

site: pdf html
	@mkdir -p ./site
	cp 3000bots.html ./site/index.html
	cp 3000bots.pdf ./site/3000bots.pdf
	cp -rp css ./site
	cp -rp assets ./site

clean:
	@rm -rf ./site
	@rm -f ./3000bots.html
	@rm -f ./3000bots.pdf
	@rm -f ./3000bots.tex
	@docker rmi athornton/export-org
