
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)
;
; Reads characters from the stream up to and including the delimiter
; char and stores them in the buffer provided, then zero terminates
; the buffer.
;
; The existing buffer is communicated by passing its start address
; in *lineptr and its size in *n.  This buffer must have been
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

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_getdelim_unlocked
PUBLIC asm0_getdelim_unlocked

EXTERN error_mc, asm_b_vector_resize, l_ltu_bc_hl, __stdio_recv_input_raw_getc
EXTERN __stdio_verify_input, __stdio_recv_input_raw_eatc, __stdio_input_sm_getdelim

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_getdelim_unlocked:

   call __stdio_verify_input   ; check if input from stream is ok
   ret c                       ; if stream not readable
   
   push de                     ; save size_t *n
   push hl                     ; save char **lineptr

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   ex de,hl                    ; de = char *line
   
   ld a,d
   or e
   jr nz, line_not_zero        ; if line != 0
   
   ; if char *line == 0, make sure the size is 0 too
   
   ; hl = size_t *n
   ; de = 0
   
   ld (hl),a
   inc hl
   ld (hl),a                   ; *n = 0, to prevent leaks
   
   ld l,a
   ld h,a
   
   jr create_vector

line_not_zero:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = size_t n

create_vector:

   ; create a b_vector on the stack

   push hl
   ld hl,$ffff
   ex (sp),hl                  ; push vector.max_size
   push hl                     ; push vector.capacity
   push hl                     ; push vector.size
   push de                     ; push vector.data

   ; reserve one byte in the vector for zero terminator
   
   ld hl,0
   add hl,sp                   ; hl = vector *

   push bc                     ; save delim_char
   
   ld de,1
   call asm_b_vector_resize    ; vector.size = 1
   
   pop bc                      ; bc = delim_char
   jr c, error_exit            ; if vector size failed
   
   ; zero terminate initial vector
   
   pop hl                      ; hl = vector.data
   push hl
   
   xor a
   ld (hl),a
   
   ; read chars from the stream
   
   ld l,a
   ld h,a
   add hl,sp
   ex de,hl                    ; de = vector *

   ld hl,__stdio_input_sm_getdelim
   
   ; bc = delim_char
   ; de = vector *
   ; hl = state machine
   
   exx
   
   ld hl,$ffff                 ; no limit on number of chars read from stream
   call __stdio_recv_input_raw_eatc

   exx
   
   dec l                       ; if l == 1, state machine says remove delim char
   jr nz, no_delim

remove_delim:

   ; delim char is still on the stream
      
   call __stdio_recv_input_raw_getc  ; throw delim away

   exx
   ld bc,1
   exx

no_delim:

   ; loose ends prior to exit
   
   ; bc'= 0 if error
   ; stack = size_t *n, char **lineptr, vector.max_size,
   ;         vector.capacity, vector.size, vector.data

   pop bc                      ; bc = vector.data = char *line, possibly new address
   pop de                      ; de = num bytes written including '\0'
   pop hl
   pop hl
   pop hl                      ; hl = char **lineptr
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; *lineptr = line
   
   pop hl                      ; hl = size_t *n
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = old_n

   ex de,hl                    ; hl = new_n
   
   call l_ltu_bc_hl
   
   dec hl                      ; hl = num bytes written less the '\0'
   jr nc, check_error          ; if bc >= hl, old_n >= new_n

   ; new_n is larger so store new size
   
   inc hl
   ex de,hl
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; *n = new_n
   
   ex de,hl
   dec hl
   
   or a
   ret

check_error:

   exx
   ld a,b
   or c
   exx
   
   ret nz
   jp error_mc

error_exit:

   ; stack = size_t *n, char **lineptr, b_vector_t

   ld hl,12
   add hl,sp
   ld sp,hl                    ; repair stack
   
   jp error_mc
