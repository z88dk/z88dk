


SOURCES = $(wildcard *.c) $(wildcard zxn/*.c) $(wildcard rabbit/*.c)
OUTPUT = $(SOURCES:.c=.opt)


all: $(OUTPUT)

zxn/%.opt: zxn/%.c
	zcc +test -custom-copt-rules=../lib/zxn_rules.1 -vn -a $^ -o $@
	@cat $@ | grep -v '^;' > tmp.opt
	diff -w tmp.opt results/$@

rabbit/%.opt: rabbit/%.c
	zcc +rcmx000 -vn -a $^ -o $@
	@cat $@ | grep -v '^;' > tmp.opt
	diff -w tmp.opt results/$@

%.opt:	%.c
	zcc +test -vn -a $^ -o $@
	@cat $@ | grep -v '^;' > tmp.opt
	diff -w tmp.opt results/$@
	

clean:
	$(RM) -f $(OUTPUT) tmp.opt zcc_opt.def
