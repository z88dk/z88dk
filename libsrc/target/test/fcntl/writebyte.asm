; Dummy function to keep rest of libs happy
;
; $Id: writebyte.asm,v 1.5 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib

		INCLUDE	"target/test/def/test_cmds.def"
		PUBLIC	writebyte
		PUBLIC	_writebyte
		PUBLIC	___writebyte

.writebyte
._writebyte
.___writebyte
	pop	de
	pop	hl
	pop	bc
	push	bc
	push	hl
	push	de
	ld	b,c
	ld	a,CMD_WRITEBYTE
	call	SYSCALL
	ret
