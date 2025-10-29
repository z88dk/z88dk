
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_ii

EXTERN __stdio_scanf_sm_i, __stdio_scanf_sm_write

__stdio_scanf_sm_ii:

   ; DOT + DEC / HEX / OCT NUMBER STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; set-up: hl = state machine function address
   ;         de = void *buffer
   ;         bc = uint buffer_len
   ;
   ; return: de = void *buffer_ptr (address past last byte written)
   ;         bc = remaining space in buffer

   cp '.'
   jr nz, dot_not_present
   
   ld hl,__stdio_scanf_sm_i    ; join the dec/hex/oct state machine
   ret

dot_not_present:

   ld a,'.'                    ; write a dot to buffer to cause an error during conversion
   
   scf                         ; stop stream consumption
   jp __stdio_scanf_sm_write
