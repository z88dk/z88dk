;
;	Startup for test emulator
;
;	$Id: test_crt0.asm,v 1.12 2016-06-21 20:49:07 dom Exp $


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
	ld	sp,65280
	ld	hl,-64
	add	hl,sp
	ld	sp,hl
	call    crt0_init_bss
	ld	(exitsp),sp
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "amalloc.def"
ENDIF
	ld	a,(argv_length)
	and	a
	jr	z,argv_done
	ld	c,a
	ld	b,0
	ld	hl,argv_start
	add	hl,bc	; now points to end of the command line
	defc DEFINED_noredir = 1
	INCLUDE "crt0_command_line.asm"
	push	hl	;argv
	push	bc	;argc
	call	_main
	pop	bc
	pop	bc
cleanup:
	ld	a,CMD_EXIT	;exit
	rst	8


l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt0_runtime_selection.asm" 
	
	INCLUDE	"crt0_section.asm"

	SECTION rodata_clib
end:            defb    0               ; null file name
