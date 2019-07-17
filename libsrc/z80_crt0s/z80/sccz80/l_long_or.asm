;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC    l_long_or

; "or" primary and secondary into dehl
; dehl = primary
; stack = secondary, ret

.l_long_or

   pop ix
   
   pop bc
   ld a,c
   or l
   ld l,a
   ld a,b
   or h
   ld h,a
   
   pop bc
   ld a,c
   or e
   ld e,a
   ld a,b
   or d
   ld d,a
   
   jp (ix)


;.l_long_or   
;        ld       a,d
;        exx             ;primary;
;	pop	bc
;	pop	hl
;	pop	de
;	push	bc
;       or      d
;        ld      d,a
;        ld      a,e
;        exx             ;2nd
;        or      e
;        exx             ;1st
;        ld      e,a
;        ld      a,h
;        exx             ;2nd
;        or      h
;        exx             ;1st
;        ld      h,a
;        ld      a,l
;        exx             ;2nd
;        or      l
;        exx             ;1st
;        ld      l,a
;        ret
