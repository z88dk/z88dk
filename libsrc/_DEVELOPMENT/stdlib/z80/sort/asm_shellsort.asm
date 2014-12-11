
; ===============================================================
; Nov 2014
; ===============================================================
; 
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))
;
; Shellsort the array using the comparison function supplied.
; REENTRANT VERSION NEEDS TO BE WRITTEN
;
; ===============================================================

SECTION code_stdlib

PUBLIC asm_shellsort

EXTERN __stdlib_shellsort_i
EXTERN __stdlib_shellsort_j
EXTERN __stdlib_shellsort_t1
EXTERN __stdlib_shellsort_t2
EXTERN __stdlib_shellsort_jd
EXTERN __stdlib_shellsort_base
EXTERN __stdlib_shellsort_gap

EXTERN l_mult, l_le, asm0_memswap

asm_shellsort:

   ; enter : ix = int (*compar)(de=const void *, hl=const void *)
   ;         bc = void *base
   ;         hl = size_t nmemb
   ;         de = size_t size
   ;
   ; exit  : none
   ;
   ;         if an error below occurs, no sorting is done.
   ;
   ;         einval if size == 0
   ;         einval if array size > 64k
   ;         erange if array wraps 64k boundary
   ;
   ; uses  : af, bc, de, hl, compare function

   ex de,hl

   ; hl = size
   ; bc = base
   ; de = nmemb
   ; ix = compare

	push de	; ngap
	push hl ;width
	ld	(__stdlib_shellsort_base),bc

	; t1 = nel * width;
	call	l_mult
	ld	(__stdlib_shellsort_t1),hl

	; for (ngap = nel / 2; ngap > 0; ngap /= 2) {
.i_3
	pop de	; width
	pop hl  ; ngap
	srl h			; _ngap/2 ..bit rotation
	rr  l
	ld	a,h
	or	l

	ret z
	push hl ; ngap
	push de	; width
	
	; gap = ngap * width;
	;ld d,h
	;ld e,l
	;ld	hl,(__stdlib_shellsort_width)
	call	l_mult
	ld	(__stdlib_shellsort_gap),hl
	; t2 = gap + width;

	pop de
	push de

	push hl
	;ex	de,hl
	;ld	hl,(__stdlib_shellsort_width)
	add	hl,de
	ld	(__stdlib_shellsort_t2),hl

	; jd = (unsigned int) base + gap;
	ld	de,(__stdlib_shellsort_base)
	ex	(sp),hl		; retrieve 'gap'
	add	hl,de
	ld	(__stdlib_shellsort_jd),hl
	pop hl			; t2
	jr	i_8
	
.i_6
	ld	de,(__stdlib_shellsort_i)
	pop hl
	push hl
	;ld	hl,(__stdlib_shellsort_width)
	add	hl,de
	;ld	(__stdlib_shellsort_i),hl

	; for (i = t2 ....
.i_8
	ld	(__stdlib_shellsort_i),hl
	ld	de,(__stdlib_shellsort_t1)
	ex	de,hl
	call	l_le
	jr	nc,i_3

	; for (j =  i - t2..
	ld	de,(__stdlib_shellsort_i)
	ld	hl,(__stdlib_shellsort_t2)

.i_11
	ex	de,hl		; same subtraction is used twice in the for loop
	and	a
	sbc	hl,de
	ld	(__stdlib_shellsort_j),hl

	; for ..; j>0; ..
	jp	m,i_6
	
	; 1st arg:  base+j
	ld	de,(__stdlib_shellsort_base)
	;ld	hl,(__stdlib_shellsort_j)
	push hl
	add	hl,de
	ex	(sp),hl	; j <--> base+j
	
	; 2nd arg: jd+j
	ld	de,(__stdlib_shellsort_jd)
	add	hl,de
	push	hl

	ld bc,ret_addr
	push bc
	jp	(ix)		; compare function
.ret_addr

	pop bc		; we're keeping the same args for the next call !
	pop de

	; if ((*compar)(base+j, jd+j) <=0) break;
	dec hl
	bit 7,h
	jr	nz,i_6	; Negative sign ?   exit loop

	
	pop hl		; width
	push hl
	
	push de	; 1st arg:  base+j
	push bc ; 2nd arg: jd+j
	push hl ; width

	call	asm0_memswap

	; for ... j -= gap)
	ld	de,(__stdlib_shellsort_j)
	ld	hl,(__stdlib_shellsort_gap)
	jr	i_11


SECTION bss_stdlib

PUBLIC __stdlib_shellsort_i
PUBLIC __stdlib_shellsort_j
PUBLIC __stdlib_shellsort_t1
PUBLIC __stdlib_shellsort_t2
PUBLIC __stdlib_shellsort_jd
PUBLIC __stdlib_shellsort_base
PUBLIC __stdlib_shellsort_gap

__stdlib_shellsort_i:          defw 0
__stdlib_shellsort_j:          defw 0
__stdlib_shellsort_t1:         defw 0
__stdlib_shellsort_t2:         defw 0
__stdlib_shellsort_jd:         defw 0
__stdlib_shellsort_base:       defw 0
__stdlib_shellsort_gap:        defw 0



; Original code taken from the BDS C by Leor Zolman
; Asm version by Stefano Bodrato
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
