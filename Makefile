.PHONY: message

message:
	@echo 'Run `make install` to install dotfiles'

install:
	rsync -av --progress --exclude-from exclude ./ ~/
