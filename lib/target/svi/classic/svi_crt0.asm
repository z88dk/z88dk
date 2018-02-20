;       Spectravideo SVI CRT0 stub
;
;       Stefano Bodrato - Apr. 2001
;
;       $Id: svi_crt0.asm,v 1.20 2016-06-21 20:49:07 dom Exp $
;


	MODULE  svi_crt0

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

	PUBLIC    msxbios



; Now, getting to the real stuff now!


IFNDEF CRT_ORG_CODE
		defc CRT_ORG_CODE  = 34816
ENDIF

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 3580000
        INCLUDE "crt/classic/crt_rules.inc"
	org CRT_ORG_CODE

start:
        ld      (start1+1),sp
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

	call	$53		; Hide function key menu
        call    _main
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

start1:
        ld      sp,0

	ld	ix,$3768	; TOTEXT - force text mode on exit
	call	msxbios
        ret

l_dcal:
        jp      (hl)

; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
msxbios:
	push	ix
	ret

; Signature in resulting binary

	defm	"Small C+ SVI"
	defb	0


        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE	"crt/classic/crt_section.asm"


