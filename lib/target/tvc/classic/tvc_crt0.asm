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

        PUBLIC    __Exit
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
    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
	
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"

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


        INCLUDE "crt/classic/crt_runtime_selection.inc"

		INCLUDE	"crt/classic/crt_section.inc"
