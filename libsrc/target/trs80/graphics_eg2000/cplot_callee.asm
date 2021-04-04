;*****************************************************
;
;	EG2000 colour graphics library library for z88dk
;
;		Stefano Bodrato - May 2018
;
;*****************************************************

; ----- void __CALLEE__ cplot_callee(int x, int y, int c)

SECTION code_clib
PUBLIC cplot_callee
PUBLIC _cplot_callee
PUBLIC asm_cplot

.cplot_callee
._cplot_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

.asm_cplot

   ld	a,c
   and 3
   ld	c,a
   
   ld h,e
   ld a,l
   cp 102
   ret nc
   
   ld a,h
   cp 160
   ret nc

   push bc
   and $03                   ; pixel offset   
   inc a
   ld c,a 
   
		ld	a,h
		push af
		rra
		rra
		and	@00111111

		ld	b,l

		ld	hl,$4800	; pointer to base of graphics area
		ld	l,a

		xor a
		or  b
		jr	z,zeroline
		
		ld	de,40
.adder	add	hl,de
		djnz	adder
		
.zeroline

;		ld	d,h
;		ld	e,l
		pop af

		
		ld	a,c		; save pixel offset
		pop bc		; restore color
		ld	b,a		; pixel offset
		ld a,$fc
.pset1
	   rrca
	   rrca
	   rrc c
	   rrc c
	   djnz pset1
   
   
		and (hl)
		or c
		ld (hl),a

		ret

