;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;		WARNING:
;		This function does not work under PCW or +3 CP/M (and probably not CPC CP/M either),
;		because the values in B and C are always reset to zero before they are examined.
;		To correct this bug, replace the byte sequence 3D 28 F0 3C 28 E6 with 00 00 00 00 00 00.
;		In a running system this is in bank 0, two bytes after the address in 00CCh.
; 
;
;       $Id: a_ink.asm,v 1.3 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_ink
   PUBLIC   _a_ink
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_ink:
_a_ink:
	ld a,1
	ld b,l
	ld c,l
	
	call subuserf
	defw TE_SET_INK
	ret

