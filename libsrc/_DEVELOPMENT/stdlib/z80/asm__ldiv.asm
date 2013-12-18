
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

XLIB asm__ldiv

LIB l_divs_32_32x32

asm__ldiv:

   ; enter :    bc  = ldiv_t * 
   ;         de hl  = numer
   ;         de'hl' = denom
   ;
   ; exit  : ldiv_t -> quot = numer / denom
   ;         ldiv_t -> rem  = numer % denom
   ;
   ;         de bc  = numer % denom
   ;         de'bc' = numer / denom
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   push bc                     ; save ldiv_t *
   
   push de
   push hl
   exx
   
   ; dehl  = denom
   ; stack = ldiv_t *, numer
   
   call l_divs_32_32x32
   
   ; de hl  = numer / denom
   ; de'hl' = numer % denom
   ; stack  = ldiv_t *

   ld c,l
   ld b,h
   pop hl
   
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ldiv_t -> quot = numer / denom
   inc hl

   push hl
   
   exx
   
   ld c,l
   ld b,h
   pop hl
   
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ldiv_t -> rem = numer % denom

   ret
