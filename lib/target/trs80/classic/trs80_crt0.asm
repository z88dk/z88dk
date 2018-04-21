;       TRS 80  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: trs80_crt0.asm,v 1.21 2016-07-15 21:03:25 dom Exp $
;



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


;--------
; Set an origin for the application (-zorg=) default to $5200
;--------

IF      !DEFINED_CRT_ORG_CODE
	IF (startup=2)
                defc    CRT_ORG_CODE  = 22500
	ELSE
                defc    CRT_ORG_CODE  = $5200
	ENDIF
ENDIF

        defc    CONSOLE_ROWS = 16
        defc    CONSOLE_COLUMNS = 64


        defc    TAR__fputc_cons_generic = 1
	defc	TAR__register_sp = -1
        defc    TAR__clib_exit_stack_size = 32
	defc	__CPU_CLOCK = 1774000
	INCLUDE	"crt/classic/crt_rules.inc"

	org     CRT_ORG_CODE

start:
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


        call    _main           ;Call user program

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



	defm    "Small C+ TRS80"        ;Unnecessary file signature
	defb    0

        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"

	SECTION code_crt_init
IF (startup=2)
	ld	hl,$4800   ; Address of the Graphics map   COLOUR GENIE
ELSE
	ld	hl,$3c00   ; Address of the Graphics map
ENDIF
	ld	(base_graphics),hl



