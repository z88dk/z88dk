;	Sprinter fcntl library
;
;	$Id: getwd.asm,v 1.1 2002-11-20 20:28:44 dom Exp $
;


                XLIB   getwd

;int getwd(char *buf);
; NB buf must be at least 256 bytes


.getwd	
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	ld	c,$1E	;CURDIR
	rst	$10
	pop	hl
	ret	nc
	ld	hl,0	;error
	ret

