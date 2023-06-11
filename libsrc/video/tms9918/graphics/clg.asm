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

    SECTION code_video_vdp

    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  __tms9918_graphics_cls

clg:
_clg:
    ld      hl,(__tms9918_graphics_cls)
    jp      (hl)

