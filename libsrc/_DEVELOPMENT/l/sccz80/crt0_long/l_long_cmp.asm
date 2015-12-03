;
;
;       Small C+ C Compiler
;
;       Long Support Functions
;
;       26/2/99 djm

;
;       I've realised that all the old long comparision functions were
;       (to be polite) fubarred, so I'm endeavouring to rewrite
;       the core so that we get some decent answers out - this is
;       helped no end by having a l_long_sub function which works
;       the right way round!
;
;       Anyway, on with the show; this is the generic compare routine
;       used for all signed long comparisons.

;       Entry: dehl=secondary
;              onstack (under two return addresses) = primary
;
;
;       Exit:     z=number is zero
;              (nz)=number is non-zero 
;                 c=number is negative
;                nc=number is positive
;
;                hl = 1

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_cmp

l_long_cmp:

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
   
   add a,a
   jr c, negative

positive:

   ld a,h
   or l
   or d
   or e

negative:

   ld hl,1
   ret
