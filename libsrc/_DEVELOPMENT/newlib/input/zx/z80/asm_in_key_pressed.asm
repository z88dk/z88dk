
; ===============================================================
; Sep 2005
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
   ; uses  : af, hl
   
   ld a,h
   and $c0
   jr z, check_key
   
   ; check caps shift

caps_shift:
   
   add a,a
   jr nc, check_symshift

   ld a,$fe
   in a,($fe)
   and $01
   jp nz, error_znc            ; if caps shift not pressed

   ; check symbol shift
   
check_symshift:

   bit 6,h
   jr z, check_key
   
   ld a,$7f
   in a,($fe)
   and $02
   jp nz, error_znc            ; if sym shift not pressed

   ; check unshifted key

check_key:

   ld a,l                      ; a = key row
   in a,($fe)
   
   and $1f
   and h                       ; key mask
   
   jp nz, error_znc            ; if key is not pressed
   jp error_mc                 ; if key is pressed
