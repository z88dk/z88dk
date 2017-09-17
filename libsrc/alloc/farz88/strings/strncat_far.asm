; strncat function for use with far pointers
; 31/3/00 GWL

;
; $Id: strncat_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
                EXTERN farseg1,incfar
                PUBLIC strncat_far
                PUBLIC _strncat_far


;far *strncat(far *s1,far *s2,int n)
; concatenates s2 onto the end of s1 (at most n chars) & null-terminates

.strncat_far
._strncat_far
        ld      ix,2
        add     ix,sp  
        ld      c,(ix+2)
        ld      b,(ix+3)
        ld      e,(ix+4)        ; E'B'C'=s2
        exx
        ld      c,(ix+6)
        ld      b,(ix+7)
        ld      e,(ix+8)        ; EBC=s1
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
	ld	l,(ix+0)
	ld	h,(ix+1)
	push	ix
	push	hl
	pop	ix		; IX=n
        call    farseg1         ; start with s1
        jr      startfind
.findend
        call    incfar
.startfind
        ld      a,(hl)          ; char from s1
        and     a
        jr      nz,findend
        exx			; switch to s2
.catloop
	ld	a,ixl
	or	ixh
	jr	z,strncat2	; on if copied n chars already
        call    farseg1
        ld      a,(hl)          ; char from s2
        ld      iyl,a
        call    incfar
        exx
        call    farseg1
        ld      a,iyl
        ld      (hl),a          ; place in s1
        call    incfar
        exx
	dec	ix
        and     a
        jr      nz,catloop
	jr	strncat3
.strncat2
	exx
	call	farseg1
	ld	(hl),0		; null-terminate s1
.strncat3
	pop	ix
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
        ld      l,(ix+6)
        ld      h,(ix+7)
        ld      e,(ix+8)        ; EHL=s1
	ret
