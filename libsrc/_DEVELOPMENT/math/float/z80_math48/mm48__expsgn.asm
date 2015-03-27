
SECTION code_fp_math48

PUBLIC mm48__expsgn

EXTERN mm48__zero

mm48__expsgn:

   ;Juster exponent og udregn fortegn.

   jr c, mm48__exps1           ;Carry => EXPS1
   add a,$80                   ;Juster exponent
   jr c, mm48__exps2           ;Carry => EXPS2
;   jr mm48__exps3              ;Underflow

mm48__exps3:

   pop hl                      ;uster stakken
   ret c                       ;Carry => Returner
   jp mm48__zero

mm48__exps1:

   add a,$80                   ;Juster exponent
   jr c, mm48__exps3           ;carry => Overflow

mm48__exps2:

   ld l,a                      ;Gem i exponent
   ex (sp),ix                  ;Gem IX
   exx
   push hl                     ;Gem AC' exponent
   push bc                     ;Gem AC' fortegn
   ld a,b                      ;Udregn nyt fortegn
   set 7,b
   exx
   xor b
   and $80
   push af
   set 7,b
   push ix
   ld ix,0                     ;Nulstil IX
   ret
