;       NEC PC-8801 stub
;
;       Stefano Bodrato - 2018
;
;	$Id: pc88_crt0.asm $
;

; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma output nostreams      - No stdio disc files
;	#pragma output nofileio       - No fileio at all, use in conjunction to "-lndos"
;	#pragma output noprotectmsdos - strip the MS-DOS protection header
;	#pragma output noredir        - do not insert the file redirection option while parsing the
;	                                command line arguments (useless if "nostreams" is set)
;
;	These can cut down the size of the resultant executable

                MODULE  pc88_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

		defc    crt0 = 1
                INCLUDE "zcc_opt.def"


	EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal
		
        PUBLIC    pc88bios

;--------
; Some scope definitions
;--------



; PC8801 platform specific stuff
;


; Now, getting to the real stuff now!

IF (!DEFINED_startup || (startup=1))
        IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE  = $8A00
        ENDIF
ELSE
        IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE = $100   ; CP/M, IDOS, etc..
        ENDIF
ENDIF
	defc	CONSOLE_COLUMNS = 80
	defc    CONSOLE_ROWS = 20
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

	org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:

IF (!DEFINED_startup || (startup=1))
	ld	a,$FF				; back to main ROM
	out ($71),a				; bank switching
ENDIF

        ld      (start1+1),sp
		
		; Last minute hack to keep the stack in a safe place and permit the hirez graphics to page
		; the GVRAM banks in and out
	ld	sp,$BFFF
		
	; Increase to cover ROM banking (useless at the moment, we're wasting 18 bytes!!)
	defc	__clib_exit_stack_size_t  = __clib_exit_stack_size + 18
	UNDEFINE __clib_exit_stack_size
	defc	__clib_exit_stack_size = __clib_exit_stack_size_t
	
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

	ld	a,(defltdsk)
	ld	($EC85),a
	
IF (startup=2)
;

ELSE

;** If NOT IDOS mode, just get rid of BASIC screen behaviour **
	call $4021	; Hide function key strings
ENDIF
	call    _main
	;call TOTEXT ;- force text mode on exit
;**
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

        call    crt0_exit


start1:
        ld      sp,0
		
	ld	a,$FF		; restore Main ROM
	out     ($71),a
		
	ld	a,($EC85)
	ld	(defltdsk),a

        ret

l_dcal:
        jp      (hl)



; ROM interposer. This could be, sooner or later, moved to a convenient position in RAM
; (e.g.  just before $C000) to be able to bounce between different RAM/ROM pages
pc88bios:
	push	af
	ld	a,$FF		; MAIN ROM
	out     ($71),a
	pop	af
	jp	(ix)
	


	INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"

; ---------------------
; PC8801 specific stuff
; ---------------------


	SECTION		bss_crt


	PUBLIC	defltdsk

; This last part at the moment is useless, but doesn't harm

defltdsk:       defb    0	; Default disc


IF (startup=2)
IF !DEFINED_nofileio
	PUBLIC	__fcb
__fcb:		defs	420,0	;file control block (10 files) (MAXFILE)
ENDIF
ENDIF


IF (!DEFINED_startup || (startup=1))
        INCLUDE "target/pc88/classic/bootstrap.asm"
ENDIF
