;       PC-G8xx / PC-E2xx  Program boot
;
;       Stefano Bodrato 2017
;
;       $Id: g800_crt0.asm - Stefano Exp $
;



	MODULE  g800_crt0
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
; Set an origin for the application (-zorg=) default to $100
;--------

IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = $100
ENDIF

	org     CRT_ORG_CODE

start:

        ld      (start1+1),sp   ;Save entry stack
IF      STACKPTR
        ld      sp,STACKPTR
ELSE
;		ld sp, $77df-64
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
ENDIF
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

        call    _main           ;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF

cleanup_exit:
start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls



	defm    "Small C+ G8xx"        ;Unnecessary file signature
	defb    0

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

	SECTION code_crt_init

;	ld	hl,??
;	ld	(base_graphics),hl



