
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_bb

EXTERN __stdio_scanf_sm_binary, __stdio_scanf_number_head
EXTERN l_inc_sp, asm__strtou, __stdio_scanf_number_tail_int

__stdio_scanf_bb:

   ; %B converter called from vfscanf()
   ; non-standard, reads binary number
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
   
   ld a,19                        ; nineteen binary digits + prefix needed to reach overflow
   ld hl,__stdio_scanf_sm_binary  ; binary number state machine

   call __stdio_scanf_number_head
   jp c, l_inc_sp - 4             ; if stream error, pop twice and exit

   ; ASC-II BINARY TO 16-BIT INTEGER
   
   pop hl                      ; hl = void *buffer
   ld bc,2                     ; base 2 conversion
   ld e,b
   ld d,b                      ; de = 0 = char **endp
   
   call asm__strtou
   pop de                      ; de = int *p
   
   ; WRITE RESULT TO INT *P
   
   jp __stdio_scanf_number_tail_int
