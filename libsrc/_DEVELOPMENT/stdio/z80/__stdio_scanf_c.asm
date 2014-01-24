
XLIB __stdio_scanf_c

LIB __stdio_recv_input_read, l_saturated_inc_hl, l_saturated_add_hl_bc, l_jpix

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
   
   ld bc,1                     ; default is one char

width_specified:

   ld a,h
   or l
   jr z, assignment_suppressed

   ; READ CHARS FROM STREAM
   
   ex de,hl                      ; de = void *buffer
   call __stdio_recv_input_read
   ret c                         ; any kind of error is a failure
   
   exx
   call l_saturated_inc_hl     ; number of assigned items++
   exx
   
   or a
   ret

assignment_suppressed:

   ; SEEK PAST CHARS FROM STREAM
   ; forward seek is always successful even if it passes end of file

   ld l,c
   ld h,b
   ld de,0                     ; dehl = forward seek offset
   
   ld a,STDIO_MSG_SEEK
   ld c,STDIO_SEEK_CUR
   
   push hl                     ; save forward seek offset
   
   exx
   
   push de                     ; save chars read from stream
   push hl                     ; save items assigned
   
   call l_jpix
   
   pop de                      ; de = items assigned
   pop hl                      ; hl = chars read from stream
   
   pop bc                      ; bc = forward seek offset
   
   call l_saturated_add_hl_bc
   ex de,hl
   
   exx

   or a
   ret
