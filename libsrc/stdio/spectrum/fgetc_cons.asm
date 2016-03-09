;
;	Devilishly simple Spectrum Routines
;
;	getkey() Wait for keypress
;
;	17/5/99 djm
;
;	22/3/2000 djm Rechristened getchar
;	1/4/2000  djm Rechristened fgetc_cons
;
;
;	$Id: fgetc_cons.asm,v 1.5 2016-03-09 22:25:54 dom Exp $
;


		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	xor	a
	ld	(23560),a
.getkey1
	ld	a,(23560)
	and	a
	jr	z,getkey1
	ld	l,a
	ld	h,0
	ret
