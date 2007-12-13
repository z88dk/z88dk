;
;       Startup for CP/M
;
;       Stefano Bodrato - Apr. 2000
;                         Apr. 2001: Added MS-DOS protection
;
;	Dominic Morris  - Jan. 2001: Added argc/argv support
;			- Jan. 2001: Added in malloc routines
;			- Jan. 2001: File support added
;
;       $Id: cpm_crt0.asm,v 1.9 2007-12-13 11:28:42 stefano Exp $
;
; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma no-streams - No stdio disc files
;	#pragma no-fileio  - No fileio at all
;	#pragma no-protectmsdos - strip the MS-DOS protection header
;
;	These can cut down the size of the resultant executable

	MODULE  cpm_crt0

;-------------------------------------------------
; Include zcc_opt.def to find out some information
;-------------------------------------------------

	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	XREF    _main		;main() is always external to crt0

	XDEF    cleanup		;jp'd to by exit()
	XDEF    l_dcal		;jp(hl)

	XDEF    _std_seed	;Integer rand() seed

	XDEF	_vfprintf	;jp to printf core routine

	XDEF    exitsp		;atexit() variables
	XDEF    exitcount

        XDEF    heaplast        ;Near malloc heap variables
        XDEF    heapblocks      ;

	XDEF    __sgoioblk	;std* control block

	XDEF	__fcb		;file control block


        org     $100

;----------------------
; Execution starts here
;----------------------
.start
IF !DEFINED_noprotectmsdos
	defb	$eb,$04		;DOS protection... JMPS LABE
	ex	de,hl
	jp	begin
	defb	$b4,$09		;DOS protection... MOV AH,9
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

.dosmessage
	defm	"This program is for a CP/M system."
	defb	13,10,'$'

.begin
ENDIF
	ld      (start1+1),sp	;Save entry stack
	ld	a,($80)		;byte count of length of args
	inc	a		;we can use this since args are space separated
	neg
	ld	l,a
	ld	h,-1		;negative number
        ld      de,-64		;Add on space for atexit() stack
	add	hl,de
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

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
	ld	c,25		;Set the default disc
	call	5
	ld	(defltdsk),a

; Push pointers to argv[n] onto the stack now
; We must start from the end 
	ld	hl,0	;NULL pointer at end, just in case
	push	hl
	ld	hl,$80
	ld	a,(hl)
	ld	b,0
	and	a
	jr	z,argv_done
	ld	c,a
	add	hl,bc	;now points to the end
; Try to find the end of the arguments
.argv_loop_1
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop_2
	ld	(hl),0
	dec	hl
	dec	c
	jr	nz,argv_loop_1
; We've located the end of the last argument, try to find the start
.argv_loop_2
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop_3
	ld	(hl),0
	inc	hl
	push	hl
	inc	b
	dec	hl
.argv_loop_3
	dec	hl
	dec	c
	jr	nz,argv_loop_2

.argv_done
	ld	hl,end	;name of program (NULL)
	push	hl
	inc	b
	ld	hl,0
	add	hl,sp	;address of argv
	ld	c,b
	ld	b,0
	push	bc	;argc
	push	hl	;argv
        call    _main		;Call user code
	pop	bc	;kill argv
	pop	bc	;kill argc

	ld	a,(defltdsk)	;Restore default disc
	ld	e,a
	ld	c,14
	call	5

.cleanup
	push	hl		;Save return value
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall	;Close any opened files
	call	closeall
ENDIF
ENDIF
	pop	bc		;Get exit() value into bc
.start1	ld      sp,0		;Pick up entry sp
        jp	0

.l_dcal	jp	(hl)		;Used for call by function ptr

;------------------------
; The stdio control block
;------------------------
.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10	;Dummy values (unused by CPM port?)
ENDIF


;----------------------------------------
; Work out which vfprintf routine we need
;----------------------------------------
._vfprintf
IF DEFINED_floatstdio
	LIB	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		LIB	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			LIB	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF


;-----------------------
; Some startup variables
;-----------------------

.defltdsk       defb    0	;Default disc
._std_seed       defw    0	;Integer seed
.exitsp		defw	0	;Address of atexit() stack
.exitcount	defb	0	;Number of atexit() routinens
.heaplast	defw	0	;Pointer to last free heap block
.heapblocks	defw	0	;Number of heap blocks available
IF !DEFINED_nofileio
.__fcb		defs	420,0	;file control block (10 files) (MAXFILE)
ENDIF

;----------------------------
; Unneccessary file signature
;----------------------------
         	defm  	"Small C+ CP/M"
.end		defb	0

;----------------------------------------------
; Floating point support routines and variables
;----------------------------------------------
IF NEED_floatpack
        INCLUDE         "#float.asm"

.fp_seed        defb    $80,$80,0,0,0,0	; FP seed (unused ATM)
.extra          defs    6		; FP spare register
.fa             defs    6		; FP accumulator
.fasign         defb    0		; FP variable

ENDIF
