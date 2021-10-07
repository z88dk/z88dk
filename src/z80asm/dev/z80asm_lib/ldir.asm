; Substitute for the z80 ldir instruction
; Doesn't emulate the flags correctly


        SECTION code_l_sccz80
        PUBLIC  __z80asm__ldir

__z80asm__ldir:
        push    af
loop:
IF  __CPU_GBZ80__
        ld      a, (hl+)
ELSE
        ld      a, (hl)
        inc     hl
ENDIF
        ld      (de), a
        inc     de
        dec     bc
        ld      a, b
        or      c
        jr      nz, loop
        pop     af
        ret
