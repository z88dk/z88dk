;       CRT0 for the VG5000
;
;       Joaopa Jun. 2014
;       Stefano Bodrato Lug. 2014
;
;       $Id: vg5k_crt0.asm,v 1.15 2016-07-15 21:03:25 dom Exp $
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


; Now, getting to the real stuff now!

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 18953
        ENDIF   

        defc    CONSOLE_COLUMNS = 40
        defc    CONSOLE_ROWS = 25

        defc    TAR__fputc_cons_generic = 1
	defc	TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE


start:
	xor	a
	ld	(18434), a ;default character will be normal and black

	push    hl ; save HL
        ld      (start1+1),sp	;Save entry stack
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
        call    crt0_init_bss
        ld      (exitsp),sp
		

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


	di
        call    _main
	ld	iy,$47FA
	ei
cleanup:
    call    crt0_exit

start1:
        ld      sp,0
	pop     hl		; ..let's restore them !
	ld	iy,$47FA
        ret


l_dcal:	jp	(hl)		;Used for function pointer calls





        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	code_crt_init
	ld	hl,$4000
	ld	(base_graphics),hl

