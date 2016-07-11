;	Stub for the TI 82 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti82_crt0.asm,v 1.31 2016-07-11 05:58:34 stefano Exp $
;
;-----------------------------------------------------
; Some general PUBLICs and EXTERNs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti82_crt0

	EXTERN	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	PUBLIC	cleanup		; used by exit()
	PUBLIC	l_dcal		; used by calculated calls  = "call (hl)"


	PUBLIC	cpygraph	; TI calc specific stuff
	PUBLIC	tidi		;
	PUBLIC	tiei		;

;-------------------------
; Begin of (shell) headers
;-------------------------

        defc    crt0 = 1
	INCLUDE "Ti82.def"	; ROM / RAM adresses on Ti82
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines
	
;OS82Head:
;    defb     $FE,$82,$0F
;
;AshHead:
;    defb     $D9,$00,$20
;
;CrASHhead:
;    defb     $D5,$00,$11


;-------------------
;1 - CrASH (default)
;-------------------
	org	START_ADDR-3
	DEFB $D5,$00,$11
;	org	START_ADDR
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
ENDIF
	defb	$0		; Termination zero

;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
start:
	ld	hl,0
	add	hl,sp
	ld	(start1+1),hl
IF !DEFINED_atexit		; Less stack use
	ld	hl,-6		; 3 pointers (more likely value)
	add	hl,sp
	ld	sp,hl
        call    crt0_init_bss
	ld	(exitsp),sp
ELSE
	ld	hl,-64		; 32 pointers (ANSI standard)
	add	hl,sp
	ld	sp,hl
        call    crt0_init_bss
	ld	(exitsp),sp
ENDIF

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


	EXTERN	fputc_cons
	ld	hl,12
	push	hl
	call	fputc_cons
	pop	hl


IF DEFINED_GRAYlib
	INCLUDE	"gray82.asm"
ELSE
	INCLUDE "intwrap82.asm"
ENDIF

	im	2
	call	_main
cleanup:			; exit() jumps to this point
start1:	ld	sp,0		; writeback
	ld	iy,_IY_TABLE	; Restore flag-pointer
	im	1
tiei:	ei
IF DEFINED_GRAYlib
cpygraph:			; little opt :)
ENDIF
tidi:	ret

;----------------------------------------
; End of startup part, routines following
;----------------------------------------
l_dcal:
	jp	(hl)


IF !DEFINED_GRAYlib
	defc cpygraph = CR_GRBCopy	; CrASH FastCopy
ENDIF

		defc ansipixels = 96
		IF !DEFINED_ansicolumns
			 defc DEFINED_ansicolumns = 1
			 defc ansicolumns = 32
		ENDIF
		
        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

	SECTION	code_crt_init
	ld	hl,GRAPH_MEM
	ld	(base_graphics),hl

