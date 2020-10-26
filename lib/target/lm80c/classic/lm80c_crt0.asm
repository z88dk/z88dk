;
;	Startup for LM80-C
;

	module	lm80c_crt0 


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

	defc	CONSOLE_COLUMNS = 32
	defc	CONSOLE_ROWS = 24


        defc    TAR__no_ansifont = 1
	defc	CRT_KEY_DEL = 12
	defc	__CPU_CLOCK = 3500000

        PUBLIC  PSG_AY_REG
        PUBLIC  PSG_AY_DATA
        defc    PSG_AY_REG = @01000000
        defc    PSG_AY_DATA = @01000001

        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -1
        defc    TAR__fputc_cons_generic = 1

	defc CRT_ORG_CODE = 0x8241

        INCLUDE "crt/classic/crt_rules.inc"

   	org CRT_ORG_CODE

	; BASIC header for the LM80-C
basicstart:   
        defb 0x51, 0x82, 0xe4, 0x07, 0xab, 0x26, 0x48, 0x38
        defb 0x32, 0x35, 0x33, 0x3a, 0x80, 0x20, 0x20, 0x00
        defb 0x00, 0x00
   
start:
	ld	(start1+1),sp
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
;
;       Deallocate memory which has been allocated here!
;
        push    hl
        call    crt0_exit

        pop     bc
start1:
        ld      sp,0
	ret

l_dcal:
        jp      (hl)


	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

