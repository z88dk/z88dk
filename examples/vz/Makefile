
EXECFILES = adv_a.cas othello.cas enigma.cas fib.cas mm.cas rpn.cas tic.cas sorter.cas \
	chessboard.cas mandel.cas julia.cas smallgfx.cas stencil.cas showlib3d.cas \
	smallgfx2.cas sinwave.cas coswave.cas smile.cas clicktest.cas fx.cas \
	sndtest.cas synthdemo.cas dstar.cas dstar_native.cas



all: $(EXECFILES)

.PRECIOUS: $(EXECFILES:.cas=.vz)

%.cas: %.vz
	appmake +vz -b $^ --audio

dstar.vz: ../dstar.c
	zcc +vz -vn ../dstar.c -I.. -Dspritesize=7 -DSOUND  -o dstar.vz

dstar_native.vz: dstar.c
	zcc +vz -vn dstar.c -o dstar_native.vz  -lndos

adv_a.vz: ../console/adv_a.c
	zcc +vz -vn -DCOMPUTE_SCORE $^ -O3 -o $@

%.vz: ../console/%.c
	zcc +vz -vn $^ -O3 -o $@

%.vz: %.c
	zcc +vz -vn $^ -O3 -o $@

%.vz: ../%.c
	zcc +vz -vn $^ -O3 -o $@

%.vz: ../%.c
	zcc +vz -vn $^ -O3 -o $@

%.vz: ../graphics/%.c
	zcc +vz -I../graphics -vn $^ -O3 -o $@ -lm -llib3d

%.vz: ../sound/%.c
	zcc +vz -vn $^ -O3 -o $@ -lm

%.vz: ../ticalc/%.c
	zcc +vz -vn $^ -O3 -o $@




clean:
	$(RM) *.vz *.i *.asm *.cas *.bin *.vz *.wav *.op* *.o *~ zcc_opt.def *.reloc

