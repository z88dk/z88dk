;
;       Small C+ Long Library Functions
;
;       Divide 2 32 bit numbers
;
;       Hopefully this routine does work!
;
;       I think the use of ix is unavoidable in this case..unless you know
;       otherwise!
;
;       Replaced use of ix with bcbc'

                SECTION   code_crt0_sccz80
PUBLIC    l_long_div

EXTERN     l_long_div_u, l_long_neg
EXTERN    L_LONG_DIVIDE0, L_LONG_DIVENTRY

; 32 bit division
; enter:
;    dehl = arg2
;   stack = arg1, ret
; exit:
;    dehl = arg1/arg2
;   de'hl'= arg1%arg2

.l_long_div

   ld a,d
   or e
   or h
   or l
   jp z, l_long_div_u + L_LONG_DIVIDE0

   pop af
   push hl
   exx
   pop de
   pop bc
   ld hl,0
   exx
   pop bc
   ld hl,0
   push af

   ; bcbc' = arg1
   ; hlhl' = res
   ; dede' = arg2

   ; some nastiness to deal with signs

   ld a,c
   ld c,d
   push bc                     ; b = sgn(arg1), c = sgn(arg2)
   ld c,a

   bit 7,b
   jr z, skipnegbcbc

.negbcbc

   exx
   ld a,c
   cpl
   ld c,a
   ld a,b
   cpl
   ld b,a
   ld a,b
   or c
   inc bc
   exx
   ld a,c
   cpl
   ld c,a
   ld a,b
   cpl
   ld b,a
   jr nz, skipnegbcbc
   inc bc

.skipnegbcbc

   bit 7,d
   jr z, skipnegdede

.negdede

   exx
   ld a,e
   cpl
   ld e,a
   ld a,d
   cpl
   ld d,a
   ld a,d
   or e
   inc de
   exx
   ld a,e
   cpl
   ld e,a
   ld a,d
   cpl
   ld d,a
   jr nz, skipnegdede
   inc de

.skipnegdede

   call l_long_div_u + L_LONG_DIVENTRY

   ; dehl   = quotient
   ; de'hl' = remainder

   ; deal with the signs
   
   pop bc                      ; b = sgn(arg1), c = sgn(arg2)

   ld a,b
   xor c
   call m, l_long_neg
   
   ld a,b
   and $80
   ret p
   exx
   call l_long_neg
   exx
   ret
