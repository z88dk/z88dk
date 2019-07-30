; Generic function to draw the cursor
;
; This is a noop - should be overridden in the targets implementation


	SECTION	code_clib
	PUBLIC	generic_console_draw_cursor


; Draw the cursor
;
; Entry: bc = cursor xypos
generic_console_draw_cursor:
	ret
