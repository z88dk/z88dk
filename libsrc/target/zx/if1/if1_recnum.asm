;
;       ZX IF1 & Microdrive functions
;
;       Get the record counter from the FP
;       int if1_recnum (long fp);
;
;		in:		DEHL: LONG FILE PTR
;		out:	record number
;

;
;       $Id: if1_recnum.asm $
;


		SECTION   code_clib
		PUBLIC    if1_recnum
		PUBLIC    _if1_recnum


if1_recnum:
_if1_recnum:

; __FASTCALL__
	rr  d
	rr  e
	rr  h
	ld  l,h
	ld  h,e
	ret

