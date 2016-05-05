
; ===============================================================
; Jul 2015
; ===============================================================
; 
; void _lldiv_(lldiv_t *ld, int64_t numer, int64_t denom)
;
; Fill the lldiv_t struct with the results of long long divide
; numer / denom.
;
; struct lldiv_t
; {
;    int64_t rem;
;    int64_t quot;
; };
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__lldiv

EXTERN l_divs_64_64x64, __lldiv_store

asm__lldiv:

   ; enter :         +------------------------
   ;                 | +19 
   ;                 | ...  denom (8 bytes)
   ;                 | +12 
   ;                 |------------------------
   ;                 | +11
   ;                 | ...  numer (8 bytes)
   ;                 | +4
   ;                 |------------------------
   ;                 | +3
   ;                 | +2   lldiv_t *ld
   ;                 |------------------------
   ;                 | +1
   ;         stack = | +0   return address
   ;                 +------------------------
   ;
   ; exit  : lldiv_t.quot = numer / denom
   ;         lldiv_t.rem  = numer % denom
   ;
   ;                 +------------------------
   ;                 | +17 
   ;                 | ...  denom (8 bytes)
   ;                 | +10 
   ;                 |------------------------
   ;                 | +9
   ;                 | ...  numer (8 bytes)
   ;                 | +2
   ;                 |------------------------
   ;                 | +1
   ;         stack = | +0   lldiv_t *ld
   ;                 +------------------------
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   push ix
   
   ld ix,6
   add ix,sp                   ; ix = & numer
   
   call l_divs_64_64x64
   
   ; dehl'dehl = remainder
   ; stack.numer = quotient
   
   jp __lldiv_store
