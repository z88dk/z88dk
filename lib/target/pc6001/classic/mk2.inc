; The PC-6001mkII's 320x200 console and graphics (pc6001mk2.lib:
; -subtype=mk2disc has them, and any other startup with -clib=mk2, which defines
; CRT_PC6001MK2; a cartridge is -subtype=rom -clib=mk2).  Included by rom.asm and
; allrammk2.asm.

    defc        __pc6001mk2=1

    ; the 40x25 cells of 8x8 pixels (libsrc/target/pc6001/mk2)
    defc        CONSOLE_COLUMNS=40
    defc        CONSOLE_ROWS=25
    defc        DEFINED_ansicolumns=1
    defc        ansicolumns=40

; The colour set of the 320x200 mode (port $C0: the pens 0 to 3 of each set are
; in doc/target/pc6001mk2.md): -pragma-define:CRT_PC6001MK2_COLOURSET=n, default
; 4 (green, yellow, blue, red)
IF    !DEFINED_CRT_PC6001MK2_COLOURSET
    defc        CRT_PC6001MK2_COLOURSET=4
ENDIF
    PUBLIC      __pc6001mk2_colourset
    defc        __pc6001mk2_colourset=CRT_PC6001MK2_COLOURSET

; Where the 16 KB of the screen is (two planes of 8 KB; port $B0 bits 2-1 choose
; among $8000, $C000, $0000 and $4000): -pragma-define:CRT_PC6001MK2_VRAM=n.  A
; cartridge (or any program that keeps the ROM and its RAM as the PC-6001 has
; them) has it at $8000-$BFFF, which leaves $C000-$FFFF, where the regular
; layout puts its variables and stack; the disc's program is in the RAM from
; $0000 up, so its screen is at the top.
IF    !DEFINED_CRT_PC6001MK2_VRAM
    IF  (startup=5)
        defc        CRT_PC6001MK2_VRAM=$c000
    ELSE
        defc        CRT_PC6001MK2_VRAM=$8000
    ENDIF
ENDIF
    PUBLIC      __pc6001mk2_vram
    PUBLIC      __pc6001mk2_b0
    defc        __pc6001mk2_vram=CRT_PC6001MK2_VRAM
IF    CRT_PC6001MK2_VRAM=$8000
    ; ($B0: bits 2-1 the base, bit 0 clear: the timer runs)
    defc        __pc6001mk2_b0=0
ELIF  CRT_PC6001MK2_VRAM=$c000
    defc        __pc6001mk2_b0=2
ELIF  CRT_PC6001MK2_VRAM=$0000
    defc        __pc6001mk2_b0=4
ELSE
    defc        __pc6001mk2_b0=6        ; $4000
ENDIF
