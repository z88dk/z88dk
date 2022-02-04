        SECTION code_clib
        PUBLIC  load_palette_gamegear
        PUBLIC  _load_palette_gamegear
        PUBLIC  asm_load_palette_gamegear

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        include "sms.hdr"
;==============================================================
; void load_palette(int *data, int index, int count)
;==============================================================
; C interface for LoadPalette
;==============================================================
load_palette_gamegear:
_load_palette_gamegear:
        ld      hl, 2
        add     hl, sp
        ld      b, (hl)
        inc     hl
        inc     hl
        ld      a, (hl)
        add     a
        ld      c, a
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
; hl = location
; b  = number of values to write
; c  = palette index to start at (<64)
;==============================================================
asm_load_palette_gamegear:

        call    l_tms9918_disable_interrupts

        ld      a, c
        out     (__IO_VDP_COMMAND), a
        ld      a, VDP_SET_CRAM
        out     (__IO_VDP_COMMAND), a

        inc     c
	; GGGGRRRR
        ld      e, (hl)                 ;7
        inc     hl
        ; 0000BBBB
        ld      d, (hl)

        ld      a, e
        out     (__IO_VDP_DATA), a

        ld      a, c
        out     (__IO_VDP_COMMAND), a
        ld      a, VDP_SET_CRAM
        out     (__IO_VDP_COMMAND), a

        inc     c
        nop
        nop
        ld      a, d
        out     (__IO_VDP_DATA), a

        inc     hl                      ;6
        nop                             ;4
        djnz    asm_load_palette_gamegear
                                        ;13

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
