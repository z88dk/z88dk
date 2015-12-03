
; ===============================================================
; Aug 2003
; ===============================================================
; 
; void in_mouse_amx(uint8_t *buttons, uint16_t *x, uint16_t *y)
;
; Returns mouse coordinate and button state.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_amx

EXTERN __input_amx_mouse_x, __input_amx_mouse_y

asm_in_mouse_amx:

   ; exit  :  a = button state = 0000 0MRL active high
   ;         de = x coordinate
   ;         bc = y coordinate
   ;
   ; uses  : af, bc, de
   
   ; amx button state can randomly fluctuate
   ; take several reads and mix results
   
   ld bc,$051f
   
button_loop:

   in a,($df)
   or c
   ld c,a
   
   djnz button_loop
   
   rlca
   rlca
   rlca
   and $07
   
   add a,button_table % 256
   ld c,a
   ld a,0
   adc a,button_table / 256
   ld b,a
   
   ld a,(bc)                   ; a = button state = 0000 0MRL active high
   
   ; x coordinate
   
   ld de,(__input_amx_mouse_x + 1)
   ld d,0
   
   ; y coordinate
   
   ld bc,(__input_amx_mouse_y + 1)
   ld b,d

   ret

button_table:

   defb $07, $03, $05, $01, $06, $02, $04, $00
