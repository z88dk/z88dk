;
;	TMS9918 generic variant
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern clg();
;
;	Init and clear graphics screen
;
;	$Id: clg.asm $
;

    SECTION code_clib

    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  msx_set_border
    EXTERN  msx_set_mode
    EXTERN  FILVRM
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_pattern_generator

clg:
_clg:

    ld      a,(__tms9918_screen_mode)
    and     a   ;MODE 0
    jr      z,clg_mode2
    dec     a   ;MODE 1
    jr      z,clg_mode2
    dec     a   ;MODE 2
    jr      z,clg_mode2

; Clearing for an already entered mode3 here
    xor     a       ;Tranparent
    ld      hl,(__tms9918_pattern_generator)	;Clear the pattern generator table
    ld      bc,1536
    xor     a
    call    FILVRM
    ret

clg_mode2:
    ld      hl,2
    call    msx_set_mode
    ld      a,$1F   	; black on white attributes
    ld      (__tms9918_attribute),a
    ld      hl,8192    ; set VRAM attribute area
    ld      bc,6144
    push    bc
    call    FILVRM
    pop     bc
    xor     a
    ld      hl,(__tms9918_pattern_generator)
    call    FILVRM

    ld      l,$0F
    call    msx_set_border

    ret
