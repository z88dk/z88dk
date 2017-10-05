; strcpy function for use with far pointers
; 31/3/00 GWL

;
; $Id: strcpy_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
                EXTERN farseg1,incfar
                PUBLIC strcpy_far
                PUBLIC _strcpy_far


;far *strcpy(far *s1,far *s2)
; copies s2 to s1

.strcpy_far
._strcpy_far
        ld      ix,2
        add     ix,sp  
        ld      c,(ix+4)
        ld      b,(ix+5)
        ld      e,(ix+6)        ; E'B'C'=s1
        exx
        ld      c,(ix+0)
        ld      b,(ix+1)
        ld      e,(ix+2)        ; EBC=s2
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
.strcpy1
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
        and     a
        jr      nz,strcpy1
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
        ld      l,(ix+4)
        ld      h,(ix+5)
        ld      e,(ix+6)        ; EHL=s1
	ret
