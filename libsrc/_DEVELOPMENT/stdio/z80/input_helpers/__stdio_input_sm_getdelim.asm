
XLIB __stdio_input_sm_getdelim

LIB asm_b_vector_append_block

__stdio_input_sm_getdelim:

   ; GETDELIM STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ; accepts all chars up to and including the delim char
   ;
   ; enter : de = b_vector *
   ;         bc = delim_char, delim_char > 255 never matches

state_0:

   push de                     ; save vector *
   push bc                     ; save delim_char
   push af                     ; save char

   ex de,hl
   ld bc,1                     ; grow vector by one byte
   call asm_b_vector_append_block
   jr c, exit                  ; if failed to grow

   pop af                      ; a = char
   pop bc                      ; bc = delim_char
   pop de                      ; de = vector *

   ; hl = & last byte in vector (reserved for '\0')
   
   ld (hl),0                   ; save some grief later and zero terminate
   dec hl
   ld (hl),a                   ; append char to vector
   
   cp c
   jr nz, delim_no_match

   inc b
   djnz delim_no_match         ; delim_char > 255 never matches
   
delim_matches:

   ld hl,state_1               ; next time reject char
   ret                         ; carry reset to accept delim_char

delim_no_match:

   ld hl,state_0
   
   or a
   ret                         ; carry reset to accept char

state_1:

   ; delim char has been seen, reject the char
   
   scf
   ret

exit:

   ; vector cannot grow so reject

   pop af
   pop bc
   pop de
   
   scf                         ; reject the char
   ret
