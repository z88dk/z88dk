ZCC ?= zcc
ZCFLAGS ?= -clib=default -create-app
BUILD_DIR ?= build

EXAMPLES = \
	$(BUILD_DIR)/hello \
	$(BUILD_DIR)/argv \
	$(BUILD_DIR)/clear \
	$(BUILD_DIR)/hello_low

.PHONY: all clean

all: $(EXAMPLES)

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/hello: hello.c | $(BUILD_DIR)
	$(ZCC) +pps $(ZCFLAGS) $< -o $@

$(BUILD_DIR)/argv: argv.c | $(BUILD_DIR)
	$(ZCC) +pps $(ZCFLAGS) $< -o $@

$(BUILD_DIR)/clear: clear_screen.c | $(BUILD_DIR)
	$(ZCC) +pps $(ZCFLAGS) $< -o $@

$(BUILD_DIR)/hello_low: hello.c | $(BUILD_DIR)
	$(ZCC) +pps_low $(ZCFLAGS) $< -o $@

clean:
	$(RM) -r $(BUILD_DIR)
