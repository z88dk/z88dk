;*****************************************************
;
;	EG2000 colour graphics library library for z88dk
;
;		Stefano Bodrato - May 2018
;
;*****************************************************

; ----- int __CALLEE__ cpoint_callee(int x, int y)

SECTION code_clib
PUBLIC cpoint_callee
PUBLIC _cpoint_callee
PUBLIC asm_cpoint

.cpoint_callee
._cpoint_callee


   pop af
   pop hl
   pop de
   push af

.asm_cpoint

   ld h,e
   ld a,l
   cp 102
   ret nc
   
   ld a,h
   cp 160
   ret nc

   ;push bc
   and $03                   ; pixel offset   
   inc a
   ld c,a 
   
		ld	a,h
;		push af
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
;		pop af
		
		ld a,(hl)
		ld	b,c		; pixel offset
.pset1
	   rlca
	   rlca
	   djnz pset1
   
   and 3

	ld	h,0
	ld	l,a
   
   ret

