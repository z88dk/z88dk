;
; When a program terminates, what behaviour should we take?
;


IF __crt_on_exit < 0x10000
	; Jump to an address
        jp      __crt_on_exit
ELIF __crt_on_exit = 0x10001
	; Halt
        halt
	jr	ASMPC
ELIF __crt_on_exit = 0x10002
	; Return to caller
        ret
ELIF __crt_on_exit = 0x10008
	; Restart
        jp	start
ENDIF

