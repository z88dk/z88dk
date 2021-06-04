


SOURCES = $(wildcard *.c) $(wildcard z80n/*.c) $(wildcard rabbit/*.c) $(wildcard z180/*.c) $(wildcard 8080/*.c)
OUTPUT = $(SOURCES:.c=.opt)


all: $(OUTPUT)

8080/%.opt: 8080/%.c
	zcc +test -m8080 -vn -a $^ -o $@.tmp1
	@cat $@.tmp1 | grep -v '^;'  | grep -v MODULE|grep -v C_LINE > $@.tmp2
	diff -w $@.tmp2 results/$@
	@mv -f $@.tmp1 $@
	@rm $@.tmp2

z180/%.opt: z180/%.c
	zcc +test -mz180 -vn -a $^ -o $@.tmp1
	@cat $@.tmp1 | grep -v '^;'  | grep -v MODULE|grep -v C_LINE > $@.tmp2
	diff -w $@.tmp2 results/$@
	@mv -f $@.tmp1 $@
	@rm $@.tmp2

z80n/%.opt: z80n/%.c
	zcc +test -custom-copt-rules=../lib/z80n_rules.1 -vn -a $^ -o $@.tmp1
	@cat $@.tmp1 | grep -v '^;'  | grep -v MODULE|grep -v C_LINE > $@.tmp2
	diff -w $@.tmp2 results/$@
	@mv -f $@.tmp1 $@
	@rm $@.tmp2

rabbit/%.opt: rabbit/%.c
	zcc +rcmx000 -vn -a $^ -o $@.tmp1
	@cat $@.tmp1 | grep -v '^;'  | grep -v MODULE|grep -v C_LINE > $@.tmp2
	diff -w $@.tmp2 results/$@
	@mv -f $@.tmp1 $@
	@rm $@.tmp2

%_ieee.opt:	%_ieee.c
	zcc +test -fp-mode=ieee -vn -a $^ -o $@.tmp1
	@cat $@.tmp1 | grep -v '^;'  | grep -v MODULE|grep -v C_LINE > $@.tmp2
	diff -w $@.tmp2 results/$@
	@mv -f $@.tmp1 $@
	@rm $@.tmp2


%.opt:	%.c
	zcc +test -vn -a $^ -o $@.tmp1
	@cat $@.tmp1 | grep -v '^;'  | grep -v MODULE|grep -v C_LINE > $@.tmp2
	diff -w $@.tmp2 results/$@
	@mv -f $@.tmp1 $@
	@rm $@.tmp2

clean:
	$(RM) -f $(OUTPUT)
