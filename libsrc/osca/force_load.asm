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
;	$Id: force_load.asm,v 1.1 2012-03-05 20:40:15 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  force_load
	LIB   flos_err
	
force_load:
	pop de
	pop bc	; bank
	pop hl	; data position
	push hl
	push bc
	push de
	ld	b,c

	call	kjt_force_load
	jp		flos_err
