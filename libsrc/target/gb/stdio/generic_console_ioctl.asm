
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib

    EXTERN  generic_console_cls
    EXTERN  __console_h
    EXTERN  __console_w
    EXTERN  __mode
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  tmode
    EXTERN  tmode_load_udgs
    EXTERN  gmode
    EXTERN  asm_load_z88dk_font
    EXTERN  asm_load_z88dk_udg
    EXTERN  l_jphl

    INCLUDE	"ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS

; Entry:
; a = ioctl
; de = &arg
; Exit: nc=success, c=failure
generic_console_ioctl:
    ld      h,d
    ld      l,e
    ld	    c,(hl)	;bc = where we point to
    inc	    hl
    ld	    b,(hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz,check_set_udg
    ld      hl,generic_console_font32
    ld      (hl),c
    inc     hl    
    ld      (hl),b
    ld      a,(__mode)
    dec     a
    call    nz,asm_load_z88dk_font      ; We only need to load them in text mode
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz,check_mode
    ld      hl,generic_console_udg32
    ld      (hl),c
    inc     hl
    ld      (hl),b
    ld      a,(__mode)
    dec     a
    call    nz,asm_load_z88dk_udg      ; We only need to load them in text mode
    and     a
    ret
check_mode:
    cp	    IOCTL_GENCON_SET_MODE
    scf
    ret     nz
    ld	    a,c		; The mode
    ld	    hl,gmode
    cp	    1		; Drawing mode
    jr	    z,set_mode
    ld	    hl,tmode	; Otherwise it's text mode...
set_mode:
    call    l_jphl		; Initialise the mode
    call    generic_console_cls
    and	a
    ret
