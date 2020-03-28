; startup == 3
; msx cartridge rom

; April 2014
; submitted by Timmy

; For cartridge I am not sure what facilities are available from the MSX
; system, if any.  So this CRT only provides the bare minimum.

;
;  Declarations
;


        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -0xfc4a
        INCLUDE "crt/classic/crt_rules.inc"

;
;  Main Code Entrance Point
;
IFNDEF CRT_ORG_CODE
	defc  CRT_ORG_CODE  = $4000
ENDIF
	org   CRT_ORG_CODE

; ROM header

	defm	"AB"
	defw	start
	defw	0		;CallSTMT handler
	defw	0		;Device handler
	defw	0		;basic
	defs	6

start:
	di
	INCLUDE	"crt/classic/crt_init_sp.asm"
	ei

; port fixing; required for ROMs
; port fixing = set the memory configuration, must be first!

	in a,($A8)
	and a, $CF
	ld d,a
	in a,($A8)
	and a, $0C
	add a,a
	add a,a
	or d
	out ($A8),a

	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss

       IF DEFINED_USING_amalloc
                INCLUDE "crt/classic/crt_init_amalloc.asm"
        ENDIF

	call _main

; end program

cleanup:
endloop:
	di
	halt
	jr endloop


l_dcal:	jp	(hl)		;Used for call by function pointer


IFNDEF CRT_ORG_BSS
	defc CRT_ORG_BSS = $C000   ; Ram variables are kept in RAM in high memory
ENDIF
	defc	__crt_org_bss = CRT_ORG_BSS

        ; If we were given a model then use it
        IFDEF CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF

        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"
