


SOURCES = $(wildcard *.c)
OUTPUT = $(SOURCES:.c=.opt)


all: $(OUTPUT)

%.opt:	%.c
	zcc +test -vn -a $^ -o $@
	@cat $@ | grep -v '^;' > tmp.opt
	diff -w tmp.opt results/$@
	

clean:
	$(RM) -f $(OUTPUT) tmp.opt zcc_opt.def
