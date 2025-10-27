
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_bkt

EXTERN l_bitset_locate, __stdio_scanf_sm_string_write

__stdio_scanf_sm_bkt:

   ; RIGHT BRACKET STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; set-up: hl = state machine function address
   ;         de = void *bitset
   ;         bc = void *buffer (0 = assignment suppression)
   ;
   ; return: bc = void *buffer_ptr (address past last byte written)
   ;         de = unchanged

   push af
   
   push bc
   call l_bitset_locate
   pop bc

   add hl,de
   and (hl)

   ld hl,__stdio_scanf_sm_bkt
   jr nz, accept                         ; if the char is in the bitset
   
   pop af
      
   scf                                   ; reject
   ret

accept:

   pop af
   
   or a
   jp __stdio_scanf_sm_string_write
