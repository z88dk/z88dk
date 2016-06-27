;
;       ZX81 pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

		        SECTION code_clib
			PUBLIC    cleargraphics
			;EXTERN    loadudg6
			EXTERN  filltxt
			;EXTERN  base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
	
	ld   l,0
	jp  filltxt
