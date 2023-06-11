;
; 	ANSI Video handling for the Sanyo computers
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - 2023
;
;
;	$Id: f_ansi_cls.asm $
;

        SECTION  code_clib

        EXTERN    mbc_sendchar

	PUBLIC	ansi_cls

ansi_cls:
		ld l,26
		jp mbc_sendchar
