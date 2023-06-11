
	SECTION	code_fp_am9511
	PUBLIC	round_fastcall
	EXTERN	_am9511_round

	defc	round_fastcall = _am9511_round


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _round_fastcall
defc _round_fastcall = _am9511_round
ENDIF

