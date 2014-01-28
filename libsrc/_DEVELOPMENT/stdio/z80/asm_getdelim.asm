
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)
;
; Reads characters from the stream up to and including the delimiter
; char and stores them in the buffer provided.
;
; The existing buffer is communicated by passing its start address
; in *lineptr and its *full* size in *n.  This buffer must have been
; allocated by malloc() as getdelim() will try to grow the buffer
; using realloc() if the amount of space provided is insufficient.
;
; If *lineptr == 0 or *n == 0, getdelim() will call malloc() to
; create an initial buffer.
;
; If delimiter > 255, the subroutine behaves as if there is no
; delimiter and stream chars will be read until either memory
; allocation fails or an error occurs on the stream.
;
; ===============================================================

XLIB asm_getdelim
XDEF asm_getdelim_unlocked, asm_getline, asm_getline_unlocked

LIB __stdio_verify_input, __stdio_recv_input_raw_eatc, __stdio_input_sm_getdelim
LIB __stdio_lock_acquire, __stdio_lock_release, error_enlock_zc, error_mc

asm_getline:

   ld bc,'\n'

asm_getdelim:

   ; enter : ix = FILE *
   ;         bc = int delimiter
   ;         de = size_t *n
   ;         hl = char **lineptr
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            *lineptr = address of buffer
   ;            *n       = size of buffer in bytes, including '\0'
   ;
   ;            hl = number of chars written to buffer (not including '\0')
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, error_enolck_zc
   
   call asm_getdelim_unlocked
   jp __stdio_lock_release

asm_getline_unlocked:

   ld bc,'\n'
   
asm_getdelim_unlocked:

   ; enter : ix = FILE *
   ;         bc = int delimiter
   ;         de = size_t *n
   ;         hl = char **lineptr
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            *lineptr = address of buffer
   ;            *n       = size of buffer in bytes, including '\0'
   ;
   ;            hl = number of chars written to buffer (not including '\0')
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   call __stdio_verify_input   ; check if input from stream is ok
   ret c                       ; if stream not readable
   
   push de                     ; save size_t *n
   push hl                     ; save char **lineptr

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   ex de,hl                    ; de = char *lineptr

   or d
   jr z, lineptr_0             ; if lineptr == 0
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = size_t n

   or h
   jr z, rejoin                ; if n == 0

   dec hl                      ; make room for terminating '\0'

rejoin:

   ; CREATE STATE MACHINE STRUCT ON STACK

   ; de = char *lineptr (0 if no buffer provided)
   ; bc = int delim_char
   ; hl = size_t n (0 if state machine should immediately realloc)
   ; stack = size_t *n, char **lineptr

   push de
   push bc
   push de
   
   ; RUN STATE MACHINE TO COLLECT CHARS INTO BUFFER
   
   ld c,l
   ld b,h                      ; bc = remaining_n
   
   ld hl,0
   add hl,sp
   ex de,hl                    ; de = & struct
   
   ld hl,__stdio_input_sm_getdelim
   
   exx
   
   ld hl,$ffff                 ; no limit on number of chars read from stream
   call __stdio_recv_input_raw_eatc

   push bc
   exx
   pop de
   
   ; IMPLEMENT EXIT CONDITIONS
   
   ; de = number of chars written to buffer (0 if error)
   ; bc = new char *lineptr (if new buffer was allocated)
   ; stack = size_t *n, char **lineptr, char *lineptr, void *junk, char *lineptr_ptr

   ld a,d
   or e
   jr z, stream_error          ; if no chars were written to buffer
   
   pop hl
   
   ld a,h
   or l
   jr z, buffer_allocated      ; if a new buffer was allocated
   
   ; no need to change lineptr or n
   
   ld (hl),0                   ; zero terminate the buffer
   
   ld hl,8
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ex de,hl                    ; hl = number of chars written to buffer
   
   or a
   ret

lineptr_0:

   ld hl,0                     ; setting n = 0 will cause malloc in state machine
   jr rejoin

buffer_allocated:

   ; new buffer was allocated so must modify lineptr and n

   ; de = number of chars written to buffer
   ; bc = new char *lineptr
   ; stack = size_t *n, char **lineptr, char *lineptr, void *junk

   pop hl
   pop hl
   pop hl                      ; hl = char **lineptr
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; *lineptr = new lineptr

   ld l,e
   ld h,d
   add hl,bc                   ; hl = & end of allocated buffer
   
   xor a
   ld (hl),a                   ; zero terminate the buffer

   pop hl                      ; hl = size_t *n
   inc de                      ; de = num chars written + 1 (room for '\0')

   ld (hl),e
   inc hl
   ld (hl),d                   ; *n = size of new buffer
   
   ex de,hl
   dec hl                      ; hl = number of chars written to buffer

   ret                         ; carry reset

stream_error:

   ; no chars written to buffer at all, must be an immediate stream error

   ; stack = size_t *n, char **lineptr, char *lineptr, void *junk, char *lineptr_ptr

   ld hl,10
   add hl,sp
   ld sp,hl                    ; clear up the stack
   
   jp error_mc
