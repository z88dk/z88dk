;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
; 	CLS - Clear the screen
;	
;	$Id: f_ansi_cls$
;

        SECTION  code_clib
	PUBLIC	ansi_cls

.ansi_cls
	ld	a,' '
    ld b,24*6
    ld de,0
	jp $bfee
