

	SECTION	code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	INCLUDe	"target/dai/def/dai.def"

.fgetc_cons
._fgetc_cons
	call	dai_GETK
	and	a
	jp	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
