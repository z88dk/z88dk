;       Startup Code for Embedded Targets
;
;	Daniel Wallner March 2002
;
;	$Id: embedded_crt0.asm,v 1.10 2016-04-03 13:42:45 dom Exp $
;
; (DM) Could this do with a cleanup to ensure rstXX functions are
; available?

	DEFC	ROM_Start  = $0000
	DEFC	RAM_Start  = $8000
	DEFC	RAM_Length = $100
	DEFC	Stack_Top  = $ffff

	MODULE  embedded_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code
        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        PUBLIC    exitsp          ;Pointer to atexit() stack
        PUBLIC    exitcount       ;Number of atexit() functions registered

        PUBLIC    __sgoioblk      ;std* control block

        PUBLIC    heaplast        ;Near malloc heap variables
        PUBLIC    heapblocks      ;



	org    ROM_Start

	jp	start
start:
; Make room for the atexit() stack
	ld	hl,Stack_Top-64
	ld	sp,hl
; Clear static memory
	ld	hl,RAM_Start
	ld	de,RAM_Start+1
	ld	bc,RAM_Length-1
	ld	(hl),0
	ldir
	ld      (exitsp),sp
	call	crt0_init_data

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF

endloop:
	jr	endloop
l_dcal:
	jp      (hl)

;---------------------------------
; Select which printf core we want
;---------------------------------
	PUBLIC	asm_vfprintf
IF DEFINED_floatstdio
	EXTERN	asm_vfprintf_level3
	defc	asm_vfprintf = asm_vfprintf_level3
ELSE
	IF DEFINED_complexstdio
	        EXTERN	asm_vfprintf_level2
		defc	asm_vfprintf = asm_vfprintf_level2
	ELSE
	       	EXTERN	asm_vfprintf_level1
		defc	asm_vfprintf = asm_vfprintf_level1
	ENDIF
ENDIF

;--------
; Now, include the math routines if needed..
;--------
IF NEED_floatpack
        INCLUDE "float.asm"
ENDIF

SECTION code_crt_init
crt0_init_data:
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
ENDIF
        ld      hl,$8080
        ld      (fp_seed),hl
        xor     a
        ld      (exitcount),a
SECTION code_crt_exit
        ret
SECTION code_compiler
SECTION code_clib
SECTION code_crt0_sccz80
SECTION code_l_sdcc
SECTION code_error
SECTION data_compiler
SECTION rodata_compiler
SECTION rodata_clib

SECTION bss_crt
	org	RAM_Start
__sgoioblk:             defs    40      ;stdio control block
exitsp:                 defw    0       ;atexit() stack
exitcount:              defb    0       ;Number of atexit() routines
fp_seed:                defs    6       ;Floating point seed (not used ATM)
extra:                  defs    6       ;Floating point spare register
fa:                     defs    6       ;Floating point accumulator
fasign:                 defb    0       ;Floating point variable
heapblocks:             defw    0       ;Number of free blocks
heaplast:               defw    0       ;Pointer to linked blocks
SECTION bss_clib
SECTION bss_compiler
SECTION bss_error


