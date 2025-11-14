
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_c

EXTERN STDIO_SEEK_CUR

EXTERN __stdio_recv_input_read
EXTERN l_addu_hl_bc, asm0_fseek_unlocked

__stdio_scanf_c:

   ; %c converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         bc = field width (0 means default)
   ;         hl = void *p (0 means assignment suppression)
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix

   ; DEFAULT FIELD WIDTH
   
   ld a,b
   or c
   jr nz, width_specified
   
   inc c                         ; default is one char

width_specified:

   ld a,h
   or l
   jr z, assignment_suppressed

   ; READ CHARS FROM STREAM
   
   ex de,hl                      ; de = void *buffer
   call __stdio_recv_input_read
   ret c                         ; any kind of error is a failure
   
   exx
   inc hl                        ; number of assigned items++
   exx

   ret

assignment_suppressed:

   ; SEEK PAST CHARS FROM STREAM
   ; forward seek is always successful even if it passes end of file

   ld l,c
   ld h,b
   ld de,0                     ; dehl = forward seek offset

   ld c,STDIO_SEEK_CUR
   
   push hl                     ; save forward seek offset

   exx
   
   push de                     ; save chars read from stream
   push hl                     ; save items assigned

   exx
   
   call asm0_fseek_unlocked
   
   pop de                      ; de = items assigned
   pop hl                      ; hl = chars read from stream
   pop bc                      ; bc = forward seek offset
   
   call l_addu_hl_bc
   
   ex de,hl
   exx

   or a
   ret
