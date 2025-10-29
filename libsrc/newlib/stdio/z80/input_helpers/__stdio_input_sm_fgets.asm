
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_input_sm_fgets

__stdio_input_sm_fgets:

   ; FGETS STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; Write all chars up to and including '\n'
   ; to the buffer.  '\n' is rejected to cause
   ; immediate return to the caller so the caller
   ; must remove the '\n' from the stream. 
   ;
   ; set-up: hl = state machine function address
   ;         de = char *s = destination array
   ;         bc = num chars to consume
   ;
   ; return: de = void *s_ptr (address past last byte written)
   ;          l = 1 if caller should remove \n

   inc c
   dec c
   jr nz, space

   inc b
   djnz space
   
   ; ran out of room
   
   ld l,0                      ; tell caller not to remove \n from stream
   
   scf                         ; reject char
   ret

space:

   dec bc                      ; space remaining
   
   ld (de),a                   ; write char to buffer
   inc de
   
   cp CHAR_LF                  ; '\n'
   jr z, delim_met
   
   or a                        ; indicate accepted
   ret

delim_met:

   ld l,1                      ; tell caller to remove \n from stream
   
   scf                         ; reject char to return
   ret
