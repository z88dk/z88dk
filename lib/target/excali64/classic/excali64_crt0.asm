;       Startup for Excalibur 64
;
;       Stefano Bodrato - 2019
;
;       $Id: excali64_crt0.asm $
;
;
;
;	To run at position $6000:
;
;	POKE -957,96
;	POKE -958,0
;	PRINT USR(0)
;

;	To change loading speed (CLOADM, ecc..):  01 = 1200 baud 02 = 600 baud  04 = 300 baud
;	POKE -1053,n



                MODULE  excali64_crt0

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


        IF      !DEFINED_CRT_ORG_CODE
			defc    CRT_ORG_CODE  = $4100	; BASIC startup mode
		ENDIF

; Now, getting to the real stuff now!

        defc    CONSOLE_ROWS = 24
        defc    CONSOLE_COLUMNS = 80
		
	defc	TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 32
        ;defc    TAR__register_sp = $5fff
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"


	org     CRT_ORG_CODE
	

start:

    ld	(__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld	(exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


        call    _main
cleanup:
        push    hl
        call    crt0_exit

        pop     hl
__restore_sp_onexit:
        ld      sp,0
		
		jp		$1904		; pass HL as a result to the USR(n) BASIC function
        ;ret

l_dcal:
        jp      (hl)



        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE "crt/classic/crt_section.asm"


	SECTION	code_crt_init

