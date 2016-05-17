;       CRT0 for the VG5000
;
;       Joaopa Jun. 2014
;       Stefano Bodrato Lug. 2014
;
;       $Id: vg5k_crt0.asm,v 1.9 2016-05-17 20:14:11 dom Exp $
;


        MODULE  vg5k_crt0

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


        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

       	PUBLIC	heaplast	;Near malloc heap variables
        PUBLIC	heapblocks

        PUBLIC    __sgoioblk      ;stdio info block

        PUBLIC    base_graphics   ;Graphical variables
        PUBLIC	coords		;Current xy position

        PUBLIC	snd_tick	;Sound variable
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary

; Now, getting to the real stuff now!

        IF      !myzorg
                defc    myzorg  = 20480
        ENDIF   

        org     myzorg


start:
	xor	a
	ld	(18434), a ;default character will be normal and black

	ex		de,hl ; preserve HL
        ld      (start1+1),sp	;Save entry stack
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
		
	push    de ; save HL

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	INCLUDE "amalloc.def"
ENDIF

	call	crt0_init_bss

	di
        call    _main
	ei
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF
	pop     hl		; ..let's restore them !
	ld	ix,$47FA
start1:
        ld      sp,0
        ret


l_dcal:	jp	(hl)		;Used for function pointer calls




IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

;	defm  "Small C+ VG5000"
;	defb	0

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

	SECTION	code_crt_init
	ld	hl,$4000
	ld	(base_graphics),hl

