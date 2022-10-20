;
;==============================================================
;
; int getplot();
;
;   Returns the plot area
;
SECTION code_clib

PUBLIC getplot
PUBLIC _getplot

EXTERN base_graphics

getplot:
_getplot:
	ld hl,(base_graphics)
	ret

