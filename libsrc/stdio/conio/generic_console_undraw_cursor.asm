; Generic function to undraw the cursor
;
; This is a noop - should be overridden in the targets implementation


	SECTION	code_clib
	PUBLIC	generic_console_undraw_cursor


; Draw the cursor
;
; Entry: bc = cursor xypos
generic_console_undraw_cursor:
	ret
