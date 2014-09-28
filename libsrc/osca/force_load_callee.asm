;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	 int force_load(int address, int bank);
;
; forces a file to be loaded to a particular address - kjt_find_file MUST be called first!
;
; Input Registers :
;
; HL = Load address.
; B = Bank of load address.
;
; Output Registers :  FLOS style error handling
;
;
;	$Id: force_load_callee.asm,v 1.2 2014-09-28 18:26:58 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	XLIB  force_load_callee
	LIB   flos_err
	XDEF  ASMDISP_FORCE_LOAD_CALLEE
	
force_load_callee:
	pop de
	pop bc	; bank
	pop hl	; data position
	push de

asmentry:
	ld	b,c

	call	kjt_force_load
	jp		flos_err

DEFC ASMDISP_FORCE_LOAD_CALLEE = # asmentry - force_load_callee
