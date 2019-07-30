; Generic function to enable disable the cursor
;
; This is a noop - should be overridden in the targets implementation


	SECTION	code_clib
	PUBLIC	generic_console_toggle_cursor


; Enable/disable the cursor
;
; Entry: hl = flags
;
; Check bit 1 of (hl) - if set, the cursor should be enabled
;
; This function is probably of use for hardware cursors
generic_console_toggle_cursor:
	ret
