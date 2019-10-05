
        SECTION	code_driver

        PUBLIC	asm_clg
        GLOBAL	__console_x

        INCLUDE "target/gb/def/gb_globals.def"

asm_clg:
        push    de
        push    hl
        ld      hl,0x8100
        ld      bc,5760         ; Bytes to clear
cls_2:
        ldh     a,(STAT)
        bit     1,a
        jr      nz,cls_2
        ld      (hl),0	; Always clear
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jr      nz,cls_2
        ; Reset printing coordinates
        ld      hl,__console_x
        xor     a
        ld      (hl+),a
        ld      (hl),a
        pop     hl
        pop     de
        ret
