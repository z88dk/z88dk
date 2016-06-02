;       TRS 80  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: trs80_crt0.asm,v 1.17 2016-06-02 22:24:57 dom Exp $
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

IF      !myzorg
	IF (startup=2)
                defc    myzorg  = 22500
	ELSE
                defc    myzorg  = $5200
	ENDIF
ENDIF

	org     myzorg

start:
        ld      (start1+1),sp   ;Save entry stack
IF      STACKPTR
        ld      sp,STACKPTR
ENDIF
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

	call	crt0_init_bss

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



IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

	defm    "Small C+ TRS80"        ;Unnecessary file signature
	defb    0

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

	SECTION code_crt_init
IF (startup=2)
	ld	hl,$4800   ; Address of the Graphics map   COLOUR GENIE
ELSE
	ld	hl,$3c00   ; Address of the Graphics map
ENDIF
	ld	(base_graphics),hl



