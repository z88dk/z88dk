; Dummy function to keep rest of libs happy
;
; $Id: write.asm,v 1.4 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib

		PUBLIC	write
		PUBLIC	_write

		INCLUDE	"target/test/def/test_cmds.def"

.write
._write
        pop     af
        pop     hl
        pop     de
        pop     bc
        push    bc
        push    de
        push    hl
        push    af
        ld      b,c
        ld      a,CMD_WRITEBLOCK
	call	SYSCALL
        ret
