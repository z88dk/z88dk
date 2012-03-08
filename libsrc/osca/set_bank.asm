;
;	Get the OSCA Architecture current bank
;	by Stefano Bodrato, 2011
;
;	void set_bank(int bank);
;
;	Sets which of the 32KB banks is mapped into address space $8000-$ffff
;	bank = required bank (range: 0 - max_bank)
;
;	$Id: set_bank.asm,v 1.3 2012-03-08 07:16:46 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  set_bank
	
set_bank:
	; __FASTCALL__
	ld a,l
	jp kjt_forcebank

