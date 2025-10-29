
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_getdelim

EXTERN asm0_getdelim_unlocked, __stdio_lock_release

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid_lock

   call __stdio_verify_valid_lock
   ret c

ELSE

   EXTERN __stdio_lock_acquire, error_enolck_mc

   call __stdio_lock_acquire
   jp c, error_enolck_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   call asm0_getdelim_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_getdelim

EXTERN asm_getdelim_unlocked

defc asm_getdelim = asm_getdelim_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
