;       TRS 80  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: trs80_crt0.asm,v 1.21 2016-07-15 21:03:25 dom Exp $
;

; 	There are a couple of #pragma commands which affect this file:
;
;	#pragma output nostreams - No stdio disc files
;	#pragma output nofileio  - No fileio at all, use in conjunction to "-lndos"
;	#pragma output noredir   - do not insert the file redirection option while parsing the
;	                           command line arguments (useless if "nostreams" is set)


	MODULE  trs80_crt0
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

	PUBLIC	EG2000_ENABLED
	PUBLIC	CLIB_KEYBOARD_ADDRESS

;--------
; Set an origin for the application (-zorg=) default to $5200
;--------

IF      !DEFINED_CRT_ORG_CODE
	IF (startup=2)
		defc	EG2000_ENABLED = 1
                defc    CRT_ORG_CODE  = 22500
		defc	CLIB_KEYBOARD_ADDRESS = 0xf800
	ELSE
		defc	EG2000_ENABLED = 0
                defc    CRT_ORG_CODE  = $5200
		defc	CLIB_KEYBOARD_ADDRESS = 0x3800
	ENDIF
ENDIF

IF (startup=2)
        defc    CONSOLE_ROWS = 24
        defc    CONSOLE_COLUMNS = 40
	defc	__CPU_CLOCK = 2216750
ELSE
        defc    CONSOLE_ROWS = 16
        defc    CONSOLE_COLUMNS = 64
	defc	__CPU_CLOCK = 1774000
ENDIF


        defc    TAR__fputc_cons_generic = 1
	defc	TAR__register_sp = -1
        defc    TAR__clib_exit_stack_size = 32
	INCLUDE	"crt/classic/crt_rules.inc"

	INCLUDE	"target/trs80/def/maths_mbf.def"

	org     CRT_ORG_CODE

start:
	ld	(cmdline+1),hl
        ld      (start1+1),sp   ;Save entry stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


	; Push pointers to argv[n] onto the stack now
	; We must start from the end 
cmdline:
	ld	hl,0	; SMC - command line back again
	ld	bc,0
	ld	a,(hl)
	cp	13
	jr	nz,nocr
	xor a
	ld	(hl),a
	jr  argv_done
nocr:
	dec	hl
find_end:
	inc	hl
	inc	c
	ld	a,(hl)
	cp	13
	jr	nz,find_end
	xor a
	ld	(hl),a
	dec	hl


	; defc DEFINED_noredir = 1
	INCLUDE	"crt/classic/crt_command_line.asm"

	push	hl	;argv
	push	bc	;argc
        call    _main           ;Call user program
	pop	bc	;kill argv
	pop	bc	;kill argc

cleanup:
;
;       Deallocate memory which has been allocated here!
;
IF CRT_ENABLE_STDIO = 1
        EXTERN     closeall
        call    closeall
ENDIF

cleanup_exit:
start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls


	INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE	"crt/classic/crt_section.asm"



	SECTION code_crt_init
IF (startup=2)
	call	$1c9		;CLS
	ld	hl,$4400   ; Address of the TEXT map for COLOUR GENIE
ELSE
	ld	hl,$3c00   ; Address of the TEXT (Semi-Graphics) map for TRS-80
ENDIF
	ld	(base_graphics),hl



	SECTION bss_crt
end:		defb	0		; null file name (used in argv/argc parsing)



	SECTION  rodata_clib
IF !DEFINED_noredir
IF CRT_ENABLE_STDIO = 1
redir_fopen_flag:		defb	'w',0
redir_fopen_flagr:		defb	'r',0
ENDIF
ENDIF

