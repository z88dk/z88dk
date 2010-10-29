
;
; QSORT - compiled, then hand-adjusted
; Stefano, 29/10/2010
;
; $Id: qsort.asm,v 1.1 2010-10-29 10:20:17 stefano Exp $
;
; Original code taken from the BDS C by Leor Zolman
;
;void qsort(char *base, unsigned int nel, unsigned int width, void *compar)
;{	int i, j;
;	unsigned gap, ngap, t1;
;	int jd, t2;
;
;	t1 = nel * width;
;	for (ngap = nel / 2; ngap > 0; ngap /= 2) {
;	   gap = ngap * width;
;	   t2 = gap + width;
;	   jd = (unsigned int) base + gap;
;	   for (i = t2; i <= t1; i += width)
;	      for (j =  i - t2; j >= 0; j -= gap) {
;		if ((*compar)(base+j, jd+j) <=0) break;
;			 memswap(base+j, jd+j, width);
;	      }
;	}
;}



XLIB qsort

LIB	l_mult
LIB l_le
LIB memswap_callee


._i	defs	2
._j	defs	2
._t1	defs	2
._t2	defs	2
._jd	defs	2
._width	defs	2
._base	defs	2
._ngap	defs	2
._gap	defs	2


.qsort
	pop	af
	pop	ix	; *compar
	pop	hl	; width
	ld	(_width),hl
	pop de	; nel
	ld	(_ngap),de	; nel's copy in ngap will be immediately divided by 2.
	pop bc	; base
	ld	(_base),bc
	
	; __CALLEE__
	;push bc
	;push de
	;push hl
	;push ix
	push af

	; t1 = nel * width;
	call	l_mult
	ld	(_t1),hl

	; for (ngap = nel / 2; ngap > 0; ngap /= 2) {
.i_3

	ld	hl,(_ngap)
	srl h			; _ngap/2 ..bit rotation
	rr  l
	ld	(_ngap),hl
	ld	a,h
	or	l

	ret z
	
	; gap = ngap * width;
	ld d,h
	ld e,l
	ld	hl,(_width)
	call	l_mult
	ld	(_gap),hl
	; t2 = gap + width;
	push hl
	ex	de,hl
	ld	hl,(_width)
	add	hl,de
	ld	(_t2),hl
	; jd = (unsigned int) base + gap;
	ld	de,(_base)
	ex	(sp),hl		; retrieve 'gap'
	add	hl,de
	ld	(_jd),hl
	pop hl			; t2
	jr	i_8
	
.i_6
	ld	de,(_i)
	ld	hl,(_width)
	add	hl,de
	;ld	(_i),hl

	; for (i = t2 ....
.i_8
	ld	(_i),hl
	ld	de,(_t1)
	ex	de,hl
	call	l_le
	jr	nc,i_3

	; for (j =  i - t2..
	ld	de,(_i)
	ld	hl,(_t2)

.i_11
	ex	de,hl		; same subtraction is used twice in the for loop
	and	a
	sbc	hl,de
	ld	(_j),hl

	; for ..; j>0; ..
	jp	m,i_6
	
	; 1st arg:  base+y
	ld	de,(_base)
	;ld	hl,(_j)
	push hl
	add	hl,de
	;push	hl
	ex	(sp),hl
	
	; 2nd arg: jd+y
	ld	de,(_jd)
	;ld	hl,(_j)
	add	hl,de
	push	hl

	ld bc,ret_addr
	push bc
	jp	(ix)		; compare function
.ret_addr

	pop de
	pop de

	; if ((*compar)(base+j, jd+j) <=0) break;
	dec hl
	bit 7,h
	jr	nz,i_6	; Negative sign ?   exit loop

	ld	de,(_base)
	ld	hl,(_j)
	push hl

	add	hl,de
	ex	(sp),hl
	ld	de,(_jd)
	add	hl,de
	push	hl

	ld	hl,(_width)
	push	hl
	call	memswap_callee

	; for ... j -= gap)
	ld	de,(_j)
	ld	hl,(_gap)
	jr	i_11
