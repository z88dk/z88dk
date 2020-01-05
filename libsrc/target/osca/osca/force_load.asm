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
;	$Id: force_load.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

        SECTION code_clib
	PUBLIC  force_load
	PUBLIC  _force_load
	EXTERN  force_load_callee
	EXTERN ASMDISP_FORCE_LOAD_CALLEE

force_load:
_force_load:
	pop de
	pop bc	; bank
	pop hl	; data position
	push hl
	push bc
	push de

   jp force_load_callee + ASMDISP_FORCE_LOAD_CALLEE
