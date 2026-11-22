; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_cls_attr(uchar paper)
;
; Set background colour in hi-res mode.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cls_attr

EXTERN asm_cpu_push_di, asm_cpu_pop_ei_jp

asm_tshr_cls_attr:

   ; enter : l = paper colour (0-7)<<3
   ;
   ; uses  : af, l

   ld a,l
   xor $38
   and $38
   ld l,a
   
   call asm_cpu_push_di
   
   in a,($ff)
   and $c7
   or l
   out ($ff),a
   
   jp asm_cpu_pop_ei_jp
