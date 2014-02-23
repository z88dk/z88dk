
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)
;
; Read nmemb records of size bytes into address ptr.  Read
; one record at a time and return the number of records
; successfully read.
;
; ===============================================================

XLIB asm_fread

LIB asm_fread_unlocked, fread_immediate_error_enolck
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_zc

asm_fread:

   ; enter : ix = FILE *
   ;         de = char *ptr
   ;         bc = size
   ;         hl = nmemb
   ;
   ; exit  : ix = FILE *
   ;         hl = number of records successfully read
   ;
   ;         success
   ;
   ;            de = char *p = ptr following all records
   ;            bc = size
   ;            carry reset
   ;
   ;         fail
   ;
   ;            de = char *p (ptr to current record not read completely)
   ;            bc = number of bytes of incomplete record read
   ;            carry set, errno set
   ;
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, fread_immediate_error_enolck
   
   call asm_fread_unlocked
   jp __stdio_lock_release
