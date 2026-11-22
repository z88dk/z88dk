
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_i

EXTERN __stdio_scanf_sm_i, __stdio_scanf_number_head
EXTERN l_inc_sp, asm__strtoi, __stdio_scanf_number_tail_int

__stdio_scanf_i:

   ; %i converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer
   ;         bc = field width (0 means default)
   ;         hl = int *p
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix

   ; EAT WHITESPACE AND READ NUMBER INTO BUFFER

   push hl                     ; save int *p
   push de                     ; save void *buffer
   
   ld a,9                          ; nine hex digits + prefix needed to reach overflow in worst case
   ld hl,__stdio_scanf_sm_i        ; dec/hex/oct number state machine

   call __stdio_scanf_number_head
   jp c, l_inc_sp - 4              ; if stream error, pop twice and exit

   ; ASC-II NUMBER TO 16-BIT INTEGER
   
   pop hl                      ; hl = void *buffer
   ld bc,0                     ; auto select dec/hex/oct conversion
   ld e,b
   ld d,b                      ; de = 0 = char **endp
   
   call asm__strtoi
   pop de                      ; de = int *p
   
   ; WRITE RESULT TO INT *P
   
   jp __stdio_scanf_number_tail_int
