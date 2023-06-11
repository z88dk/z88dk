
SECTION code_video_vdp
PUBLIC  vdp_set_mangled_mode
PUBLIC  _vdp_set_mangled_mode


EXTERN  VDPreg_Write
EXTERN  FILVRM

EXTERN  __tms9918_pattern_generator
EXTERN  __tms9918_colour_table
EXTERN  __tms9918_attribute

EXTERN  __tms9918_set_font
EXTERN  __tms9918_set_font_at_addr
EXTERN  __tms9918_setup_mode2_pattern

EXTERN  __vdp_mode1


vdp_set_mangled_mode:
_vdp_set_mangled_mode:
    call    __vdp_mode1

    ld      e,$00
IF FORm5
    ld      a,3           ; external video flag bit must be set on M5
ELSE
    ld      a,2           ; .. and reset on the other targets
ENDIF    
    call    VDPreg_Write
    ld      e,3
    ld      a,$ff
    call    VDPreg_Write
    ld      a,3
    call    VDPreg_Write    ;register 4

    ld      hl,(__tms9918_pattern_generator)
    ld      bc,6144
    xor     a
    call    FILVRM
    
    call    __tms9918_setup_mode2_pattern

    ; Clear the colour table
    ld      hl,(__tms9918_colour_table)	;Clear the pattern generator table
    ld      bc,6144
    ld      a,(__tms9918_attribute)   ; white on black
    call    FILVRM

    ; ; Now copy the font 3 times
    ; call    __tms9918_set_font
    ; ld      de,(__tms9918_pattern_generator)
    ; ld      a,d
    ; add     8
    ; ld      d,a
    ; call    __tms9918_set_font_at_addr
    ; ld      de,(__tms9918_pattern_generator)
    ; ld      a,d
    ; add     16
    ; ld      d,a
    ; call    __tms9918_set_font_at_addr
    ret
