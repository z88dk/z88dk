;
; There's only 512 bytes of user memory to play with on this machine,
; so strip everything down as much as we can
;
;

	module krokha_crt0


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


        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0xea00		;Guess
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 2000000
	
	; RAM trimming
	defc	DEFINED_CLIB_FOPEN_MAX = 1
	defc	CLIB_FOPEN_MAX = 3
	defc	DEFINED_basegraphics = 1 


        defc CRT_ORG_CODE = 0x0000
	defc CRT_ORG_BSS = 0xe000
	defc    __crt_org_bss = CRT_ORG_BSS

        INCLUDE "crt/classic/crt_rules.inc"
        defc    CONSOLE_COLUMNS = 48
        defc    CONSOLE_ROWS = 32


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
IF !__CPU_RABBIT__ && !__CPU_GBZ80__
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
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	ld	hl,0
	push	hl	;argv
	push	hl	;argc
	call	_main
cleanup:
	jp	0

l_dcal: jp      (hl)            ;Used for function pointer calls


	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"
