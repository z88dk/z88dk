; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_colour(uchar ink)
;
; Set background colour in hi-res mode.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_color

EXTERN _GLOBAL_TS_PORT_FF
EXTERN asm_cpu_push_di, asm_cpu_pop_ei_jp

asm_tshr_color:

   ; enter : l = ink colour 0-7
   ;
   ; uses  : af, l

   ld a,l
   and $07
   add a,a
   add a,a
   add a,a
   ld l,a
   
   call asm_cpu_push_di
   
   ld a,(_GLOBAL_TS_PORT_FF)
   and $c7
   or l
   ld (_GLOBAL_TS_PORT_FF),a
   out ($ff),a
   
   jp asm_cpu_pop_ei_jp
