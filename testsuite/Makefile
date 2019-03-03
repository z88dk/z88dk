


SOURCES = $(wildcard *.c) $(wildcard zxn/*.c) $(wildcard rabbit/*.c) $(wildcard z180/*.c)
OUTPUT = $(SOURCES:.c=.opt)


all: $(OUTPUT)

z180/%.opt: z180/%.c
	zcc +test -mz180 -vn -a $^ -o tmp1.opt
	@cat tmp1.opt | grep -v '^;' | grep -v MODULE > tmp2.opt
	diff -w tmp2.opt results/$@
	mv -f tmp1.opt $@

zxn/%.opt: zxn/%.c
	zcc +test -custom-copt-rules=../lib/zxn_rules.1 -vn -a $^ -o tmp1.opt
	@cat tmp1.opt | grep -v '^;'  | grep -v MODULE> tmp2.opt
	diff -w tmp2.opt results/$@
	mv -f tmp1.opt $@

rabbit/%.opt: rabbit/%.c
	zcc +rcmx000 -vn -a $^ -o tmp1.opt
	@cat tmp1.opt | grep -v '^;'  | grep -v MODULE> tmp2.opt
	diff -w tmp2.opt results/$@
	mv -f tmp1.opt $@

%.opt:	%.c
	zcc +test -vn -a $^ -o tmp1.opt
	@cat tmp1.opt | grep -v '^;'  | grep -v MODULE> tmp2.opt
	diff -w tmp2.opt results/$@
	mv -f tmp1.opt $@

clean:
	$(RM) -f $(OUTPUT) tmp*.opt zcc_opt.def 
