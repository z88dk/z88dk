
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_input_sm_getdelim

EXTERN asm_b_vector_append

__stdio_input_sm_getdelim:

   ; GETDELIM STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; Write all chars up to and including the delim char
   ; into the buffer but reject the delim char to cause
   ; immediate return.  The caller must explicitly
   ; remove the delim char from the stream.
   ;
   ; enter : de = b_vector *
   ;         bc = delim_char, delim_char > 255 never matches

state_0:

   push de                     ; save vector *
   push bc                     ; save delim_char
   push af                     ; save char

   ex de,hl
   call asm_b_vector_append    ; grow by one byte
   jr c, exit                  ; if failed to grow

   pop af                      ; a = char
   pop bc                      ; bc = delim_char
   pop hl
   ex de,hl                    ; de = vector *

   ; hl = & last byte in vector (reserved for '\0')
   
   ld (hl),0                   ; save some grief later and zero terminate
   dec hl
   ld (hl),a                   ; append char to vector
   
   cp c
   jr nz, delim_no_match

   inc b
   djnz delim_no_match         ; delim_char > 255 never matches
   
delim_matches:

   ld l,1                      ; indicate to caller that delim char needs to be removed

   scf                         ; reject delim char, leaving it on the stream
   ret
   
delim_no_match:

   ld hl,state_0
   
   or a
   ret                         ; carry reset to accept char

exit:

   ; vector cannot grow so reject
   
   ; hl = -1, carry set

   pop af
   pop bc
   pop de

   ret
