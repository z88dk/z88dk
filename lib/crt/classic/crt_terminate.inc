;
; When a program terminates, what behaviour should we take?
;

INCLUDE "crt/classic/crt_exit_eidi.inc"

IF __crt_on_exit < 0x10000
    ; Jump to an address
    jp      __crt_on_exit
ELIF __crt_on_exit = 0x10001
    ; Halt
crt_exit_loop_forever:
    halt
    jr      crt_exit_loop_forever
ELIF __crt_on_exit = 0x10002
    ; Return to caller - unwind the atexit stack - we assume
    ; that we've not modified the entry stack
    INCLUDE	"crt/classic/crt_exit_atexit.inc"
    ret
ELIF __crt_on_exit = 0x10008
    ; Restart
    jp      start
ENDIF

