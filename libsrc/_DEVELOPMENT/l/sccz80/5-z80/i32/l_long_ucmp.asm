;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       25/2/99 djm
;       Rewritten to use subtraction and use carry at end to figure
;       out which one was larger
;
; Entry:  primary  = (under two return addresses on stack)
;         secondary= dehl
;
; Exit:           z = numbers the same
;                nz = numbers different
;              c/nc = sign of difference [set if secondary > primary

;
;                hl = 1

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_ucmp

l_long_ucmp:

   ; computes (primary - secondary)
   ;
   ; dehl  = secondary
   ; stack = primary, return address 1, return address 2
   
   pop bc                      ; bc = return address 2

   exx
   
   pop bc                      ; bc = return address 1
   
   pop hl
   pop de                      ; dehl = primary
   
   push bc                     ; save return address 1
   ld a,l
   
   exx
   
   push bc                     ; save return address 2
   
   sub l
   ld l,a
   
   exx
   ld a,h
   exx
   
   sbc a,h
   ld h,a
   
   exx
   ld a,e
   exx
   
   sbc a,e
   ld e,a
   
   exx
   ld a,d
   exx
   
   sbc a,d
   ld d,a
   
   ; dehl = result, a = d

   jr c, negative

positive:

   ld a,h
   or l
   or d
   or e

negative:

   ld hl,1
   ret
