MODULE  generic_console_printc32

SECTION code_driver
PUBLIC  generic_console_printc32

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags
EXTERN  __MODE1_attr

INCLUDE "target/hector/def/hector1.def"


generic_console_printc32:
    and     128
    ld      a,d
    ld      de,(generic_console_font32)
    jr      z,not_udg
    sub     128 - 32
    ld      de,(generic_console_udg32)
not_udg:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    dec     h
    add     hl,de
    push    hl		;Save font
	ld      hl,HEC_SCREEN
    ld      l,c
    add     hl,bc
    pop     de
    ; hl = HEC_SCREEN address to place
    ; de = font

    ld      a, (generic_console_flags)
    rlca
    sbc     a, a
    ld      c, a                        ;x = 0 / 255
    ld      b, 8
printc32_1:
    push    bc
    ld      a, (de)
    xor     c
    push    de
    ld      b, 2
printc32_2:
    ld      de, (__MODE1_attr)
    push    bc
    push    hl
    ld      l, a
    ld      b, 4
    ld      c, 0                        ;final attribute
printc32_3:
    rl      l
    ld      a, d
    jr      nc, is_paper
    ld      a, e
is_paper:
    or      c
    ld      c, a
    sla     d
    sla     d
    sla     e
    sla     e
    djnz    printc32_3
    ld      a, l                        ;save what's left of character
    pop     hl
    ld      (hl), c
    inc     hl
    pop     bc
    djnz    printc32_2
    ld      de, HEC_STRIDE - 2
    add     hl, de
    pop     de
    inc     de
    pop     bc
    djnz    printc32_1
    ret