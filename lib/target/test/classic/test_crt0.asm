;
;	Startup for test emulator
;
;	$Id: test_crt0.asm,v 1.12 2016-06-21 20:49:07 dom Exp $


	module test_crt0

	INCLUDE	"test_cmds.def"

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code
        EXTERN    asm_im1_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = 65280
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

IF      !DEFINED_CRT_ORG_CODE
        defc CRT_ORG_CODE = 0x0000
ENDIF

	org	  CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

	jp	program

	defs	$0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart08

	defs	$0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart10

	defs	$0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart18

	defs	$0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart20

    defs	$0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart28

	defs	$0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart30

	defs	$0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
IF !__CPU_8080__
	jp	asm_im1_handler
ELSE
	ret
ENDIF

; Restart routines, nothing sorted yet
restart08:
restart10:
restart18:
restart20:
restart28:
restart30:
	ret

ENDIF

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	hl,0
	add	hl,sp
	ld	(exitsp),hl
IF !__CPU_R2K__
    	ei
ENDIF
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	ld	a,(argv_length)
	and	a
	jp	z,argv_done
	ld	c,a
	ld	b,0
	ld	hl,argv_start
	add	hl,bc	; now points to end of the command line
	defc DEFINED_noredir = 1
	INCLUDE "crt/classic/crt_command_line.asm"
	push	hl	;argv
	push	bc	;argc
	call	_main
	pop	bc
	pop	bc
cleanup:
	ld	a,CMD_EXIT	;exit
	; Fall into SYSCALL

SYSCALL:
	; a = command to execute
	defb	$ED, $FE	;trap
	ret

l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION rodata_clib
end:            defb    0               ; null file name
