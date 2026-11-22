
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_decimal
PUBLIC __stdio_scanf_sm_decimal_join

EXTERN asm_isdigit, __stdio_scanf_sm_write

__stdio_scanf_sm_decimal:

   ; DECIMAL NUMBER STATE MACHINE
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
   jr nz, state_3t             ; no more zeroes, look for decimal digits

   ld hl,state_2               ; next time consume leading zeroes
   jp __stdio_scanf_sm_write   ; write '0' to buffer

state_2:

   ; eat leading zeroes
   
   cp '0'
   ret z                       ; throw away leading zeroes

__stdio_scanf_sm_decimal_join:
state_3t:

   ld hl,state_3

state_3:

   ; read a string of decimal digits
   
   call asm_isdigit              ; is this char a decimal digit?
   jp nc, __stdio_scanf_sm_write
   
   ret                           ; if not, terminate iteration with carry flag set
