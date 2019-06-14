; Dummy function to keep rest of libs happy
;
; $Id: close.asm,v 1.5 2016-03-06 21:39:54 dom Exp $
;

		SECTION	code_clib
		INCLUDE	"target/test/def/test_cmds.def"

		PUBLIC	close
		PUBLIC	_close

.close
._close
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	b,c
	ld	a,CMD_CLOSEF
	call	SYSCALL
	ret
