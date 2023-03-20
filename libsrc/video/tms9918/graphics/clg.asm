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

    EXTERN  ansi_cls
    EXTERN  FILVRM
    EXTERN  __tms9918_screen_mode
    EXTERN  __tms9918_pattern_generator

clg:
_clg:

    ld      a,(__tms9918_screen_mode)
    and     a   ;MODE 0 (no gfx)
    jr      z,clg_mode2
    dec     a   ;MODE 1 (no gfx)
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
    jp      ansi_cls
