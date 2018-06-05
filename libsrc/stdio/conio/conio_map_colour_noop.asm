;
; Noop operation for mapping colours on platforms that:
; a) Don't support it
; b) Haven't implemented it yet
;

	SECTION		code_clib
	PUBLIC		conio_map_colour

conio_map_colour:
	ret
