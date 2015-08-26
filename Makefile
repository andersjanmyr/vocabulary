
NAME=vocabulary
FULL_NAME=andersjanmyr/$(NAME)
.PHONY: build
build:
	npm run build
	docker build -t $(FULL_NAME) .


.PHONY: publish
publish:
	docker push $(FULL_NAME)

.PHONY: run
run:
	docker run -e MONGOHQ_URL=mongodb://10.0.112.145:27017/vocabulary-dev --publish 3000:80 --rm -it --name $(NAME) $(FULL_NAME)

.PHONY: deploy
deploy:
	ddeploy $(NAME)

