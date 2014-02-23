
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)
;
; Write nmemb records of size bytes pointed at by ptr.  Output
; one record at a time and return the number of records
; successfully transmitted.
;
; ===============================================================

XLIB asm_fwrite

LIB asm_fwrite_unlocked, fwrite_immediate_error_enolck
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_zc

asm_fwrite:

   ; enter : ix = FILE *
   ;         hl = char *ptr
   ;         bc = size
   ;         de = nmemb
   ;
   ; exit  : ix = FILE *
   ;         hl = number of records successfully transmitted
   ;
   ;         success
   ;
   ;            de = char *p = ptr following all records
   ;            bc = size
   ;            carry reset
   ;
   ;         fail
   ;
   ;            de = char *p (ptr to current record not transmitted completely)
   ;            bc = number of bytes in last incomplete record transmitted
   ;            carry set, errno set
   ;
   ; uses  : all except ix

   call __stdio_lock_acquire
   jr c, fwrite_immediate_error_enolck
   
   call asm_fwrite_unlocked
   jp __stdio_lock_release
