
; ===============================================================
; Apr 2004
; ===============================================================
;
; int im2_remove_generic_callback(uint8_t vector, void *callback)
;
; Remove the callback function from the generic isr's list.
; The generic isr is assumed to be installed on the vector given.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_im2_remove_generic_callback

EXTERN __generic_isr_locate_callbacks, error_einval_mc, error_znc

asm_im2_remove_generic_callback:

   ; enter :  l = interrupt vector
   ;         de = void *callback
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if callback function not found
   ;
   ;            hl = -1
   ;            carry set, errno = einval
   ;
   ; uses  : af, bc, de, hl
   
   call __generic_isr_locate_callbacks
   
search_loop:

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   
   ld a,b
   or c
   jp z, error_einval_mc       ; if callback not found
   
   ld a,c
   cp e
   jr nz, search_loop
   
   ld a,b
   cp d
   jr nz, search_loop
   
   ; callback found

   ld e,l
   ld d,h
   dec de
   dec de
   
remove_loop:

   ld a,(hl)
   ldi
   or (hl)
   ldi
   jr nz, remove_loop
   
   jp error_znc
