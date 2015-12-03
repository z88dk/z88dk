
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_hex
PUBLIC __stdio_scanf_sm_hex_join

EXTERN asm_isxdigit, __stdio_scanf_sm_write

__stdio_scanf_sm_hex:

   ; HEXADECIMAL NUMBER STATE MACHINE
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
   
   cp '-'                      ; if negative sign, write '-' to buffer
   jp z, __stdio_scanf_sm_write
   
   ; sign not present

state_1:

   ; check for base indicator '0'
   
   cp '0'
   jr nz, state_4t             ; if no base indicator present
   
   ld hl,state_2               ; next time look for 'x'
   jp __stdio_scanf_sm_write   ; write '0' to buffer

state_2:

   ; check for base indicator 'x'
   
   ld hl,state_3               ; next time consume any leading zeroes
   
   cp 'x'
   ret z                       ; accept base indicator, do not add to buffer
   
   cp 'X'
   ret z
   
   ; fall through
   
state_3:

   ; consume leading zeroes
   
   cp '0'
   ret z                       ; consume zero, do not add to buffer

state_4t:

   ld hl,state_4

state_4:

   ; accept hex digits
   
   call asm_isxdigit
   jp nc, __stdio_scanf_sm_write
   
   ret                         ; reject if not hex digit with carry set

__stdio_scanf_sm_hex_join:
state_5:

   ; accept first zero
   
   ld hl,state_3               ; next time consume leading zeroes
   
   cp '0'
   jp z, __stdio_scanf_sm_write  ; accept first zero and write to buffer
   
   jr state_4t                   ; check for hex digit
