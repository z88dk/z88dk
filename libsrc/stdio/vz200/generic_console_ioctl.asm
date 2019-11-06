
        MODULE        generic_console_ioctl
        PUBLIC        generic_console_ioctl

        SECTION       code_clib

        EXTERN        generic_console_cls
        EXTERN        __console_h
        EXTERN        __console_w
        EXTERN        __vz200_mode
        EXTERN        generic_console_font32
        EXTERN        generic_console_udg32

        INCLUDE        "ioctl.def"


; a = ioctl
; de = arg
generic_console_ioctl:
        ex      de,hl
        ld      c,(hl)        ;bc = where we point to
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
        jr      nz,check_mode
        ld      (generic_console_udg32),bc
        jr      success
check_mode:
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
        ld      a,c                 ; The mode
        and     31
        ld      h,0                 ;MODE_0
        ld      e,32                ;columns
        ld      l,16
        and     a
        jr      z,set_mode
        ld      l,8                 ;rows
        ld      h,8                 ;AGW mode
        ld      e,16                ;columns
        cp      1                   ;CG2 mode
        jr      nz,failure
set_mode:
        bit     5,c
        jr      z,not_css
        set     4,h                 ;Sets CSS on the latch
not_css:
        ld      (__vz200_mode),a    
        ld      a,h
        ld      ($783b),a       ;SYS VAR
        ld      ($6800),a       ;Latch
        ld      a,e
        ld      (__console_w),a
        ld      a,l
        ld      (__console_h),a
        call    generic_console_cls
        and     a
        ret
failure:
        scf
        ret
