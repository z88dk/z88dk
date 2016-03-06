;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC l_long_and

; primary = dehl
; stack = secondary, ret
; 90 cycles

.l_long_and

   pop ix
   
   pop bc
   ld a,c
   and l
   ld l,a
   ld a,b
   and h
   ld h,a

   pop bc
   ld a,c
   and e
   ld e,a
   ld a,b
   and d
   ld d,a
   
   jp (ix)

; 127 cycles
;
;.l_long_and   
;        ld       a,d
;        exx             ;primary
;	pop	bc;
;	pop	hl
;	pop	de
;	push	bc
;       and     d
;       ld      d,a
;       ld      a,e
;       exx             ;2nd
;       and     e
;       exx             ;1st
;       ld      e,a
;       ld      a,h
;       exx             ;2nd
;       and     h
;       exx             ;1st
;       ld      h,a
;       ld      a,l
;       exx             ;2nd
;       and     l
;       exx             ;1st
;       ld      l,a
;       ret

; primary = dehl
; stack = secondary, ret addr
; 141 cycles but doesn't use EXX
;
;.l_long_and
;
;   pop bc
;   ex de,hl
;   ex (sp),hl
;   ld a,l
;   and e
;   ld l,a
;   ld a,h
;   and d
;   ld h,a
;   pop de
;   ex (sp),hl
;   ld a,l
;   and e
;   ld e,a
;   ld a,h
;   and d
;   ld d,a
;   pop hl
;   push bc
;   ret
