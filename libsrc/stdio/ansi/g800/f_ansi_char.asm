;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm$
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	

.text_cols   defb 24

	EXTERN	ansirows
.text_rows   defb ansirows

; PC-G850
;.text_rows   defb 6
; PC-G815, PC-E200, PC-E220
;.text_rows   defb 4


.ansi_CHAR
	ld de,(ansi_COLUMN)
	jp	$BE62
