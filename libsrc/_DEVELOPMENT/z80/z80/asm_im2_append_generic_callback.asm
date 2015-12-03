
; ===============================================================
; Apr 2004
; ===============================================================
;
; void im2_append_generic_callback(uint8_t vector, void *callback)
;
; Append the callback function to the end of the generic isr's
; callback array.  The generic isr is assumed to be installed on
; the vector given.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_im2_append_generic_callback

EXTERN __generic_isr_locate_callbacks

asm_im2_append_generic_callback:

   ; enter :  l = interrupt vector
   ;         de = void *callback
   ;
   ; uses  : af, bc, de, hl
   
   call __generic_isr_locate_callbacks
   
loop:

   ld a,(hl)
   inc hl
   or (hl)
   inc hl
   jr nz, loop
   
   dec hl
   ld (hl),d
   dec hl
   ld (hl),e
   
   ret
