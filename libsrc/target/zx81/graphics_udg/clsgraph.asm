;
;       ZX81 pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm,v 1.4 2017-01-02 22:58:00 aralbrec Exp $
;

		        SECTION code_clib
			PUBLIC    cleargraphics
         PUBLIC    _cleargraphics
			;EXTERN    loadudg6
			EXTERN  filltxt
			;EXTERN  base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
._cleargraphics
	
	ld   l,0
	jp  filltxt
