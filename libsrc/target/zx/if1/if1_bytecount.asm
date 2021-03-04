;
;       ZX IF1 & Microdrive functions
;
;       Get the record counter from the FP
;       int if1_bytecount (long fp);
;
;		in:		DEHL: LONG FILE PTR
;		out:	record number
;

;
;       $Id: if1_bytecount.asm $
;


		SECTION   code_clib
		PUBLIC    if1_bytecount
		PUBLIC    _if1_bytecount


if1_bytecount:
_if1_bytecount:

; __FASTCALL__
	ld	a,1
	and	h
	ld	h,a
	ret

