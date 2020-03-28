; Dummy function to keep rest of libs happy
;
; $Id: readbyte.asm,v 1.5 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib

		INCLUDE "target/test/def/test_cmds.def"

		PUBLIC	readbyte
		PUBLIC	_readbyte

.readbyte
._readbyte
	ld	b,l
	ld	a,CMD_READBYTE
	call	SYSCALL
	ret
