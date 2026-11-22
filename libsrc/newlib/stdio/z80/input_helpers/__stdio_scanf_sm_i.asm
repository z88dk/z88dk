
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_i

EXTERN __stdio_scanf_sm_decimal_join, __stdio_scanf_sm_hex_join
EXTERN __stdio_scanf_sm_octal_join, __stdio_scanf_sm_write

__stdio_scanf_sm_i:

   ; DEC / HEX / OCT NUMBER STATE MACHINE
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
   
   ld hl,state_1               ; next time look for base indicator
   
   cp '+'
   ret z                       ; accept plus sign, do not add to buffer
   
   cp '-'
   jp z, __stdio_scanf_sm_write  ; if negative, write '-' to buffer
   
   ; sign not present

state_1:

   ; check for base indicator
   
   cp '0'                                ; no leading zero means decimal
   jp nz, __stdio_scanf_sm_decimal_join  ; join the decimal state machine

   ld hl,state_2                         ; next time look for 'x'
   jp __stdio_scanf_sm_write             ; write the '0' to the buffer

state_2:

   ; look for 'x' in base indicator
   
   ld hl,__stdio_scanf_sm_hex_join       ; next time join the hex state machine
   
   cp 'x'
   jp z, __stdio_scanf_sm_write          ; accept and write to buffer
   
   cp 'X'
   jp z, __stdio_scanf_sm_write          ; accept and write to buffer

   ; this is an octal number
   
   ld hl,__stdio_scanf_sm_octal_join
   jp (hl)                     ; join the octal state machine
