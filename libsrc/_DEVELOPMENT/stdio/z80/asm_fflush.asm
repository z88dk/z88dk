
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fflush(FILE *stream)
;
; Flush the stream.  For streams most recently written to, this
; means sending any buffered output to the device.  For streams
; most recently read from, this means seeking backward to unread
; any unconsumed input.
;
; If stream == 0, all streams are flushed.
;
; ===============================================================

XLIB asm_fflush

LIB asm0_fflush_unlocked, asm__fflushall
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fflush:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if lock could not be acquired
   ;         if stream is in error state
   ;         if write failed
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   ld a,ixl
   or ixh
   jp z, asm__fflushall

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm0_fflush_unlocked
   jp __stdio_lock_release
