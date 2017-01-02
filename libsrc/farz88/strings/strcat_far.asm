; strcat function for use with far pointers
; 31/3/00 GWL

;
; $Id: strcat_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
                EXTERN farseg1,incfar
                PUBLIC strcat_far
                PUBLIC _strcat_far


;far *strcat(far *s1,far *s2)
; concatenates s2 onto the end of s1

.strcat_far
._strcat_far
        ld      ix,2
        add     ix,sp  
        ld      c,(ix+0)
        ld      b,(ix+1)
        ld      e,(ix+2)        ; E'B'C'=s2
        exx
        ld      c,(ix+4)
        ld      b,(ix+5)
        ld      e,(ix+6)        ; EBC=s1
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
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
        and     a
        jr      nz,catloop
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
        ld      l,(ix+4)
        ld      h,(ix+5)
        ld      e,(ix+6)        ; EHL=s1
	ret
