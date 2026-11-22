
; ===============================================================
; Sep 2014
; ===============================================================
; 
; int16_t in_mouse_kempston_wheel_delta(void)
;
; Report change in position of mouse track wheel.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_kempston_wheel_delta

EXTERN asm_in_mouse_kempston_wheel
EXTERN __input_kempston_mouse_wheel

asm_in_mouse_kempston_wheel_delta:

   ; exit : hl = signed change in track wheel position
   ;        carry reset
   ;
   ; uses : af, de, hl

   call asm_in_mouse_kempston_wheel      ; hl = current absolute wheel position
   
   ld de,(__input_kempston_mouse_wheel)  ; de = former absolute wheel position
   ld (__input_kempston_mouse_wheel),hl  ; store new absolute wheel position
   
   sbc hl,de                             ; hl = relative change in position

   ld a,h
   or a
   jp p, positive

negative:

   inc a
   jr nz, negative_saturate
   
   bit 7,l
   ret nz

negative_saturate:

   ld hl,-128
   ret

positive:

   jr nz, positive_saturate
   
   bit 7,l
   ret z

positive_saturate:

   ld hl,127
   ret
   