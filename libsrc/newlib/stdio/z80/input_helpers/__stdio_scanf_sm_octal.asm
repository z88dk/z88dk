
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_octal
PUBLIC __stdio_scanf_sm_octal_join

EXTERN asm_isodigit, __stdio_scanf_sm_write

__stdio_scanf_sm_octal:

   ; OCTAL NUMBER STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; set-up: hl = state machine function address
   ;         de = void *buffer
   ;         bc = uint buffer_len
   ;
   ; return: de = void *buffer_ptr (address past last byte written)
   ;         bc = remaining space in buffer

   ; consume optional sign

   ld hl,state_1               ; next time look for leading zeroes
   
   cp '+'
   ret z                       ; accept plus sign, do not add to buffer
   
   cp '-'
   jp z, __stdio_scanf_sm_write  ; if negative sign, write '-' to buffer
   
   ; sign not present

state_1:

   ; check for first zero
   
   cp '0'
   jr nz, state_3t             ; no more zeroes, look for octal digits

   ld hl,state_2               ; next time consume leading zeroes
   jp __stdio_scanf_sm_write   ; write '0' to buffer

__stdio_scanf_sm_octal_join:
state_2:

   ; eat leading zeroes
   
   cp '0'
   ret z                       ; throw away leading zeroes
   
state_3t:

   ld hl,state_3

state_3:

   ; read a string of octal digits

   call asm_isodigit           ; is this char an octal digit ?
   jp nc, __stdio_scanf_sm_write
   
   ret                         ; if not terminate iteration with carry set
