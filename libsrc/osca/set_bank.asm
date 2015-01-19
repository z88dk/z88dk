;
;	Get the OSCA Architecture current bank
;	by Stefano Bodrato, 2011
;
;	void set_bank(int bank);
;
;	Sets which of the 32KB banks is mapped into address space $8000-$ffff
;	bank = required bank (range: 0 - max_bank)
;
;	$Id: set_bank.asm,v 1.4 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  set_bank
	
set_bank:
	; __FASTCALL__
	ld a,l
	jp kjt_forcebank

