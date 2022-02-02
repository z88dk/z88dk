        SECTION code_clib
        PUBLIC  set_vdp_reg
        PUBLIC  _set_vdp_reg

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts

        include "sms.hdr"
;==============================================================
; void set_vdp_reg(int reg, int value)
;==============================================================
; Sets the value of a VDP register
;==============================================================
set_vdp_reg:
_set_vdp_reg:
        ld      hl, 2
        add     hl, sp

        ld      a, (hl)                 ; Value
        inc     hl
        inc     hl
        ld      l, (hl)                 ; Reg

        call    l_tms9918_disable_interrupts

        out     (IO_VDP_COMMAND), a
        ld      a, l
        or      VDP_SET_REG
        out     (IO_VDP_COMMAND), a

        call    l_tms9918_enable_interrupts

        ret
