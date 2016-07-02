
EXECFILES = adv_a.obj othello.obj enigma.obj fib.obj mm.obj rpn.obj tic.obj sorter.obj \
	mandel.obj sosinfo.obj



all: $(EXECFILES)

.PRECIOUS: $(EXECFILES:.obj=.vz)

%.obj: ../console/%.c
	zcc +sos -create-app -vn $^ -O3 -o $@ -lndos -lm

%.obj: ../%.c
	zcc +sos -create-app -vn $^ -O3 -o $@ -lndos -lm

%.obj: %.c
	zcc +sos -create-app -vn $^ -O3 -o $@ -lndos -lm


clean:
	$(RM) *.vz *.i *.asm *.obj *.bin *.vz *.wav *.op* *.o *~ zcc_opt.def *.reloc

