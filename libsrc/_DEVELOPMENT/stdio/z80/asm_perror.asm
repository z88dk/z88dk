
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void perror(const char *s)
;
; Write error message to stderr.
;
; ===============================================================

XLIB asm_perror

LIB asm_strerror, asm_fputs_unlocked, asm_fputc_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release
XREF __FILE_STDERR, _errno

asm_perror:

   ; enter : hl = char *s
   ;
   ; exit  : ix = FILE *stderr
   ;
   ; uses  : all except ix
   
   ld ix,__FILE_STDERR
   call __stdio_lock_acquire   ; so that output is contiguous
   
   ld a,h
   or l
   jr z, errno_string          ; if no user string
   
   ld a,(hl)
   or a
   jr z, errno_string          ; if no user string

   ; output user string
   
   call asm_fputs_unlocked
   
   ld hl,separator_s
   call asm_fputs_unlocked

errno_string:
   
   ; output errno string
   
   ld hl,(_errno)
   call asm_strerror
   call asm_fputs_unlocked
   
   ld e,'\n'
   call asm_fputc_unlocked
   
   jp __stdio_lock_release

separator_s:

   defm ": "
   defb 0
