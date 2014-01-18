
XLIB __stdio_scanf_c

LIB __stdio_recv_input_read, l_saturated_inc_hl

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

   ; SKIP CHARS FROM STREAM

;; 1. fseek to get position
;; 2. push position
;; 3. fseek ahead by width bytes
;; 4. subtract old position from new position
;; 5. add to stream bytes consumed so far
;; 6. return error if fseek failed,
***

