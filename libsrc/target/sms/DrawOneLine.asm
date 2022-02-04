
        SECTION code_clib
        PUBLIC  DrawOneLine

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        INCLUDE "target/sms/sms.hdr"
;==============================================================
; DrawOneLine
;==============================================================
; Draws one line on the bkg map.
; hl = Initial address of data
; de = Destination VRAM address
; c  = Number of bkg tiles to write
;==============================================================
DrawOneLine:

        call    l_tms9918_disable_interrupts

        ld      a, e
        out     (__IO_VDP_COMMAND), a
        ld      a, d
        or      VDP_SET_VRAM
        out     (__IO_VDP_COMMAND), a

        push    af
loop:
        ld      a, (hl)
        out     (__IO_VDP_DATA), a      ; Character number
        inc     hl                      ;6
        ld      a, (hl)                 ;7
        nop                             ;4
        nop                             ;4
        nop                             ;4
        nop                             ;4
        out     (__IO_VDP_DATA), a      ; Attribute number
        inc     hl

        dec     c
        jp      nz, loop                ; Repeat until c is zero
        pop     af

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
