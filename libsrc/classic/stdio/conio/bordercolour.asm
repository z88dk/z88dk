;
; Noop operation for setting the border colour on platforms that:
; a) Don't support it
; b) Haven't implemented it yet
;

	SECTION		code_clib
	PUBLIC		bordercolor
	PUBLIC		_bordercolor

bordercolor:
_bordercolor:
	ret
