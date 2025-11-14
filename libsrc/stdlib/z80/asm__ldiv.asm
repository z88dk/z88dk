
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void _ldiv(ldiv_t *ld, long numer, long denom)
;
; Fill the ldiv_t struct with the results of long divide
; numer / denom.
;
; struct ldiv_t
; {
;    long quot;
;    long rem;
; };
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__ldiv

EXTERN l_divs_32_32x32, __ldiv_store

asm__ldiv:

   ; enter :   bc  = ldiv_t * 
   ;         dehl  = denom
   ;         dehl' = numer
   ;
   ; exit  : ldiv_t.quot = numer / denom
   ;         ldiv_t.rem  = numer % denom
   ;
   ;         dehl' = numer % denom
   ;         dehl  = numer / denom
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ixh
   
   push bc                     ; save ldiv_t *
      
   call l_divs_32_32x32

   ; dehl  = numer / denom
   ; dehl' = numer % denom
   ; stack  = ldiv_t *

   jp __ldiv_store
