;       
;       Small C+ Compiler
;
;       The Maths Routines (essential ones!)
;
;	All maths routines are now in a library except for these
;	small ones (which will always be used)
;
;	If -doublestr is defined then we can link with whatever
;	library we feel like
;
;       djm 7/12/98
;
;	$Id: float.asm,v 1.8 2002-08-20 13:58:08 dom Exp $

;-------------------------------------------------
; Some scope defintionons for the crt0 float stuff
;-------------------------------------------------

        XDEF    fp_seed
        XDEF    extra
        XDEF    fa
        XDEF    fasign
        XDEF    dstore
        XDEF    dload
        XDEF    dldpsh
        XDEF    dpush
        XDEF    dpush2
	XDEF	__atof2

	LIB	atof	;needed for __atof2

;-------------------------------------------
; Unused code from the generic z80 maths lib
;-------------------------------------------

;
;DIVZERO CALL   GRIPE
;        DEFB    'can''t /0',0
;OFLOW  CALL    GRIPE
;        DEFB    'Arithmetic overflow',0
;GRIPE  CALL    QERR    ;top word on stack points to message
;        JP      0       ;error was fatal
;
;       FA = (hl)
;


;--------------
; Copy FA to de
;--------------
.dstore ld      de,fa
        ld      bc,6
        ex      de,hl
        ldir
        ex      de,hl
        ret


;----------------
; Load FA from hl
;----------------
.dload	ld	de,fa
        ld      bc,6
        ldir
        ret

;-----------------------------------------
; Load FA from (hl) and push FA onto stack
;-----------------------------------------
.dldpsh	ld      de,fa
        ld      bc,6
        ldir
;------------------------------------------
; Push FA onto stack (under return address)
;------------------------------------------
.dpush	pop	de
        ld      hl,(fa+4)
        push    hl
        ld      hl,(fa+2)
        push    hl
        ld      hl,(fa)
        push    hl
        ex      de,hl
        jp      (hl)

;------------------------------------------------------
; Push FA onto stack under ret address and stacked word
;------------------------------------------------------
.dpush2 pop     de      ;save return address
        pop     bc      ;save next word
        ld      hl,(fa+4)
        push    hl
        ld      hl,(fa+2)
        push    hl
        ld      hl,(fa)
        push    hl
        ex      de,hL
        push    bc      ;restore next word
        jp      (hl)    ;return

IF DEFINED_math_atof
;---------------------------------------------------------
; Convert string to FP number in FA calls the library atof
;---------------------------------------------------------
.__atof2
	push	hl
	call	atof
	pop	bc
	ret
ENDIF

