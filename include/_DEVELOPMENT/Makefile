# Recursive wildcard function
# https://stackoverflow.com/questions/3774568/makefile-issue-smart-way-to-scan-directory-tree-for-c-files

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# All headers in proto tree

HEADERS  := $(call rwildcard,proto,*)

SCCZ80_HEADERS := $(subst proto,sccz80,$(HEADERS))
SDCC_HEADERS   := $(subst proto,sdcc,$(HEADERS))
CLANG_HEADERS  := $(subst proto,clang,$(HEADERS))

default: dirs $(SCCZ80_HEADERS) $(SDCC_HEADERS) $(CLANG_HEADERS) classic

sccz80/%.h: proto/%.h
	m4 -Dm4_SCCZ80 $^ > $@

sdcc/%.h: proto/%.h
	m4 -Dm4_SDCC $^ > $@

clang/%.h: proto/%.h
	m4 -Dm4_CLANG $^ > $@

sccz80/%README: proto/%README
	cp $^ $@

sdcc/%README: proto/%README
	cp $^ $@

clang/%README: proto/%README
	cp $^ $@

# Copy files for classic up
classic:
	cp -r sccz80/adt ../
	cp -r sccz80/alloc ../
	$(RM) -f ../alloc/malloc.h
	cp -r sccz80/arch/zx/esxdos.h ../arch/zx/esxdos.h
	cp -r sccz80/arch/zxn/esxdos.h ../arch/zxn/esxdos.h

dirs:
	@mkdir -p $(dir $(SCCZ80_HEADERS))
	@mkdir -p $(dir $(SDCC_HEADERS))
	@mkdir -p $(dir $(CLANG_HEADERS))

.PHONY: dirs classic
