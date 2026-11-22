
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_li

EXTERN __stdio_scanf_sm_i, __stdio_scanf_number_head
EXTERN l_inc_sp, asm_strtol, __stdio_scanf_number_tail_long

__stdio_scanf_li:

   ; %li converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer
   ;         bc = field width (0 means default)
   ;         hl = long *p
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix

   ; EAT WHITESPACE AND READ NUMBER INTO BUFFER

   push hl                     ; save int *p
   push de                     ; save void *buffer
   
   ld a,14                         ; fourteen octal digits + prefix needed to reach overflow
   ld hl,__stdio_scanf_sm_i        ; dec/hex/oct number state machine

   call __stdio_scanf_number_head
   jp c, l_inc_sp - 4              ; if stream error, pop twice and exit

   ; ASC-II NUMBER TO 32-BIT INTEGER
   
   pop hl                      ; hl = void *buffer
   ld bc,0                     ; auto select dec/hex/oct
   ld e,b
   ld d,b                      ; de = 0 = char **endp
   
   push ix
   call asm_strtol             ; dehl = long result
   pop ix
   pop bc                      ; bc = long *p
   
   ; WRITE RESULT TO LONG *P
   
   jp __stdio_scanf_number_tail_long
