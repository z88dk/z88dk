
        MODULE  tms9918_console_ioctl

        SECTION code_clib
        INCLUDE "ioctl.def"

        PUBLIC  __tms9918_console_ioctl
        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  __tms9918_cls
        EXTERN  __console_w
        EXTERN  msx_set_mode
        EXTERN  LDIRVM
 
        INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_DIRECT = 1
        PUBLIC  generic_console_ioctl

        defc    generic_console_ioctl = __tms9918_console_ioctl
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
        call    set_font
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
        ld      l,32
        and     a
        jr      z,set_mode
        cp      2
        jr      z,set_mode
        ld      l,40
        cp      1
        jr      nz,failure
set_mode:
        ld      a,l
        ld      (__console_w),a
        ld      l,c
        ld      h,0
        push    bc
        call    msx_set_mode
        pop     bc
        ld      a,c
        cp      2         ;mode 2 doesn't need a font
        call    nz,set_font
        call    __tms9918_cls
        jr      success
failure:
        scf
        ret

; Set the font, required for mode 0 and mode 1
set_font:
        ; TODO: First 32 characters aren't set
        push    ix
        ld      hl,(generic_console_font32)
        ld      de, $2000 + 256
        ld      bc, 768                        ;96 characters
        call    LDIRVM
        ld      hl,(generic_console_udg32)
        ld      de, $2000 + 1024
        ld      bc, 1024                ;128 characters
        call    LDIRVM
        pop     ix
        ret
