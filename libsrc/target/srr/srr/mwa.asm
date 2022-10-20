;
;==============================================================
;
; int mwa();
;
;   Returns the Monitor Work Area address.
;
SECTION code_clib

PUBLIC mwa
PUBLIC _mwa

mwa:
_mwa:
	call	0e1a2h		; Make IY point to work area (close to RAMPTOP)
	PUSH IY
	POP	HL
	ret

