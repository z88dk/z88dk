;
; Bandai Supervision 8000
;


	module 	  sv8000_crt0


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

        defc    CONSOLE_COLUMNS = 32
        defc    CONSOLE_ROWS = 16
	PUBLIC	GRAPHICS_CHAR_SET
	PUBLIC	GRAPHICS_CHAR_UNSET
	defc	GRAPHICS_CHAR_SET = 160
	defc	GRAPHICS_CHAR_UNSET = 32

        defc    CRT_ORG_BSS = 0x8000
        defc    CRT_ORG_CODE = 0x0000
        defc    TAR__fputc_cons_generic = 1
        defc    TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0x83ff
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 3579545
        INCLUDE "crt/classic/crt_rules.inc"

	org	CRT_ORG_CODE

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
	jp	asm_im1_handler

; Restart routines, nothing sorted yet
restart08:
restart10:
restart18:
restart20:
restart28:
restart30:
noop:
	ret

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
    	ei
	; Enable AY ports
	ld	a,7
	out	($c1),a
	ld	a,$7f
	out	($c0),a
	
	; Reset to text mode
	ld	a,14
	out	($c1),a
	ld	a,0
	out	($c0),a

	; Enable keyboard scanning
	ld	a,$92
	out	($83),a
	
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

l_dcal: jp      (hl)            ;Used for function pointer calls


	INCLUDE "crt/classic/crt_runtime_selection.asm" 

        defc    __crt_org_bss = CRT_ORG_BSS
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
        INCLUDE "crt/classic/crt_section.asm"

IF CLIB_DISABLE_MODE0 = 1
        PUBLIC  plot_MODE0
        PUBLIC  res_MODE0
        PUBLIC  xor_MODE0
        PUBLIC  pointxy_MODE0
        defc    plot_MODE0 = noop
        defc    res_MODE0 = noop
        defc    xor_MODE0 = noop
        defc    pointxy_MODE0 = noop
ENDIF

IF CLIB_DISABLE_MODE1 = 1
        PUBLIC  vpeek_MODE1
        PUBLIC  printc_MODE1
        PUBLIC  plot_MODE1
        PUBLIC  res_MODE1
        PUBLIC  xor_MODE1
        PUBLIC  pointxy_MODE1
        PUBLIC  pixeladdress_MODE1
	EXTERN	vpeek_noop
        defc    vpeek_MODE1 = vpeek_noop
        defc    printc_MODE1 = noop
        defc    plot_MODE1 = noop
        defc    res_MODE1 = noop
        defc    xor_MODE1 = noop
        defc    pointxy_MODE1 = noop
        defc    pixeladdress_MODE1 = noop
ENDIF
