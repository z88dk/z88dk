; Dummy function to keep rest of libs happy
;
; $Id: write.asm,v 1.4 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib

		PUBLIC	write
		PUBLIC	_write
		PUBLIC	___write

		INCLUDE	"target/test/def/test_cmds.def"

.write
._write
.___write
        ld      hl,2
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        push    bc
        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        pop     hl
        ld      b,c
        ld      a,CMD_WRITEBLOCK
	call	SYSCALL
        ret
