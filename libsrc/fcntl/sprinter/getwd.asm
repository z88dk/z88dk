;	Sprinter fcntl library
;
;	$Id: getwd.asm,v 1.3 2016-03-13 18:14:13 dom Exp $
;

                SECTION   code_clib
                PUBLIC   getwd

;int getwd(char *buf);
; NB buf must be at least 256 bytes


.getwd	
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix	;save callers
	push	hl
	ld	c,$1E	;CURDIR
	rst	$10
	pop	hl
	pop	ix
	ret	nc
	ld	hl,0	;error
	ret

