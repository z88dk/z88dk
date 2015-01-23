;
;       ZX81 pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm,v 1.2 2015-01-23 07:07:31 stefano Exp $
;


			PUBLIC    cleargraphics
			;EXTERN    loadudg6
			EXTERN  filltxt
			;EXTERN  base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
	
	ld   l,0
	jp  filltxt
