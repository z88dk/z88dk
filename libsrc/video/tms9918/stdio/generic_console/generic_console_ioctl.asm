
        MODULE  tms9918_console_ioctl

        SECTION code_clib
        INCLUDE "ioctl.def"

        PUBLIC  __tms9918_console_ioctl
	EXTERN	__tms9918_CLIB_GENCON_CAPS
        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  __tms9918_cls
        EXTERN  __tms9918_set_font
        EXTERN  __console_w
        EXTERN  msx_set_mode
        EXTERN  LDIRVM
 
        INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_DIRECT = 1
        PUBLIC  generic_console_ioctl
	PUBLIC	CLIB_GENCON_CAPS

        defc    generic_console_ioctl = __tms9918_console_ioctl
	defc	CLIB_GENCON_CAPS = __tms9918_CLIB_GENCON_CAPS
ENDIF

; a = ioctl
; de = arg
__tms9918_console_ioctl:
        ex      de,hl
        ld      c,(hl)        ;bc = where we point to
        inc     hl
        ld      b,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
        ld      (generic_console_font32),bc
set_font_success:
        call    __tms9918_set_font
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,check_mode
        ld      (generic_console_udg32),bc
        jr      set_font_success
check_mode:
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
        ld      a,c
        and     a
        jr      z,set_mode
        cp      2
        jr      z,set_mode
        cp      1
        jr      nz,failure
set_mode:
        ld      l,c
        ld      h,0
        call    msx_set_mode	;Sets up __console_w + sets up fonts
        call    __tms9918_cls
        jr      success
failure:
        scf
        ret

