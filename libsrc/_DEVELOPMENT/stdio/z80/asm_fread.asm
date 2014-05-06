
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

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_fread

LIB asm0_fread_unlocked, __stdio_lock_release

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   LIB __stdio_verify_valid_lock, fread_immediate_error_ebadf

   call __stdio_verify_valid_lock
   jp c, fread_immediate_error_ebadf

ELSE

   LIB __stdio_lock_acquire, fread_immediate_error_enolck
   
   call __stdio_lock_acquire
   jp c, fread_immediate_error_enolck

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   call asm0_fread_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_fread

LIB asm_fread_unlocked

asm_fread:

   jp asm_fread_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
