

all: adv_a enigma fib mm rpn tic sorter dstar dstar_native chessboard mandel julia smallgfx stencil showlib3d smallgfx2 sinwave coswave smile clicktest fx sndtest synthdemo


adv_a:
	zcc +vz -vn -lndos  ../console/adv_a.c -I../console -DCOMPUTE_SCORE -O3 -o adv_a.vz
	appmake +vz  -b adv_a.vz  --audio

othello:
	zcc +vz -vn -lndos -O3 ../othello.c -I.. -o othello.vz
	appmake +vz  -b othello.vz  --audio

enigma:
	zcc +vz -vn -lndos  ../console/enigma.c -o enigma.vz
	appmake +vz  -b enigma.vz  --audio

fib:
	zcc +vz -vn -lndos  ../console/fib.c -o fib.vz
	appmake +vz  -b fib.vz  --audio

mm:
	zcc +vz -vn -lndos  ../console/mm.c -o mm.vz
	appmake +vz  -b mm.vz  --audio

rpn:
	zcc +vz -vn -lndos  ../console/rpn.c -o rpn.vz
	appmake +vz  -b rpn.vz  --audio

tic:
	zcc +vz -vn -lndos  ../console/tic.c -o tic.vz 
	appmake +vz  -b tic.vz  --audio

sorter:
	zcc +vz -vn -lndos  ../console/sorter.c -o sorter.vz
	appmake +vz  -b sorter.vz  --audio

dstar:
	zcc +vz -vn ../dstar.c -I.. -Dspritesize=7 -DSOUND  -o dstar.vz
	appmake +vz  -b dstar.vz  --audio

dstar_native:
	zcc +vz -vn dstar.c -o dstar_native.vz  -lndos
	appmake +vz  -b dstar_native.vz  --audio

ex10b:
	zcc +vz -vn ex10b.c -o ex10b.vz  
	appmake +vz  -b ex10b.vz  --audio

chessboard:
	zcc +vz -vn -I../graphics ../graphics/chessboard.c -lndos -lm  -o chessboard.vz
	appmake +vz  -b chessboard.vz  --audio

mandel:
	zcc +vz -vn ../graphics/mandel.c -lndos -lm  -o mandel.vz
	appmake +vz  -b mandel.vz  --audio

julia:
	zcc +vz -vn ../graphics/julia.c -lndos -lm  -o julia.vz
	appmake +vz  -b julia.vz  --audio

smallgfx:
	zcc +vz -vn ../graphics/smallgfx.c -lndos -lm  -o smallgfx.vz
	appmake +vz  -b smallgfx.vz  --audio

stencil:
	zcc +vz -vn ../graphics/stencil.c -lndos -lm -llib3d  -o stencil.vz
	appmake +vz  -b stencil.vz  --audio

showlib3d:
	zcc +vz -vn ../graphics/showlib3d.c -lndos -lm -llib3d  -o showlib3d.vz
	appmake +vz  -b showlib3d.vz  --audio

smallgfx2:
	zcc +vz -vn ../graphics/smallgfx2.c -lndos -lm  -o smallgfx2.vz
	appmake +vz  -b smallgfx2.vz  --audio

sinwave:
	zcc +vz -vn ../graphics/sinwave.c -lndos -lm -lmalloc  -o sinwave.vz
	appmake +vz  -b sinwave.vz  --audio

coswave:
	zcc +vz -vn ../graphics/coswave.c -lndos -lm -lmalloc  -o coswave.vz
	appmake +vz  -b coswave.vz  --audio

smile:
	zcc +vz -vn ../ticalc/smile.c -lndos  -o smile.vz
	appmake +vz  -b smile.vz  --audio

clicktest:
	zcc +vz -vn ../sound/clicktest.c -lndos  -o clicktest.vz
	appmake +vz  -b clicktest.vz  --audio

fx:
	zcc +vz -vn ../sound/fx.c -lndos  -o fx.vz
	appmake +vz  -b fx.vz  --audio

sndtest:
	zcc +vz -vn ../sound/sndtest.c -lndos -lm  -o sndtest.vz
	appmake +vz  -b sndtest.vz  --audio

synthdemo:
	zcc +vz -vn ../sound/synthdemo.c -lndos  -o synthdemo.vz
	appmake +vz  -b synthdemo.vz  --audio

clean:
	$(RM) *.vz *.i *.asm *.cas *.bin *.vz *.wav *.op* *.o *~ zcc_opt.def

