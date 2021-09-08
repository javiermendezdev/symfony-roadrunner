
# Colors:
# reset = 0,
# letter color without background => black = 30, red = 31, green = 32, yellow = 33, blue = 34, magenta = 35, cyan = 36, and white=37
# letter white and background => black = 40, red = 41, green = 42, yellow = 43, blue = 44, magenta = 45, cyan = 46, and white=47

# VAR := value

default:
	@printf "$$HELP"


hello:
	@echo "Hello!";

docker-build-image-base:
	docker build -t javimendez/symfony-roadrunner:base .


define HELP

  \e[1;35mList commands\e[0m:

	- make hello \t Say Hello
	- make docker-build-image-base \t Build image base for production

  \e[1;33mPlease execute "make <command>". Example make hello\e[0m


endef

export HELP