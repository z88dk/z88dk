
	PUBLIC lp_gchar, lp_gint, lp_pchar, lp_pint, lp_gptr, lp_pptr

	PUBLIC _malloc_far, _free_far

	EXTERN _mm_malloc, _mm_free, _mm_lp_gchar, _mm_lp_gint, _mm_lp_pchar, _mm_lp_pint, _mm_lp_gptr, _mm_lp_pptr
	
_malloc_far:
	pop	de
	pop     bc
	pop     hl
	push    hl             ; HLBC=required size (num_bytes)
	push	bc
	push	de
	
	push bc 		;push num_bytes (int part, cast from long...)
	call _mm_malloc
	pop bc			;pop arg

    ret

_free_far:	
	push de
	push hl
	call _mm_free
	pop hl			;remove arg
	pop de
	ret

lp_gchar:
	push de
	push hl
	call _mm_lp_gchar
	pop de			;remove arg
	pop de
	ld a,l
	ret

lp_gint:
	push de
	push hl
	call _mm_lp_gint
	pop de
	pop de
	ret

lp_pchar:
	exx ;address in e'h'l'
	push de			;push e (address)
	push hl			;push hl
	exx			;value in l
	push hl			;push val
	call _mm_lp_pchar
	pop de			;remove arg
	pop de
	pop de
	ret

lp_pint:
	exx ;address in e'h'l'
	push de			;push e (address)
	push hl			;push hl
	exx			;value in hl
	push hl			;push val
	call _mm_lp_pint
	pop de			;remove arg
	pop de
	pop de
	ret

lp_gptr:	
	push de
	push hl
	call _mm_lp_gptr
	pop bc			;remove arg
	pop bc
	ret

lp_pptr:
	exx ;address in e'h'l'
	push de			;push e (address)
	push hl			;push hl
	exx			;value in hl
	push de			;push val (ehl)
	push hl			;push val
	call _mm_lp_pptr
	pop bc			;remove arg
	pop bc
	pop bc
	pop bc
	ret



