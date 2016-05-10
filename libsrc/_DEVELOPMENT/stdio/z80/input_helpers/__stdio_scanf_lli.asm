
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_lli

EXTERN __stdio_scanf_sm_i, __stdio_scanf_number_head, l_inc_sp
EXTERN asm_strtoll, __stdio_scanf_number_tail_longlong

__stdio_scanf_lli:

   ; %lli converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer
   ;         bc = field width (0 means default)
   ;         hl = longlong *p
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix

   ; EAT WHITESPACE AND READ NUMBER INTO BUFFER

   push hl                     ; save longlong *p
   push de                     ; save void *buffer
   
   ld a,25                         ; 25 decimal digits + prefix needed to reach overflow
   ld hl,__stdio_scanf_sm_i        ; dec/hex/oct number state machine

   call __stdio_scanf_number_head
   jp c, l_inc_sp - 4              ; if stream error, pop twice and exit

   ; SAVE SCANF ACCOUNTING
   
   pop hl                      ; hl = void *buffer
   pop de                      ; de = longlong *p
   
   exx
   push de                     ; save chars consumed
   push hl                     ; save items assigned
   exx
   
   push de                     ; save longlong *p
   
   ; ASC-II DECIMAL TO 64-BIT INTEGER

   ; hl = void *buffer
   
   ld bc,0                     ; auto select dec/hex/oct
   
   ld e,b
   ld d,b                      ; endp = 0
   
   push ix
   
   call asm_strtoll            ; dehl'dehl = result
   
   pop ix
   pop bc                      ; bc = longlong *p
   
   ; WRITE RESULT TO LONGLONG *P
   
   jp __stdio_scanf_number_tail_longlong
