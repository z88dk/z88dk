;       CRT0 for the ABC80 Family
;
;       Stefano Bodrato May 2000
;
;       $Id: abc80_crt0.asm,v 1.16 2016-06-02 22:24:57 dom Exp $
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


IF      !myzorg
        defc    myzorg  = 50000
ENDIF
        org     myzorg


start:
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

	call	crt0_init_bss

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
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

IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

        defm  "Small C+ ABC80"
	defb  0
        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

