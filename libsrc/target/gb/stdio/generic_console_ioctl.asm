
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib

    EXTERN  generic_console_cls
    EXTERN  __console_h
    EXTERN  __console_w
    EXTERN  __mode
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_caps
    EXTERN  tmode
    EXTERN  tmode_load_udgs
    EXTERN  gmode
    EXTERN  asm_load_z88dk_font
    EXTERN  asm_load_z88dk_udg
    EXTERN  l_jphl

    INCLUDE	"ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_MODE0
    defc    CAP_MODE0 = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS 
    defc    CAP_MODE1 = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_INVERSE | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE

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
    ld      d,CAP_MODE1
    ld	    a,c		; The mode
    ld	    hl,gmode
    cp	    1		; Drawing mode
    jr	    z,set_mode
    ld      d,CAP_MODE0
    ld	    hl,tmode	; Otherwise it's text mode...
set_mode:
    ld      a,d
    ld      (generic_console_caps),a
    call    l_jphl		; Initialise the mode
    call    generic_console_cls
    and	    a
    ret
