;
; 	ANSI Video handling for the Sanyo computers
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;

        SECTION  code_clib

	PUBLIC	ansi_CHAR

	EXTERN	generic_console_printc
	EXTERN	__sanyo_attr
	EXTERN	mbc_sendchar

.ansi_CHAR

		ex af,af

		ld l,27
		call mbc_sendchar
		ld l,'t'
		call mbc_sendchar
		ld a,(__sanyo_attr)
		ld l,a
		call mbc_sendchar

		ex af,af


		jp generic_console_printc
