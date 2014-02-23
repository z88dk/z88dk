
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fseek(FILE *stream, long offset, int whence)
;
; Move to new position in file indicated by the signed value
; offset.
;
; If whence is:
;
; STDIO_SEEK_SET (0) : offset is relative to start of file
; STDIO_SEEK_CUR (1) : offset is relative to current position
; STDIO_SEEK_END (2) : offset is relative to end of file
;
; For STDIO_SEEK_SET, offset is treated as unsigned.
;
; ===============================================================

XLIB asm_fseek

LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fseek:

   ; enter :   ix = FILE *
   ;         dehl = offset
   ;            c = whence
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = -1
   ;           carry set
   ;
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fseek_unlocked
   jp __stdio_lock_release
