;
;	Get the OSCA Architecture current bank
;	by Stefano Bodrato, 2011
;
;	void set_bank(int bank);
;
;	Sets which of the 32KB banks is mapped into address space $8000-$ffff
;	bank = required bank (range: 0 - max_bank)
;
;	$Id: set_bank.asm,v 1.5 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  set_bank
	PUBLIC  _set_bank
	
set_bank:
_set_bank:
	; __FASTCALL__
	ld a,l
	jp kjt_forcebank

