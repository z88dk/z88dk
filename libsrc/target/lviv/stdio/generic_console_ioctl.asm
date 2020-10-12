
        MODULE  generic_console_ioctl

        SECTION code_clib
        INCLUDE "ioctl.def"

        PUBLIC  generic_console_ioctl
        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  generic_console_cls

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_UNDERLINE | CAP_GENCON_BOLD | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR
 
; a = ioctl
; de = arg
generic_console_ioctl:
        ex      de,hl
        ld      e,(hl)        ;hl = where we point to
        inc     hl
        ld      d,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
	ex	de,hl
        ld      (generic_console_font32),hl
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,failure
	ex	de,hl
        ld      (generic_console_udg32),hl
	and	a
	ret
failure:
        scf
        ret

