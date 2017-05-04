;       CRT0 for the Rabbit Control Module
;
;       If an error occurs (eg. out if screen) we just drop back to BASIC
;
; - - - - - - -
;
;       $Id: rcmx000_crt0.asm,v 1.13 2016-06-21 20:49:06 dom Exp $
;
; - - - - - - -

	; TODO_KANIN Fix this!!!

	MODULE  rcmx000_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;-------
; Simulate unsupported z80 instructions
;-------

        EXTERN     rcmx_cpd
        EXTERN     rcmx_cpdr
        EXTERN     rcmx_cpi
        EXTERN     rcmx_cpir
        EXTERN     rcmx_rld
        EXTERN     rcmx_rrd

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code

	PUBLIC	__sendchar	;  Used by stdio
	PUBLIC    __recvchar
	
        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


	org 0
start:
	; On this platform we are king of the road and may use
	; any register for any purpose Wheee!!

	include "rcmx000_boot.asm"

	call	crt0_init_bss

        call    _main	;Call user program
        
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

	pop	bc
start1:	ld	sp,0		;Restore stack to some sane value

	; Puts us back into the monitor
	call 8

l_dcal:	jp	(hl)		;Used for function pointer calls


	; Here is a great place to store temp variables and stuff!!
acme:	defw 4711 			; useless arbitrarily choosen number
	defm  "Small C+ RCM2/3000",0	;Unnecessary file signature


        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE "crt0_section.asm"

