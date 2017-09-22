; strncpy function for use with far pointers
; 31/3/00 GWL

;
; $Id: strncpy_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
                EXTERN farseg1,incfar
                PUBLIC strncpy_far
                PUBLIC _strncpy_far


;far *strncpy(far *s1,far *s2,int n)
; copies s2 to s1 for exactly n chars, padding with nulls or truncating

.strncpy_far
._strncpy_far
        ld      ix,2
        add     ix,sp  
        ld      c,(ix+6)
        ld      b,(ix+7)
        ld      e,(ix+8)        ; E'B'C'=s1
        exx
        ld      c,(ix+2)
        ld      b,(ix+3)
        ld      e,(ix+4)        ; EBC=s2
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
	ld	l,(ix+0)
	ld	h,(ix+1)	; HL=n
	push	ix
	push	hl
	pop	ix		; IX=n
.strncpy1
	ld	a,ixl
	or	ixh
	jr	z,strncpy3	; on if copied n chars
        call    farseg1
        ld      a,(hl)          ; char from s2
        ld      iyl,a
        call    incfar
        exx
        call    farseg1
        ld      a,iyl
        ld      (hl),a          ; place at s1
        call    incfar
        exx
	dec	ix
        and     a
        jr      nz,strncpy1
; Now we have reached the end of s2, so pad s1 with nulls (already bound in)
	exx
.strncpy2
	ld	a,ixl
	or	ixh
	jr	z,strncpy3	; on if copied n chars
	ld	(hl),0
	call	incfar
	dec	ix
	jr	strncpy2
.strncpy3
	pop	ix
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
        ld      l,(ix+6)
        ld      h,(ix+7)
        ld      e,(ix+8)        ; EHL=s1
	ret
