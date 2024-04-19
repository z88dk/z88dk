; strcpy function for use with far pointers
; 31/3/00 GWL

;
; $Id: strcpy_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;


IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
        SECTION   code_clib
        EXTERN __far_init    ;Get the initial bindings
        EXTERN __far_reset   ;Reset to initial bindings
        EXTERN __far_page  ;Page in the far segment
        EXTERN __far_incptr  ;Increment a far pointer (returning near address)
        PUBLIC strcpy_far
        PUBLIC _strcpy_far



;far *strcpy(far *s1,far *s2)
; copies s2 to s1

.strcpy_far
._strcpy_far
        push    ix 
        ld      ix,4
        add     ix,sp  
        ld      c,(ix+4)
        ld      b,(ix+5)
        ld      e,(ix+6)        ; E'B'C'=s1
        exx
        ld      c,(ix+0)
        ld      b,(ix+1)
        ld      e,(ix+2)        ; EBC=s2
        call    __far_init
	ex	af,af'		; save original binding
.strcpy1
        call    __far_page
        ld      a,(hl)          ; char from s2
        ld      iyl,a
        call    __far_incptr
        exx
        call    __far_page
        ld      a,iyl
        ld      (hl),a          ; place at s1
        call    __far_incptr
        exx
        and     a
        jr      nz,strcpy1
	ex	af,af'
        call    __far_reset
        ld      l,(ix+4)
        ld      h,(ix+5)
        ld      e,(ix+6)        ; EHL=s1
        pop     ix
	ret
ENDIF
