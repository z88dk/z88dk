; Substitute for the z80 ldir instruction
; Doesn't emulate the flags correctly


        SECTION code_l_sccz80
        PUBLIC  __z80asm__ldir

__z80asm__ldir:
        push    af

		; setup loop
        dec     bc
        inc     b
        inc     c
loop:
        ld      a, (hl+)
        ld      (de+), a

        ; iterate
        dec     c
        jp      nz, loop
        dec     b
        jp      nz, loop

        pop     af
        ret
