INSTALL_DIR=~/.irssi/scripts/
BUILD_DIR=build/

all:
	mkdir -p $(BUILD_DIR)
	cp src/cowsay.pl $(BUILD_DIR)

clean:
	rm -r $(BUILD_DIR)


install: all
	install -d $(INSTALL_DIR)
	install $(BUILD_DIR)cowsay.pl $(INSTALL_DIR)
