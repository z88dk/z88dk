
; Hector support
;


IF FORhector1

SECTION code_clib

PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native

EXTERN  asm_toupper

INCLUDE "target/hector/def/hector1.def"

INCLUDE "graphics/grafix.inc"



IF FORhector1
    defc    putc_coords = $49a6
ENDIF

fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    cp      12
    jp      z,cls
    ld      hl,(putc_coords)
    cp      10
    jr      z,dolf
    ex      de,hl
    call    asm_toupper
    ld      c,a
    call    FW_PUTC
    ex      de,hl
    ld      (putc_coords),hl
    ret

dolf:
    ld      h,0
    ld      a,l
    add     6
    ld      l,a
    cp      maxy
    jr      c,continue
    ld      l,maxy - 6
continue:
    ld      (putc_coords),hl
    ret

cls:
    ld      hl,0
    ld      (putc_coords),hl
    jp      FW_CLS


ENDIF