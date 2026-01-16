
; ===============================================================
; Aug 2015
; ===============================================================
; 
; int in_key_pressed(uint16_t scancode)
;
; Using the scancode to identify a key, quickly determine
; if the key is one of those currently pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_key_pressed

EXTERN error_znc, error_mc

asm_in_key_pressed:

   ; enter : hl = scancode
   ;
   ; exit  : if key is pressed
   ;
   ;            hl = -1
   ;            carry set
   ;
   ;         if key is not pressed
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ; uses  : af, bc, hl
   
   ld a,l
   and $e0
   jr z, key
   
alt:

   add a,a
   jr nc, ctrl

   ld a,7
   out ($b5),a
   
   in a,($b5)
   and $80
   
   jr z, key                   ; if ALT pressed
   jp error_znc

ctrl:

   bit 6,l
   jr z, shift

   ld a,1
   out ($b5),a
   
   in a,($b5)
   and $80
   
   jr z, key                   ; if CTRL pressed
   jp error_znc

shift:

   bit 5,l
   jr z, key

   xor a
   out ($b5),a
   
   in a,($b5)
   and $80
   
   jr z, key                   ; if LSHIFT pressed
   
   ld a,8
   out ($b5),a
   
   in a,($b5)
   and $20
   
   jp nz, error_znc            ; if RSHIFT not pressed

key:

   ld a,l
   and $0f
   
   out ($b5),a
   in a,($b5)
   
   and h
   jp nz, error_znc            ; if key is not pressed
   
   jp error_mc                 ; if key is pressed
