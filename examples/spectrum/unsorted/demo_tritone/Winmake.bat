z80asm -b -o=MUSIC m_darklight.asm
zx7 MUSIC_DARKLIGHT.bin
z80asm -b -o=MUSIC m_fotb.asm
zx7 MUSIC_FOTB.bin
z80asm -b -o=MUSIC m_journey.asm
zx7 MUSIC_JOURNEY.bin
z80asm -b -o=MUSIC m_madashell.asm
zx7 MUSIC_MADASHELL.bin
z80asm -b -o=MUSIC m_super70s.asm
zx7 MUSIC_SUPER70S.bin
z80asm -b -o=MUSIC m_triceropop.asm
zx7 MUSIC_TRICEROPOP.bin
zcc +zx -vn -O3 -startup=8 -clib=new tritone.c songs.asm -o tritone
appmake +zx -b tritone_CODE.bin -o tritone.tap --org 40000 --blockname tritone --noloader
appmake +zx -b tritone_LOWMEM.bin -o songs.tap --org 27000 --blockname songs --noloader
copy /B loader.tap+tritone.tap+songs.tap demo.tap
del *.reloc *.bin *.map *.o *.sym *.zx7 *.def MUSIC demo tritone tritone.tap songs.tap
