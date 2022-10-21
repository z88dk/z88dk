
SECTION code_clib
SECTION code_l

PUBLIC l_compare_de_hl

EXTERN l_jpix

l_compare_de_hl:

  ; enter : ix = compare function
  ;         de = left operand
  ;         hl = right operand
  ;
  ; exit  : *de >= *hl if p flag set
  ;         *de << *hl if m flag set
  ;         *de == *hl if z flag set and a==0
  ;         carry reset
  ;
  ; uses  : af

   push hl
   push bc
   push de
   push ix

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   push hl
   push de

   call l_jpix                 ; compare(de, hl)

   ld a,h
   or a
   ld a,l
   
   pop de
   pop hl

;******************************
ELSE
;******************************

   push de
   push hl
   
   call l_jpix                 ; compare(de, hl)

   ld a,h
   or a
   ld a,l
   
   pop hl
   pop de

;******************************
ENDIF
;******************************
   
   pop ix
   pop de
   pop bc
   pop hl

   ret
