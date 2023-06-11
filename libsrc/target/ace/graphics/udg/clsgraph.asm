;
;       Jupiter ACE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2014
;
;
;       $Id: clsgraph.asm $
;

	SECTION   code_clib
	PUBLIC    cleargraphics
        PUBLIC    _cleargraphics
	EXTERN     loadudg6
        EXTERN    generic_console_cls

	INCLUDE	"graphics/grafix.inc"


.cleargraphics
._cleargraphics
	ld   c,0	; first UDG chr$ to load
	ld   b,32	; number of characters to load
	ld   hl,$2c00	; UDG area
	call loadudg6
        jp   generic_console_cls
