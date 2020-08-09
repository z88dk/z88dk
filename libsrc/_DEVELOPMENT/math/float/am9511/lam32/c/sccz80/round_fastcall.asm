
	SECTION	code_fp_am9511
	PUBLIC	round_fastcall
	EXTERN	_am9511_roundf

	defc	round_fastcall = _am9511_roundf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _round_fastcall
defc _round_fastcall = _am9511_roundf
ENDIF

