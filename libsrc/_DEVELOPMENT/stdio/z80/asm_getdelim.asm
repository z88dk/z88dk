
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

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_getdelim

LIB asm_getdelim_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_zc

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_getdelim

LIB asm_getdelim_unlocked

asm_getdelim:

   jp asm_getdelim_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
