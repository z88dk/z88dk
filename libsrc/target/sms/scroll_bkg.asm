        SECTION code_clib
        PUBLIC  scroll_bkg
        PUBLIC  _scroll_bkg

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        include "sms.hdr"
;==============================================================
; void scroll_bkg(int x, int y)
;==============================================================
; Scrolls the bkg map to the specified position
;==============================================================
scroll_bkg:
_scroll_bkg:
        ld      hl, 2
        add     hl, sp

        call    l_tms9918_disable_interrupts

        ld      a, (hl)                 ; Y
        inc     hl
        inc     hl

        out     (__IO_VDP_COMMAND), a   ; Output value
        ld      a, VDP_SET_REG|$09      ; Output to VDP register 9 (Y Scroll)
        out     (__IO_VDP_COMMAND), a

        ld      a, (hl)                 ; X

        out     (__IO_VDP_COMMAND), a   ; Output value
        ld      a, VDP_SET_REG|$08      ; Output to VDP register 8 (X Scroll)
        out     (__IO_VDP_COMMAND), a

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
