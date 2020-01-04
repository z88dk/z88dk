; Dummy function to keep rest of libs happy
;
; $Id: open.asm,v 1.6 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib
		INCLUDE	"target/test/def/test_cmds.def"

		PUBLIC	open
		PUBLIC	_open

; char *name, int flags, mode_t mode)
.open
._open
	pop	af
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc
	push	af
	ld	a,CMD_OPENF
	call	SYSCALL
	ret
