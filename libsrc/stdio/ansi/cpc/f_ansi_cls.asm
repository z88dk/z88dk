;
; 	ANSI Video handling for the Amstrad CPC
;
; 	CLS - Clear the screen
;	
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_cls.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

        XLIB	ansi_cls

        INCLUDE "#cpcfirm.def"

 .ansi_cls	
	;ld	a,0	; 20x25x16 text mode
	;ld	a,1	; 40x25x4 text mode
	;ld	a,2	; 80x25 mono text mode
	;call	$bc0e	;set mode
	
        call    firmware
        defw    txt_initialise
        ld      a,2
        call    firmware
        defw    txt_set_pen
        xor     a
        call    firmware
        defw    txt_set_paper
        ld      a,$0c
        call    firmware
        defw    txt_output
        ret

