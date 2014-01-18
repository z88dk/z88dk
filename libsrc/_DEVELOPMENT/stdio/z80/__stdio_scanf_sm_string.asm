
XLIB __stdio_scanf_sm_string

LIB asm_isspace

__stdio_scanf_sm_string:

   ; STRING STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; set-up: hl = state machine function address
   ;         bc = void *buffer (0 = assignment suppression)
   ;
   ; return: bc = void *buffer_ptr (address past last byte written)
      
   call asm_isspace
   
   ccf
   ret c                       ; reject whitespace
   
   inc c
   dec c
   jr z, b_0

w_0:
   
   ld (bc),a                   ; write to buffer
   inc bc
   
   ret

b_0:

   inc b
   djnz w_0
   
   ret
