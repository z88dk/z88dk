;
;      Startup for the s1mp3 players
;


	GLOBAL	_main

;	defc	CRT_ORG_BSS = 0x7000
	defc	CRT_ORG_CODE = 0x0000

        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0x4000

	defc	CONSOLE_COLUMNS = 16
	defc	CONSOLE_ROWS = 4

	INCLUDE	"zcc_opt.def"

        INCLUDE "crt/classic/crt_rules.inc"

	org	  CRT_ORG_CODE


if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

        jp      program

        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart08

        defs    $0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart10

        defs    $0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart18

        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart20

    defs        $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart28

        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart30

        defs    $0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
        reti

restart08:
restart10:
restart18:
restart20:
restart28:
restart30:
        ret

; In the .AP model there's a header here
program:
        di
        xor     a
        out     (0x27), a       ; MINT_ENABLE_REG
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	di
	halt
	jp	cleanup


l_dcal: jp      (hl)            ;Used for function pointer calls


        INCLUDE "crt/classic/crt_runtime_selection.asm"

        INCLUDE "crt/classic/crt_section.asm"
