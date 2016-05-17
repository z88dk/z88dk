;
;	Startup for test emulator
;
;	$Id: test_crt0.asm,v 1.10 2016-05-17 19:21:22 dom Exp $


	module test_crt0
	org	  0x0000

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

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)



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
; IM1 interrupt routine
	ei
	ret

restart08:
	; a = command to execute
	defb	$ED, $FE	;trap
	ret
; Restart routines, nothing sorted yet
restart10:
restart18:
restart20:
restart28:
restart30:
	ret

program:
	ld	sp,65535
	ld	hl,-64
	add	hl,sp
	ld	sp,hl
	ld	(exitsp),sp
    	ei
	call    crt0_init_bss
	call	_main
cleanup:
	ld	a,CMD_EXIT	;exit
	rst	8


l_dcal: jp      (hl)            ;Used for function pointer calls

IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

	INCLUDE "crt0_runtime_selection.asm" 
	
	INCLUDE	"crt0_section.asm"

