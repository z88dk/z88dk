;
;	Startup for test emulator
;
;	$Id: test_crt0.asm,v 1.8 2016-04-25 12:58:31 dom Exp $


    module test_crt0
	org	  0x0000

	INCLUDE	"test_cmds.def"

;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

        PUBLIC    heaplast        ;Near malloc heap variables
        PUBLIC    heapblocks
        PUBLIC    __sgoioblk      ;stdio info block



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
	call    crt_init_start
	call	_main
cleanup:
	ld	a,CMD_EXIT	;exit
	rst	8


l_dcal: jp      (hl)            ;Used for function pointer calls

IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

;---------------------------------
; Select which printf core we want
;---------------------------------
	PUBLIC	asm_vfprintf
IF DEFINED_floatstdio
	EXTERN	asm_vfprintf_level3
	defc	asm_vfprintf = asm_vfprintf_level3
ELSE
	IF DEFINED_complexstdio
	        EXTERN	asm_vfprintf_level2
		defc	asm_vfprintf = asm_vfprintf_level2
	ELSE
	       	EXTERN	asm_vfprintf_level1
		defc	asm_vfprintf = asm_vfprintf_level1
	ENDIF
ENDIF
       


    SECTION code_crt_init
crt_init_start:
	; TODO: Clear down bss
IF !DEFINED_nostreams
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
    ;; Code gets placed in this section
    SECTION code_crt_exit
    	ret

    SECTION code_compiler
    SECTION code_clib
    SECTION code_crt0_sccz80
    SECTION code_l_sdcc
    SECTION code_math
    SECTION code_error
    SECTION data_compiler
    SECTION data_clib
    SECTION rodata_compiler
    SECTION rodata_clib
    SECTION smc_clib
    SECTION bss_crt
;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
;-----------
__sgoioblk:	defs	40

 

;-----------
; Now some variables
;-----------
coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    0       ; Address of the Graphics map


exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

                defm    "Small C+ TEST"   ;Unnecessary file signature
                defb    0

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
fp_seed:        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
extra:          defs    6               ;FP register
fa:             defs    6               ;FP Accumulator
fasign:         defb    0               ;FP register

ENDIF

    SECTION bss_compiler
    SECTION bss_clib
    SECTION bss_error
