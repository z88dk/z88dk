;
; 	ANSI Video handling for the Amstrad CPC
;
; 	CLS - Clear the screen
;	
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2004-07-15 10:03:49 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls
	
	;ld	a,0	; 20x25x16 text mode
	;ld	a,1	; 40x25x4 text mode
	;ld	a,2	; 80x25 mono text mode
	;call	$bc0e	;set mode
	
	; call $BB7B 
	call	$BB4E	; init TEXT
        ld      a,2
        call	$BB90 	;ink	bright cyan
        ld	a,0
        call	$BB96	;paper	blue
	ld	a,$0C
	jp	$BB5A	; Form Feed (CLS)

