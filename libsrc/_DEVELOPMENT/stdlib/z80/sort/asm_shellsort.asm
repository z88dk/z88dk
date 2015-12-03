
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

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_shellsort

EXTERN l_mulu_16_16x16, asm0_memswap, l_compare_de_hl

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

   ; hl = size = width
   ; bc = base
   ; de = nmemb = nel
   ; ix = compare

	push de	; ngap
	push hl ;width
	ld	(__stdlib_shellsort_base),bc

	; t1 = nel * width;
	call	l_mulu_16_16x16
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
	call	l_mulu_16_16x16
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

	; for (i = t2; i <= t1; i += width)
.i_8
	ld	(__stdlib_shellsort_i),hl
	ld	de,(__stdlib_shellsort_t1)
	
	; hl = i, de = t1
	
	scf
	sbc hl,de
	jr nc, i_3    ; if i-t1-1 >= 0 (if i>t1)

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
 
        ; hl = j
        
        ld c,l
        ld b,h                 ; bc = j
        
        ld hl,(__stdlib_shellsort_jd)
        add hl,bc
        
        ex de,hl               ; de = jd + j
        
        ld hl,(__stdlib_shellsort_base)
        add hl,bc              ; hl = base + j

        ; if ((*compar)(base+j, jd+j) <=0) break;

        call l_compare_de_hl   ; compare(de = jd+j, hl = base+j)
        jp p, i_6              ; if *(jd+j) >= *(base+j)

        ; de = jd + j (2nd arg)
        ; hl = base + j (1st arg)
        ; stack = width
	
	pop bc
	push bc
	
	call	asm0_memswap

	; for ... j -= gap)
	ld	de,(__stdlib_shellsort_j)
	ld	hl,(__stdlib_shellsort_gap)
	jr	i_11


SECTION bss_clib
SECTION bss_stdlib

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
