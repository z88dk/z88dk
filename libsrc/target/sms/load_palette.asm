        SECTION code_clib
        PUBLIC  load_palette
        PUBLIC  _load_palette
        PUBLIC  asm_load_palette

        EXTERN  __GAMEGEAR_ENABLED
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        include "sms.hdr"
;==============================================================
; void load_palette(unsigned char *data, int index, int count)
;==============================================================
; C interface for LoadPalette
;==============================================================
load_palette:
_load_palette:
        ld      hl, 2
        add     hl, sp
        ld      b, (hl)
        inc     hl
        inc     hl
        ld      c, (hl)
        inc     hl
        inc     hl
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
	; falls through to LoadPalette

;==============================================================
; Load palette
;==============================================================
; Parameters:
; hl = pointer to palette data
; b  = number of values to write
; c  = palette index to start at (<32)
;==============================================================
asm_load_palette:
        call    l_tms9918_disable_interrupts

        ld      a, __GAMEGEAR_ENABLED
        and     a
        jr      nz, LoadPalette_6bit_gg

LoadPalette:

        ld      a, c
        out     (__IO_VDP_COMMAND), a
        ld      a, VDP_SET_CRAM
        out     (__IO_VDP_COMMAND), a

LoadPalette1:
        ld      a, (hl)                 ;7
        out     (__IO_VDP_DATA), a
        inc     hl                      ;6
        nop                             ;4
        djnz    LoadPalette1            ;13

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp

;==============================================================
; Load palette
;==============================================================
; Parameters:
; hl = location
; b  = number of values to write
; c  = palette index to start at (<32)
;==============================================================
LoadPalette_6bit_gg:
        ld      a, c
        add     a

        out     (__IO_VDP_COMMAND), a
        ld      a, VDP_SET_CRAM
        out     (__IO_VDP_COMMAND), a

LoadPalette2:
	; --BBGGRR
        ld      a, (hl)                 ;7

	; GGGGRRRR ----BBBB
        ld      d, a
        ld      e, 0

        rra
        rr      e
        rra
        rr      e

        rr      e
        rr      e

        rra
        rr      e
        rra
        rr      e

        ld      a, e
        out     (__IO_VDP_DATA), a

        ld      a, d
        rra
        rra
        and     @00001100

        out     (__IO_VDP_DATA), a

        inc     hl                      ;6
        nop                             ;4
        djnz    LoadPalette2            ;13

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
