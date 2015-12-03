
SECTION code_clib
SECTION code_z80

PUBLIC __generic_isr_run_callbacks

EXTERN l_jphl

__generic_isr_run_callbacks:

   ; run a zero-terminated array of callback functions
   ; execution of array is terminated early if a callback function sets carry flag
   
   ; enter : hl = address of array of callback functions
   ;
   ; exit  : carry set if terminated early
   ;
   ; uses  : all
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   ld a,d
   or e
   ret z
   
   push hl
   
   ex de,hl
   call l_jphl
   
   pop hl
   ret c
   
   jr __generic_isr_run_callbacks
