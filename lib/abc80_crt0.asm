;       CRT0 for the ABC80 Family
;
;       Stefano Bodrato May 2000
;
;       $Id: abc80_crt0.asm,v 1.20 2016-07-15 21:03:25 dom Exp $
;

        MODULE  abc80_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

	EXTERN    _main

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal


IF      !DEFINED_CRT_ORG_CODE
        defc    CRT_ORG_CODE  = 50000
ENDIF

	defc	TAR__clib_exit_stack_size = 32
	defc	TAR__register_sp = -1
	INCLUDE	"crt/crt_rules.inc"

        org     CRT_ORG_CODE


start:
        ld      (start1+1),sp
	INCLUDE	"crt/crt_init_sp.asm"
	INCLUDE	"crt/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp


IF DEFINED_USING_amalloc
	INCLUDE "amalloc.def"
ENDIF

        call    _main
        
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
start1:
        ld      sp,0
        ret

l_dcal:
        jp      (hl)


        defm  "Small C+ ABC80"
	defb  0
        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

