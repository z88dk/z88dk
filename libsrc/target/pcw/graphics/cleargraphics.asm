;
;       Amstrad PCW graphics routines
;

;
; $Id: cleargraphics.asm $
;

        SECTION   code_clib
	
	PUBLIC	cleargraphics
	PUBLIC	_cleargraphics
	PUBLIC	clg
	PUBLIC	_clg


cleargraphics:
_cleargraphics:
clg:
_clg:
        ld      de,initscr
        ld      c,9
        jp      5


initscr:
             defb 27
             defb 'f'	; hide cursor
             defb 27
             defb 'E'
             defb '$'	; clear screen
