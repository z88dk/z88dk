

    SECTION code_clib
    PUBLIC  generic_console_ioctl

    EXTERN  __console_w
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __fp1100_mode
    
    INCLUDE "target/fp1100/def/fp1100.def"
    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE 

generic_console_ioctl:
        ex      de,hl
        ld      c,(hl)  ;bc = where we point to
        inc     hl
        ld      b,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
        ld      (generic_console_font32),bc
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,check_set_mode
        ld      (generic_console_udg32),bc
        jr      success
check_set_mode:
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
        ld      a,c
        ld      b,0
        ld      l,40
        and     1
        jr      z,setmode
        ld      b,1
        ld      l,80
        dec     a
        jr      z,setmode
failure:
        scf
        ret

setmode:
        ld      a,c
        ld      (__fp1100_mode),a
        ld      a,l
        ld      (__console_w),a
        ld      a,SUB_SCREENSIZE
        call    TRNC2
        and     a
        ret
