
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void _div(div_t *d, int numer, int denom)
;
; Fill the div_t struct with the results of integer divide
; numer / denom.
;
; struct div_t
; {
;    int rem;
;    int quot;
; };
;
; ===============================================================

XLIB _div_callee
XDEF asm__div

LIB l_divs_16_16x16

_div_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

asm__div:

   ; enter : bc = div_t *
   ;         hl = denom
   ;         de = numer
   ;
   ; exit  : div_t -> quot = numer / denom = de / hl
   ;         div_t -> rem  = numer % denom = de % hl
   ;
   ;         bc = de / hl
   ;         de = de % hl
   ;
   ; uses  : af, bc, de, hl
   
   push bc                     ; save div_t *
   
   call l_divs_16_16x16        ; hl = de/hl, de = de%hl
   
   ex (sp),hl                  ; hl = div_t *
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop bc                      ; bc = de / hl
   
   ld (hl),c
   inc hl
   ld (hl),b
   
   ret
