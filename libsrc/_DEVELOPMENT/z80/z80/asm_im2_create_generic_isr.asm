
; ===============================================================
; Apr 2004
; ===============================================================
;
; void *im2_create_generic_isr(uint8_t num_callback, void *address)
;
; Create a generic isr at the address given.  Space is reserved
; for num_callback callbacks.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_im2_create_generic_isr

EXTERN __generic_isr_create, __generic_isr_run_callbacks
EXTERN asm_z80_push_registers, asm_z80_pop_registers

asm_im2_create_generic_isr:

   ; enter :  a = uint8_t num_callback < 127
   ;         de = void *address
   ;
   ; exit  : hl = address following isr created
   ;
   ; uses  : af, bc, de, hl
  
   ld hl,generic_isr
   jp __generic_isr_create
   
generic_isr:

   call asm_z80_push_registers

location:

   ld bc,generic_isr_end - location
   add hl,bc
   
   call __generic_isr_run_callbacks
   
   call asm_z80_pop_registers
   
   ei
   reti

generic_isr_end:
