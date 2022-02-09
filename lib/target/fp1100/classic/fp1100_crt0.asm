;	Casio FP-1100


        MODULE  fp1100_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)


;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

	defc	CRT_ORG_CODE = 0xb000

	defc	CONSOLE_ROWS = 24
	defc	CONSOLE_COLUMNS = 40
	PUBLIC	GRAPHICS_CHAR_SET
	PUBLIC	GRAPHICS_CHAR_UNSET
	defc	GRAPHICS_CHAR_SET = 0x87
	defc	GRAPHICS_CHAR_UNSET = 0x32

	defc	CRT_KEY_DEL = 8

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000 
        INCLUDE "crt/classic/crt_rules.inc"

	INCLUDE "target/fp1100/def/fp1100.def"
	
    org     CRT_ORG_CODE

    jp      start
start:
    ld      (__restore_sp_onexit+1),sp   ; Save entry stack
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
	ld	a,SUB_BEEPOFF
	call	TRNC1


        call    _main           ; Call user program
cleanup:
        push    hl				; return code

        call    crt0_exit


cleanup_exit:

        pop     bc				; return code (still not sure it is teh right one !)

__restore_sp_onexit:ld      sp,0            ;Restore stack to entry value
	ret


l_dcal: jp      (hl)            ;Used for function pointer calls



        INCLUDE "crt/classic/crt_runtime_selection.asm"

        INCLUDE "crt/classic/crt_section.asm"

	INCLUDE	"target/fp1100/classic/bootstrap.asm"
