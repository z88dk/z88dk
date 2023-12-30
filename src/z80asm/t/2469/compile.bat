del /q sb.*
zcc +zxn --no-crt -m -v -Ca-DFAIL_TEST SpriteData_Boulder.asm SpriteData_Boulder2.asm -o sb.bin
grep Boulder2PalettePage sb.map
z88dk-z80nm -l -e SpriteData_Boulder2.o | grep Boulder2PalettePage
timeout 10

del /q sb.*
zcc +zxn --no-crt -m -v SpriteData_Boulder.asm SpriteData_Boulder2.asm -o sb.bin
grep Boulder2PalettePage sb.map
z88dk-z80nm -l -e SpriteData_Boulder2.o | grep Boulder2PalettePage
timeout 10

del /q sb.*
z88dk-z80asm -mz80n -b -m -osb.bin -DFAIL_TEST SpriteData_Boulder.asm SpriteData_Boulder2.asm
grep Boulder2PalettePage sb.map
z88dk-z80nm -l -e SpriteData_Boulder2.o | grep Boulder2PalettePage
timeout 10

del /q sb.*
z88dk-z80asm -mz80n -b -m -osb.bin SpriteData_Boulder.asm SpriteData_Boulder2.asm
grep Boulder2PalettePage sb.map
z88dk-z80nm -l -e SpriteData_Boulder2.o | grep Boulder2PalettePage
timeout 10

del /q sb.*
del /q *.o
