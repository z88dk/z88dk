
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int feof(FILE *stream)
;
; Return non-zero if eof indicator is set on stream.
;
; ===============================================================

XLIB asm_feof
XDEF asm_feof_unlocked

LIB __stdio_lock_acquire, __stdio_lock_release, error_enlock_zc

asm_feof:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0 and Z flag set if not eof
   ;            hl = non-zero and NZ flag set if eof
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno = enolck
   ;
   ; uses  : af, bc, de, hl

   call __stdio_lock_acquire
   jp c, error_enolck_zc
   
   call asm_feof_unlocked
   jp __stdio_lock_release

asm_feof_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if stream is at eof
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is not at eof
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl

   ld a,(ix+3)
   and $10                     ; eof bit only
   
   ld l,a
   ld h,a
   
   ret
