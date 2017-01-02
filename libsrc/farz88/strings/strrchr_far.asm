; strrchr function for use with far pointers
; 31/3/00 GWL

;
; $Id: strrchr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
		EXTERN farseg1,incfar
                PUBLIC strrchr_far
                PUBLIC _strrchr_far


;far *strrchr(far *s,int c)
; finds pointer to last occurrence of c in s (or NULL if not found)

.strrchr_far
._strrchr_far
	ld	e,0
	ld	h,e
	ld	l,e
	exx			; E'H'L'=NULL pointer, if char not found
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
.strrchr1
        ld      a,(hl)
	cp	iyl
	jr	nz,strrchr2	; on if not found character
	push	bc
	push	de
	exx
	pop	de
	pop	hl		; store position of occurrence (EHL)
	exx
.strrchr2
	call	incfar
        and     a
	jr	nz,strrchr1
	exx			; EHL=pointer to last, or NULL
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
	ret
