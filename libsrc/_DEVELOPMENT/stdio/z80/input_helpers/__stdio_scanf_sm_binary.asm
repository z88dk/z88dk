
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_binary

EXTERN asm_isbdigit, __stdio_scanf_sm_write

__stdio_scanf_sm_binary:

   ; BINARY NUMBER STATE MACHINE
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
   jr nz, state_3t             ; no zeroes, look for binary digits

   ld hl,state_2               ; next time consume leading zeroes
   jp __stdio_scanf_sm_write   ; write '0' to buffer

state_2:

   ; eat leading zeroes
   
   cp '0'
   ret z                       ; throw away leading zeroes
   
state_3t:

   ld hl,state_3

state_3:

   ; read a string of binary digits
   
   call asm_isbdigit           ; is this char a binary digit?
   
   scf
   ret nz                      ; if not, terminate iteration
   ccf

   jp __stdio_scanf_sm_write
