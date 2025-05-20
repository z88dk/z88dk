
MODULE  generic_console_printc64

SECTION code_driver
PUBLIC  generic_console_printc64

EXTERN  generic_console_font64
EXTERN  generic_console_udg32
EXTERN  generic_console_flags
EXTERN  __MODE1_attr

INCLUDE "target/hector/def/hector1.def"


generic_console_printc64:
    and     128
    ld      a,d
    ld      de,(generic_console_font64)
    jr      z,printc64_notudg
    sub     128 - 32
    ld      de,(generic_console_udg32)
printc64_notudg:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    dec     h
    add     hl,de
    ex      de,hl
    ld      hl,HEC_SCREEN
IF FORhector1
    add     hl,bc
ELSE
    ; 64 bytes a row
    add     hl,bc
    ld      c,0
    add     hl,bc
ENDIF
    ; hl = HEC_SCREEN address to place
    ; de = font

    ld      a, (generic_console_flags)
    rlca
    sbc     a, a
    ld      c, a                        ;x = 0 / 255
    ld      b, 8
printc64_1:
    push    bc
    ld      a,(de)
    xor     c
    push    de
    ld      de, (__MODE1_attr)
    push    hl
    ld      l, a
    ld      b, 4
    ld      c, 0                        ;final attribute
printc64_2:
    rl      l
    ld      a, d
    jr      nc, printc64_is_paper
    ld      a, e
printc64_is_paper:
    or      c
    ld      c, a
    sla     d
    sla     d
    sla     e
    sla     e
    djnz    printc64_2
    pop     hl
    ld      (hl), c
    ld      de, HEC_STRIDE
    add     hl, de
    pop     de
    inc     de
    pop     bc
    djnz    printc64_1
    ret
