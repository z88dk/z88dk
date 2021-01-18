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

	INCLUDE	"target/svi/def/svibios.def"

;--------
; Some scope definitions
;--------

	EXTERN    _main
        EXTERN    msxbios

	PUBLIC    cleanup
	PUBLIC    l_dcal


	defc	CONSOLE_COLUMNS = 32
	defc	CONSOLE_ROWS = 24

	defc	__CPU_CLOCK = 3580000

IF startup = 3
	; ROM
	INCLUDE	"target/svi/classic/rom.asm"
ELSE
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1

; Now, getting to the real stuff now!

IF startup = 2
	defc	CRT_ORG_CODE = $8000
ENDIF

IFNDEF CRT_ORG_CODE
		defc CRT_ORG_CODE  = 34816
ENDIF
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

IF startup != 2
	call	$53		; Hide function key menu
ELSE
	im	1
	ei
ENDIF
        call    _main
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;
    call    crt0_exit


start1:
IF startup = 2
	jr	start1
ELSE
        ld      sp,0

	ld	ix,KILBUF	;Clear keyboard buffer
	call	msxbios

	ld	ix,$3768	; TOTEXT - force text mode on exit
	call	msxbios
        ret
ENDIF

l_dcal:
        jp      (hl)

ENDIF

	; All startup modes follow on here

        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE	"crt/classic/crt_section.asm"

IF startup = 2
        INCLUDE "target/svi/classic/bootstrap.asm"
ENDIF
