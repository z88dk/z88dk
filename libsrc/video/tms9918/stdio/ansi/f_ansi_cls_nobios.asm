;
; 	ANSI Video handling for the MSX
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Sept. 2017
;
;
;	$Id: f_ansi_cls_nobios.asm $
;

    SECTION code_video_vdp
    PUBLIC  ansi_cls
    PUBLIC  _ansi_cls
    PUBLIC  __tms9918_mode2_cls

    EXTERN  vdp_set_mode

    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_colour_table
    EXTERN  __tms9918_pattern_generator

    EXTERN	FILVRM

    INCLUDE	"graphics/grafix.inc"


.ansi_cls
._ansi_cls
    ld      hl,2            ; set graphics mode
    call    vdp_set_mode
__tms9918_mode2_cls:
    ld      a,(__tms9918_attribute)
    ld      hl,(__tms9918_colour_table)
    ld      bc,6144
    push    bc
    call    FILVRM
    pop     bc          ; clear VRAM picture area
    xor     a
    ld      hl,(__tms9918_pattern_generator)
    jp      FILVRM

