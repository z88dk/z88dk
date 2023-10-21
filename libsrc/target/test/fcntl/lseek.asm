; $Id: lseek.asm,v 1.4 2016-03-06 21:39:54 dom Exp $

        SECTION code_clib


	INCLUDE "target/test/def/test_cmds.def"

	PUBLIC	lseek
	PUBLIC	_lseek
	PUBLIC	___lseek

; fd, where, whence
.lseek
._lseek
.___lseek
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        push    ix              ;save callers
        ld      ix,2
        add     ix,sp

	ld	c, (ix + 2)	;whence
	ld	b, (ix + 8)

	ld	l, (ix + 4)
	ld	h, (ix + 5)
	ld	e, (ix + 6)
	ld	d, (ix + 7)

	ld	a,CMD_SEEK
	call	SYSCALL
	pop	ix		;restore callers
ENDIF
	ret
