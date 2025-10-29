
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_input_sm_gets

__stdio_input_sm_gets:

   ; GETS STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ; 
   ; Write all chars up to but not including '\n'
   ; to the buffer.  '\n' is rejected to cause
   ; immediate return to the caller so the caller
   ; must remove the '\n' from the stream. 
   ;
   ; set-up: hl = state machine function address
   ;         de = char *s = destination array
   ;
   ; return: de = void *s_ptr (address past last byte written)
   ;          l = 1 if caller should remove \n
   
   cp CHAR_LF                  ; '\n'
   jr z, delim_met
   
   ld (de),a                   ; write char to buffer
   inc de
   
   or a                        ; indicate accepted
   ret

delim_met:

   ld l,1                      ; indicate to caller to remove \n
   
   scf                         ; reject char for immediate return
   ret
