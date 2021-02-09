        MODULE  generic_console_ioctl
        PUBLIC  generic_console_ioctl

        SECTION code_graphics
        INCLUDE "ioctl.def"

        EXTERN  generic_console_cls

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = 0

; a = ioctl
; de = arg
generic_console_ioctl:
        ex      de,hl
        ;ld      c,(hl)  ;bc = where we point to
        inc     hl
        ld      b,(hl)
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
        ;ld      a,c
        call    generic_console_cls
        and     a
        ret
failure:
        scf
        ret

