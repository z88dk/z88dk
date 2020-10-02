
	SECTION	code_clib

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native


fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	l,a
	cp	10
	jr	nz,wait
	ld	l,13
	call	wait
	ld	l,10
wait:
	in	a,(0)
	and	128
	jr	nz,wait
	ld	a,l
	out	(1),a
	ret
