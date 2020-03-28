
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	fgetc_cons

	INCLUDE	"target/kramermc/def/kramermc.def"

getk:
_getk:
	call	$0169		;ZYKL
	ld	hl,0
	ret	z
	jp	fgetc_cons
