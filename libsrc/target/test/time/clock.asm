;
;

		SECTION code_clib
		PUBLIC	clock
		PUBLIC	_clock

		INCLUDE	"target/test/def/test_cmds.def"

.clock
._clock
	ld	a,CMD_GETCLOCK
	call	SYSCALL
	ret

