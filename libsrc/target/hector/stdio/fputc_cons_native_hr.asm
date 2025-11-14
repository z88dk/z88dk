
; Hector support
;

IF FORhectorhr

SECTION code_clib

PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native

EXTERN  asm_toupper

INCLUDE "target/hector/def/hector1.def"

INCLUDE "classic/gfx/grafix.inc"

fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    cp      12
    jr      z,cls
    ld      hl,(putc_coords)
    cp      10
    jr      z,dolf
    ex      de,hl
    ld      c,a
    ld      (IO_MODE_HR_VRAM),a
    call    FW_PUTC
    ld      (putc_coords),de
    ret

dolf:
    ld      h,0
    ld      a,l
    add     8
    ld      l,a
    cp      _GFX_MAXY
    jr      c,continue
    ld      h,_GFX_MAXY - 8
continue:
    ld      (putc_coords),hl
    ld      (IO_MODE_HR_VRAM),a
    ret

cls:
    ld      hl,0
    ld      (putc_coords),hl
    ld      (IO_MODE_HR_VRAM),a
    jp      FW_CLS


SECTION bss_clib

putc_coords:    defw    $0000
ENDIF

