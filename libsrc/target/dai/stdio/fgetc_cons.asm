

	SECTION	code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	INCLUDE	"target/dai/def/dai.def"

.fgetc_cons
._fgetc_cons
	call	dai_GETK
	and	a
	jp	z,fgetc_cons
	cp	13
	jp	nz,not_lf
	ld	a,10
not_lf:
	ld	l,a
	ld	h,0
	ret
