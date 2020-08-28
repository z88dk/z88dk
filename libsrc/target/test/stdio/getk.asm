		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

		INCLUDE	"target/test/def/test_cmds.def"

.getk
._getk
	ld	a,CMD_POLLKEY
	call	SYSCALL
	ret

