
; ===============================================================
; Apr 2004
; ===============================================================
;
; void *im2_create_generic_isr_8080(uint8_t num_callback, void *address)
;
; Create a light generic isr at the address given.  Space is
; reserved for num_callback callbacks.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_im2_create_generic_isr_8080

EXTERN __generic_isr_create, __generic_isr_run_callbacks
EXTERN asm_z80_push_registers_8080, asm_z80_pop_registers_8080

asm_im2_create_generic_isr_8080:

   ; enter :  a = uint8_t num_callback < 127
   ;         de = void *address
   ;
   ; exit  : hl = address following isr created
   ;
   ; uses  : af, bc, de, hl

   ld hl,generic_isr_8080
   jp __generic_isr_create
   
generic_isr_8080:

   call asm_z80_push_registers_8080

location:

   ld bc,generic_isr_8080_end - location
   add hl,bc
   
   call __generic_isr_run_callbacks
   
   call asm_z80_pop_registers_8080
   
   ei
   reti

generic_isr_8080_end:
