;       Kludgey startup for Spectra
;
;       djm 18/5/99
;
;       $Id: spec_crt0.asm,v 1.9 2003-03-23 10:28:19 dom Exp $
;



                MODULE  zx82_crt0
;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        XREF    _main           ;main() is always external to crt0 code

        XDEF    cleanup         ;jp'd to by exit()
        XDEF    l_dcal          ;jp(hl)

        XDEF    int_seed        ;Integer rand() seed

        XDEF    _vfprintf       ;jp to the printf() core

        XDEF    exitsp          ;atexit() variables
        XDEF    exitcount

       	XDEF	heaplast	;Near malloc heap variables
	XDEF	heapblocks

        XDEF    __sgoioblk      ;stdio info block

        XDEF    base_graphics   ;Graphical variables
	XDEF	coords		;Current xy position

	XDEF	snd_tick	;Sound variable

;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

        IF DEFINED_ZXVGS
        IF !myzorg
                DEFC    myzorg = $5CCB  ;repleaces BASIC program
        ENDIF
        IF !STACKPTR
                DEFC    STACKPTR = $FF57  ;below UDG, keep eye when using banks
        ENDIF
        ENDIF

        
        IF      !myzorg
                defc    myzorg  = 32768
        ENDIF
                org     myzorg


.start
IF !DEFINED_ZXVGS
        ld      (start1+1),sp	;Save entry stack
ENDIF
IF 	STACKPTR
	ld	sp,STACKPTR
ENDIF
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
IF DEFINED_ZXVGS
;setting variables needed for proper keyboard reading
        LD      (IY+1),$CD      ;FLAGS #5C3B
        LD      (IY+48),1       ;FLAGS2 #5C6A
        EI                      ;ZXVGS starts with disabled interrupts
ENDIF
	ld	a,2		;open the upper display (uneeded?)
	call	5633
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
        call    _main		;Call user program
.cleanup
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF
IF DEFINED_ZXVGS
        POP     BC              ;let's say exit code goes to BC
        RST     8
        DEFB    $FD             ;Program finished
ELSE
        ld      hl,10072        ;Restore hl' to what basic wants
        exx
        pop     bc
.start1 ld      sp,0            ;Restore stack to entry value
        ret
ENDIF

.l_dcal	jp	(hl)		;Used for function pointer calls


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF



;---------------------------------
; Select which printf core we want
;---------------------------------
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

;---------------------------------------------
; Some +3 stuff - this needs to be below 49152
;---------------------------------------------
IF DEFINED_NEEDplus3dodos
; 	Routine to call +3DOS Routines. Located in startup
;	code to ensure we don't get paged out
;	(These routines have to be below 49152)
;	djm 17/3/2000 (after the manual!)
	XDEF	dodos
.dodos
	call	dodos2		;dummy routine to restore iy afterwards
	ld	iy,23610
	ret
.dodos2
	push	af
	push	bc
	ld	a,7
	ld	bc,32765
	di
	ld	(23388),a
	out	(c),a
	ei
	pop	bc
	pop	af
	call	cjumpiy
	push	af
	push	bc
	ld	a,16
	ld	bc,32765
	di
	ld	(23388),a
	out	(c),a
	ei
	pop	bc
	pop	af
	ret
.cjumpiy
	jp	(iy)
ENDIF

IF 0
;	Short routine to set up a +3 DOS header so files
;	Can be accessed from BASIC, we set to type code
;	load address 0 and length supplied
;
;	Entry:	b = file handle
;	       hl = file length

.setheader
	ld	iy,setheader_r
	call	dodos
	ret
.setheader_r
	push	hl
	call	271	;DOS_RED_HEAD
	pop	hl
	ld	(ix+0),3	;CODE
	ld	(ix+1),l	;Length
	ld	(ix+2),h
	ld	(ix+3),0	;Load address
	ld	(ix+4),0
	ret
ENDIF


;-----------
; Now some variables
;-----------
.coords         defw    0       ; Current graphics xy coordinates
.base_graphics  defw    0       ; Address of the Graphics map

.int_seed       defw    0       ; Seed for integer rand() routines

.exitsp         defw    0       ; Address of where the atexit() stack is
.exitcount      defb    0       ; How many routines on the atexit() stack


.heaplast       defw    0       ; Address of last block on heap
.heapblocks     defw    0       ; Number of blocks

IF DEFINED_NEED1bitsound
.snd_tick	defb	0	; Sound variable
ENDIF

		defm	"Small C+ ZX"&0	;Unnecessary file signature

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "#float.asm"
.fp_seed        defb    $80,$80,0,0,0,0	;FP seed (unused ATM)
.extra          defs    6		;FP register
.fa             defs    6		;FP Accumulator
.fasign         defb    0		;FP register

ENDIF

