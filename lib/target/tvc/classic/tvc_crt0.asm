;
;       Videoton TV Computer C stub
;       Sandor Vass - 2019
;
;       Based on the source of
;       Enterprise 64/128 C stub
;       Stefano Bodrato - 2011
;


; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma no-streams      - No stdio disc files
;	#pragma no-fileio       - No fileio at all
;
;	These can cut down the size of the resultant executable

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
        defc    TAR__register_sp = 0x7f00
		defc __CPU_CLOCK = 3125000
        INCLUDE "crt/classic/crt_rules.inc"

; This is a required value in order to be able to generate .cas file
IF      !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = 1a03h
ENDIF
		org     CRT_ORG_CODE


;----------------------
; Execution starts here
;----------------------
start:

        ;di
        push ix
        push iy
        exx
        push bc
        push hl
        exx
        
        ld      (start1+1),sp
		INCLUDE "crt/classic/crt_init_sp.asm"

		INCLUDE	"crt/classic/crt_init_atexit.asm"
		call	crt0_init_bss
        ld      (exitsp),sp

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

IF CRT_ENABLE_STDIO = 1
	EXTERN	closeall
	call	closeall
ENDIF


start1:
        ld      sp,0
        exx
        pop hl
        pop bc
        exx        
        pop iy
        pop ix
        ret


l_dcal:
        jp      (hl)


end:	defb	0


        INCLUDE "crt/classic/crt_runtime_selection.asm"

		INCLUDE	"crt/classic/crt_section.asm"


