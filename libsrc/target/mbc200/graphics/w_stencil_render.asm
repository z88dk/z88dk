;
;		SANYO MBC-200

;
;	Render the "stencil".
;	The dithered horizontal lines base their pattern on the Y coordinate
;	and on an 'intensity' parameter (0..11).
;	Basic concept by Rafael de Oliveira Jannone
;	
;	Machine code version by Stefano Bodrato, 22/4/2009
;
;	stencil_render(unsigned char *stencil, unsigned char intensity)
;

    INCLUDE	"graphics/grafix.inc"

    SECTION code_clib

    PUBLIC  stencil_render
    PUBLIC  _stencil_render
	
	EXTERN  __generic_stencil_render


;	
;	$Id: w_stencil_render.asm $
;

.stencil_render
._stencil_render
    jp      __generic_stencil_render
