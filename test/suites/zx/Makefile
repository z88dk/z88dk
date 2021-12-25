include ../make.config

SRCS = $(wildcard *.c)


all:	$(SRCS:%.c=test_%.bin)


test_%.bin: %.c $(SOURCES) 
	$(compile)
	$(runtest)


clean:
	rm -f *.bin *.map zcc_opt.def *~
