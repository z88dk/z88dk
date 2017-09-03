# Recursive wildcard function
# https://stackoverflow.com/questions/3774568/makefile-issue-smart-way-to-scan-directory-tree-for-c-files

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# All headers in proto tree

HEADERS  := $(call rwildcard,proto/,*.h)

SCCZ80_HEADERS := $(subst proto,sccz80/,$(HEADERS))
SDCC_HEADERS   := $(subst proto,sdcc,$(HEADERS))
CLANG_HEADERS  := $(subst proto,clang,$(HEADERS))

default: dirs $(SCCZ80_HEADERS) $(SDCC_HEADERS) $(CLANG_HEADERS)

sccz80/%: proto/%
	m4 -Dm4_SCCZ80 $^ > $@

sdcc/%: proto/%
	m4 -Dm4_SDCC $^ > $@

clang/%: proto/%
	m4 -Dm4_CLANG $^ > $@

dirs:
	@mkdir -p $(dir $(SCCZ80_HEADERS))
	@mkdir -p $(dir $(SDCC_HEADERS))
	@mkdir -p $(dir $(CLANG_HEADERS))

.PHONY: dirs
