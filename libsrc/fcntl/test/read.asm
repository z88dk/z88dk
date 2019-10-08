; Dummy function to keep rest of libs happy
;
; $Id: read.asm,v 1.4 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib
		INCLUDE	"target/test/def/test_cmds.def"

		PUBLIC	read
		PUBLIC	_read
; (fd, buf,len)
.read
._read
	pop	af
	pop	hl
	pop	de
	pop	bc
	push	bc
	push	de
	push	hl
	push	af
	ld	b,c
	ld	a,CMD_READBLOCK
	call	SYSCALL
	ret
