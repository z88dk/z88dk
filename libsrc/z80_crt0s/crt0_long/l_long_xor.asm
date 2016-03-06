;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC    l_long_xor

; dehl = primary
; stack = secondary, ret

.l_long_xor

   pop ix
   
   pop bc
   ld a,c
   xor l
   ld l,a
   ld a,b
   xor h
   ld h,a
   
   pop bc
   ld a,c
   xor e
   ld e,a
   ld a,b
   xor d
   ld d,a
   
   jp (ix)


;.l_long_xor   
;        ld       a,d
;        exx             ;primary;
;	pop	bc;
;	pop	hl
;	pop	de
;	push	bc
;       xor      d
;        ld      d,a
;        ld      a,e
;        exx             ;2nd
;        xor      e
;        exx             ;1st
;        ld      e,a
;        ld      a,h
;        exx             ;2nd
;        xor      h
;        exx             ;1st
;        ld      h,a
;        ld      a,l
;        exx             ;2nd
;        xor      l
;        exx             ;1st
;        ld      l,a
;        ret
