# Recursive wildcard function
# https://stackoverflow.com/questions/3774568/makefile-issue-smart-way-to-scan-directory-tree-for-c-files

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# All headers in proto tree

HEADERS  := $(call rwildcard,proto,*)

COMMON_HEADERS := $(subst proto,common,$(HEADERS))

default: dirs $(COMMON_HEADERS) classic

common/%.h: proto/%.h
	m4  $^ > $@

common/%README: proto/%README
	cp $^ $@

# Copy files for classic up
classic:
	cp -r common/adt ../
	cp -r common/alloc ../
	$(RM) -f ../alloc/malloc.h
	cp -r common/arch/zx/esxdos.h ../arch/zx/esxdos.h
	cp -r common/arch/zxn/esxdos.h ../arch/zxn/esxdos.h

dirs:
	@mkdir -p $(dir $(COMMON_HEADERS))

.PHONY: dirs classic
