; Substitute for the z80 lddr instruction
; Doesn't emulate the flags correctly

  IF    !__CPU_STRICT__

        SECTION code_l_sccz80
        PUBLIC  __z80asm__lddr

__z80asm__lddr:
        push    af

		; setup loop
        dec     bc
        inc     b
        inc     c
loop:
        ld      a, (hl)
        dec     hl
        ld      (de), a
        dec     de

        ; iterate
        dec     c
        jp      nz, loop
        dec     b
        jp      nz, loop

        pop     af
        ret

  ENDIF
