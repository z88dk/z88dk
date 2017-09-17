; strchr function for use with far pointers
; 31/3/00 GWL

;
; $Id: strchr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
		EXTERN farseg1,incfar
                PUBLIC strchr_far
                PUBLIC _strchr_far


;far *strchr(far *s,int c)
; finds pointer to first occurrence of c in s (or NULL if not found)

.strchr_far
._strchr_far
	pop	hl
	pop	iy		; IYl=char
	pop	bc
	pop	de		; EBC=far pointer
	push	de
	push	bc
	push	iy
	push	hl
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
	call	farseg1		; bind to segment 1, with address in HL
.strchr1
        ld      a,(hl)
	cp	iyl
	jr	z,strchrend	; finished if found character
	call	incfar
        and     a
	jr	nz,strchr1
	ld	e,a
	ld	b,a
	ld	c,a		; EBC=NULL, character not found
.strchrend
	ld	h,b
	ld	l,c		; EHL=pointer to character, or NULL
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
	ret
