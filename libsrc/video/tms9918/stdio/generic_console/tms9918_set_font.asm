
    SECTION code_video_vdp
    PUBLIC  __tms9918_set_font
    PUBLIC  __tms9918_set_font_at_addr

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __tms9918_pattern_generator
    EXTERN  LDIRVM

__tms9918_set_font:
    ; TODO: First 32 characters aren't set
    ld      de,(__tms9918_pattern_generator)
__tms9918_set_font_at_addr:
    push    ix
    ld      hl,(generic_console_font32)
    inc     d
    ld      bc, 768                        ;96 characters
    ld      a,h
    or      l
    call    nz,LDIRVM
    ld      hl,(generic_console_udg32)
    ld      de,(__tms9918_pattern_generator)
    inc     d
    inc     d
    inc     d
    inc     d
    ld      bc, 1024                ;128 characters
    ld      a,h
    or      l
    call    nz,LDIRVM
    pop     ix
    ret
