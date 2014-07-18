;
;       ZX81 pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm,v 1.1 2014-07-18 06:18:08 stefano Exp $
;


			XLIB    cleargraphics
			LIB     loadudg6
			LIB     filltxt
			XREF	base_graphics

			INCLUDE	"graphics/grafix.inc"


.cleargraphics
	
	ld   l,0
	jp  filltxt
