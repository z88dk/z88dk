
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ferror(FILE *stream)
;
; Return non-zero if error indicator is set on stream.
;
; ===============================================================

XLIB asm_ferror
XDEF asm_ferror_unlocked

LIB __stdio_lock_acquire, __stdio_lock_release, error_enlock_zc

asm_ferror:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0 and Z flag set if no error
   ;            hl = non-zero and NZ flag set if error
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
   
   call asm_ferror_unlocked
   jp __stdio_lock_release

asm_ferror_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry reset
   ;
   ;         if stream in error state
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is error free
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl

   ld a,(ix+3)
   and $08                     ; err bit only
   
   ld l,a
   ld h,a
   
   ret
