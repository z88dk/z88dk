
        SECTION code_clib
        PUBLIC  clear_vram
        PUBLIC  _clear_vram

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        include "sms.hdr"
;==============================================================
; Clear VRAM
;==============================================================
; Sets all of VRAM to zero
;==============================================================
clear_vram:
_clear_vram:

        call    l_tms9918_disable_interrupts

        xor     a
        out     (__IO_VDP_COMMAND), a
        or      VDP_SET_VRAM
        out     (__IO_VDP_COMMAND), a

		; Output 16KB of zeroes
        ld      hl, $4000               ; Counter for 16KB of VRAM
        ld      a, $00                  ; Value to write
clearVRAM1:
        out     (__IO_VDP_DATA), a      ; Output to VRAM address, which is auto-incremented after each write
        nop                             ;4
        nop                             ;4
        nop                             ;4
        nop                             ;4
        dec     h                       ;4
        jp      nz, clearVRAM1          ;10
        dec     l
        jp      nz, clearVRAM1

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
