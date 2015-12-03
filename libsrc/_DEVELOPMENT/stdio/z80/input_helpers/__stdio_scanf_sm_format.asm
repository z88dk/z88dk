
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_sm_format
PUBLIC __stdio_scanf_sm_format_pct

EXTERN asm_isspace, asm_strstrip

__stdio_scanf_sm_format:

   ; FORMAT STRING STATE MACHINE
   ; match stream chars against format string
   ;
   ; Qualify function for STDIO_MSG_EATC
   ;
   ; set-up: hl = state machine function address
   ;         de = void *format
   ;
   ; return: de = void *format_ptr (address of char rejected)

   ld c,a                      ; c = stream char
   ld a,(de)                   ; a = *format
   
   call asm_isspace
   jr nc, state_1t             ; start matching whitespace
   
   or a
   scf
   ret z                       ; stop at *format == '\0'
   
   cp '%'
   scf
   ret z                       ; stop at *format == '%'

   inc de                      ; format++
   
   cp c
   ret z                       ; if match, continue
   
   dec de
   
   scf                         ; reject mismatch
   ret

state_1t:

   ; advance format string past whitespace
   
   ex de,hl
   
   inc hl
   call asm_strstrip

   ex de,hl
   
   ld hl,state_1
   ld a,c                      ; a = stream char

state_1:

   ; consume whitespace chars from the stream
   
   call asm_isspace
   ret nc                      ; consume stream whitespace
   
   ld hl,__stdio_scanf_sm_format
   jp (hl)

__stdio_scanf_sm_format_pct:

   ; must consume a % from the stream
   
   dec b                          ; indicate to caller % seen
   ld hl,__stdio_scanf_sm_format  ; next time back to normal
   
   cp '%'
   ret z                       ; if required % is read
   
   inc b
   scf                         ; otherwise reject
   ret
