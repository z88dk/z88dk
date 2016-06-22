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
;	$Id: force_load_callee.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  force_load_callee
	PUBLIC  _force_load_callee
	EXTERN   flos_err
	PUBLIC  ASMDISP_FORCE_LOAD_CALLEE
	
force_load_callee:
_force_load_callee:
	pop de
	pop bc	; bank
	pop hl	; data position
	push de

asmentry:
	ld	b,c

	call	kjt_force_load
	jp		flos_err

DEFC ASMDISP_FORCE_LOAD_CALLEE = # asmentry - force_load_callee
