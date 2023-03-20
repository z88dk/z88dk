
SECTION code_clib

PUBLIC __tms9918_setup_spec

EXTERN __tms9918_terminal_spec
EXTERN __tms9918_spec_end
EXTERN __tms9918_spec_columns
EXTERN __console_w
EXTERN __tms9918_spec_capabilities
EXTERN generic_console_caps
EXTERN  __tms9918_screen_mode
EXTERN __tms9918_gencon_hook


; Entry: hl = spec table
__tms9918_setup_spec:
    ld      de,__tms9918_terminal_spec
    ld      bc,+(__tms9918_spec_end - __tms9918_terminal_spec)
    ldir

    ; Setup variables for gencon
    ld      hl,(__tms9918_spec_columns)     ;Set width + height
    ld      (__console_w),hl
    ld      a,(__tms9918_spec_capabilities)
    ld      (generic_console_caps),a


    ; And call the hook for gencon if set
    ld      hl,(__tms9918_gencon_hook)
    ld      a,h
    or      l
    ret     z
    ld      a,(__tms9918_screen_mode)
    jp      (hl)



SECTION bss_clib

__tms9918_gencon_hook:    defw    0           ;Hook for setting the mode for gencon as necessary
