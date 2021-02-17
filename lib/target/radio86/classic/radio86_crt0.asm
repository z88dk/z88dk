
	module radio86_crt0


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
        defc    TAR__register_sp = -1
	defc    TAR__fputc_cons_generic = 0
	defc	CLIB_DISABLE_FGETS_CURSOR = 1
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 1777000
	
	; RAM trimming
	defc	DEFINED_CLIB_FOPEN_MAX = 1
	defc	CLIB_FOPEN_MAX = 3


        defc CRT_ORG_CODE = 0x0000

        defc    TAR__crt_enable_rst = $0000

        INCLUDE "crt/classic/crt_rules.inc"
        defc    CONSOLE_COLUMNS = 64
        defc    CONSOLE_ROWS = 25

	PUBLIC	GRAPHICS_CHAR_SET
	PUBLIC	GRAPHICS_CHAR_UNSET
	defc	GRAPHICS_CHAR_SET = 127
	defc	GRAPHICS_CHAR_UNSET = 32


	org	  CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

	jp	program
	INCLUDE	"crt/classic/crt_z80_rsts.asm"
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
	jp	$f800

l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"
