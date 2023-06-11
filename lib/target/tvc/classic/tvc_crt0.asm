;
;       Videoton TV Computer C stub
;       Sandor Vass - 2019
;
;       Based on the source of
;       Enterprise 64/128 C stub
;       Stefano Bodrato - 2011
;

;       Currently this crt supports only max 26kB of cas file, so even
;       the 32k TVC version is supported.

        MODULE  tvc_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

	    defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal




; tvc specific stuff
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp          = -1
        defc    __CPU_CLOCK               = 3125000
        INCLUDE "crt/classic/crt_rules.inc"

; This is a required value in order to be able to generate .cas file
IF !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = 1a03h
ENDIF
		org     CRT_ORG_CODE


;----------------------
; Execution starts here
;----------------------
start:
        push ix
        push iy
        exx
        push bc
        push hl
        exx
        
        ld      (__restore_sp_onexit+1),sp
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

        call    _main
	
cleanup:
    call    crt0_exit



__restore_sp_onexit:
        ld      sp,0
        exx
        pop     hl
        pop     bc
        exx        
        pop     iy
        pop     ix
        ret


l_dcal:
        jp      (hl)


end:    defb	0


        INCLUDE "crt/classic/crt_runtime_selection.asm"

		INCLUDE	"crt/classic/crt_section.asm"
