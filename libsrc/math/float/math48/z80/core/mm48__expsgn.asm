
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__expsgn, mm48__retzero

EXTERN mm48__zero, am48_derror_erange_infxc

mm48__expsgn:

   ; AC' active (AC must be preserved)

   ;Juster exponent og udregn fortegn.

   jr c, mm48__exps1           ;Carry => EXPS1
   add a,$80                   ;Juster exponent
   jr c, mm48__exps2           ;Carry => EXPS2
;   jr mm48__exps3              ;Underflow

mm48__exps3:

   ; underflow or overflow (carry set)
   ; popping return address and creating result in jump

   ; AC' active

   pop hl                             ;uster stakken
   jp c, am48_derror_erange_infxc - 1 ;if overflow

mm48__retzero:

   call mm48__zero                ;underflow
   exx
   ret

mm48__exps1:

   add a,$80                   ;Juster exponent
   jr c, mm48__exps3           ;carry => Overflow

mm48__exps2:

   ld l,a                      ;Gem i exponent
   ex (sp),ix                  ;Gem IX
   exx
   push hl                     ;Gem AC exponent
   push bc                     ;Gem AC fortegn
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
