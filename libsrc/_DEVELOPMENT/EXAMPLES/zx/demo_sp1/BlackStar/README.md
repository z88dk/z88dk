zcc +zx -v -m -startup=31 -DWFRAMES=3 -clib=sdcc_iy -SO2 --max-allocs-per-node200000 --fsigned-char @zproject.lst -o blackstar -pragma-include:zpragma.inc
appmake +zx -b loading.scr -o screen.tap --blockname screen --org 16384 --noloader
appmake +zx -b blackstar_GAME.bin -o game.tap --blockname game --org 25124 --noloader
copy /b loader.tap + screen.tap + game.tap blackstar.tap


zcc +zx -v -m -startup=31 -DWFRAMES=3 -clib=new -O3 --fsigned-char @zproject.lst -o blackstar -pragma-include:zpragma.inc

