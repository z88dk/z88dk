;       Startup for NEC PC6001 computers
;
;       Stefano Bodrato - Jan 2013
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: pc6001_crt0.asm,v 1.11 2016/07/11 21:19:38 dom Exp $
;



                MODULE  pc6001_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)



IF (startup=2)
	defc    CRT_ORG_CODE  = $8437  ; PC6001 - 32k (Answer "2" to "How many pages?")
ENDIF

IF (startup=3)
	defc    CRT_ORG_CODE  = $8037	 ; PC6001 - MK2 (Answer "2" to "How many pages?")
ENDIF

IF (startup=4)
	defc    CRT_ORG_CODE  = $4000	 ; ROM
IF !DEFINED_CRT_ORG_BSS
	defc CRT_ORG_BSS =  $c500   ; Static variables are kept in RAM
	defc DEFINED_CRT_ORG_BSS = 1
ENDIF
	defc	__crt_org_bss = CRT_ORG_BSS
	; In ROM mode we MUST setup the stack
	defc	STACKPTR = $ffff
	; If we were given a model then use it
	IF DEFINED_CRT_MODEL
		defc __crt_model = CRT_MODEL
	ELSE
		defc __crt_model = 1
	ENDIF
ENDIF

IF      !CRT_ORG_CODE
	defc    CRT_ORG_CODE  = $c437  ; PC6001 - 16K
ENDIF


; Now, getting to the real stuff now!


		org     CRT_ORG_CODE

IF (startup=4)
	defb $41
	defb $42
	defw start
ENDIF

start:
		;di

		;ld	a,$DD
		;out	($F0),a
		;out	($F1),a

		; on entry HL holds the current location
;IF (CRT_ORG_CODE=$c437)
;	; if we built a 16K program and we run in a 32k environment, then let's relocate it.
;		ld	a,$c4
;		cp	h
;		jr	z,noreloc
;		; if we're still here, then HL should be = $8437
;		ld	de,$c437
;		ld	bc,$3700	; This works for programs smaller than 14k
;		ldir
;		jp	$c437+17
;noreloc:
;ENDIF

		
        ld      (start1+1),sp   ;Save entry stack

IF      STACKPTR
        ld      sp,STACKPTR
ENDIF
;ELSE
;        ld      sp,$FFFF
;ENDIF
        ;ld      hl,-64
        ;add     hl,sp
        ;ld		sp,hl
        ;ld      sp,$F000
	
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

		
        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
;        push    hl
IF !DEFINED_nostreams
        EXTERN      closeall
        call    closeall
ENDIF
;        pop     bc
start1:
        ld      sp,0
        ;ei
        ret

l_dcal:
        jp      (hl)



	defm  "Small C+ PC6001"
	defb   0
	
        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE	"crt0_section.asm"

