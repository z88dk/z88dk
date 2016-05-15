;       CRT0 for the NASCOM1/2
;
;       Stefano Bodrato May 2003
;
;
; - - - - - - -
;
;       $Id: nascom_crt0.asm,v 1.17 2016-05-15 20:15:44 dom Exp $
;
; - - - - - - -


	MODULE  nascom_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

	EXTERN    _main           ;main() is always external to crt0 code

	PUBLIC    cleanup         ;jp'd to by exit()
	PUBLIC    l_dcal          ;jp(hl)


	PUBLIC    exitsp          ;atexit() variables
	PUBLIC    exitcount

	PUBLIC    __sgoioblk      ;stdio info block

	PUBLIC	heaplast	;Near malloc heap variables
	PUBLIC	heapblocks

	PUBLIC    base_graphics   ;Graphical variables (useless with NASCOM)
	PUBLIC    coords          ;Current xy position

	PUBLIC    montest         ;NASCOM: check the monitor type


	;org	0C80h
	org	1000h
	;org	0E000h
	
; NASSYS1..NASSYS3
;  IF (startup=1) | (startup=2) | (startup=3)
;
;
;  ENDIF

start:

	ld	(start1+1),sp	;Save entry stack

	; search for the top of writeble memory and set the stack pointer
	ld	hl,0ffffh
	ld	a,55
stackloop:
	ld	(hl),a
	cp	(hl)
	dec	hl
	jr	nz,stackloop
	ld	hl,0xe000
	ld      sp,hl
	ld      (exitsp),sp

        call    crt_init_start  ;Initialise any data setup by sdcc

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


	call    _main	;Call user program

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

	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	rst	18h
	defb	5bh
	;ret

l_dcal:	jp	(hl)		;Used for function pointer calls
        jp      (hl)


;------------------------------------
; Check which monitor we have in ROM
;------------------------------------

montest: ld	a,(1)	; "T" monitor or NAS-SYS?
         cp	33h	; 31 00 10     / 31 33 0C
         ret


         defm  "Small C+ NASCOM"	;Unnecessary file signature
         defb	0

        INCLUDE "crt0_runtime_selection.asm"

    SECTION code_crt_init
crt_init_start:
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
ENDIF
	xor	a
	ld	(exitcount),a
    ;; Code gets placed in this section
    SECTION code_crt_exit
    	ret

    SECTION code_compiler
    SECTION code_clib
    SECTION code_crt0_sccz80
    SECTION code_l_sdcc
    SECTION code_math
    SECTION code_error
    SECTION data_compiler
    SECTION data_clib
    SECTION rodata_compiler
    SECTION rodata_clib
    SECTION smc_clib
    SECTION bss_crt


;-----------
; Define the file table
;-----------
__sgoioblk:
	INCLUDE	"stdio_fp.asm"


;-----------
; Now some variables
;-----------
coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    0       ; Address of the Graphics map


exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF


;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "float.asm"
fp_seed:        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
extra:          defs    6               ;FP register
fa:             defs    6               ;FP Accumulator
fasign:         defb    0               ;FP register
ENDIF

    SECTION bss_error
    SECTION bss_compiler
    SECTION bss_clib

