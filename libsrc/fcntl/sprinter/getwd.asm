;	Sprinter fcntl library
;
;	$Id: getwd.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $
;

                SECTION   code_clib
                PUBLIC   getwd
                PUBLIC   _getwd

;int getwd(char *buf);
; NB buf must be at least 256 bytes


.getwd	
._getwd
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

