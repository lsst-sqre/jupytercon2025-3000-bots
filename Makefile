container = athornton/export-org:latest
target = 3000bots

.PHONY: help
help:
	@echo "Make targets for export-org $(target):"
	@echo ""
	@echo "make pdf - Make PDF of $(target)"
	@echo "make reveal - Make Reveal.js version of $(target)"
	@echo "make site - Make Reveal.js website directory"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker run --rm $(container) /bin/true || \
	docker buildx build -t $(container) .

$(target).pdf: $(target).org docker-container
	./exporter.sh pdf $(target).org

$(target).html: $(target).org docker-container
	./exporter.sh html $(target).org

pdf: $(target).pdf

html: $(target).html

site: pdf html
	@mkdir -p ./site/assets
	@mkdir -p ./site/css
	cp $(target).html ./site/index.html
	cp $(target).pdf ./site/$(target).pdf
	cp -rp css ./site
	cp -rp assets ./site

clean:
	-@rm -rf ./site
	-@rm -f ./$(target).html
	-@rm -f ./$(target).pdf
	-@rm -f ./$(target).tex
	-@docker rmi athornton/export-org
