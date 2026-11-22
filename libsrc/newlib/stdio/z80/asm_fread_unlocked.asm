
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)
;
; Read nmemb records of size bytes into address ptr.  Read
; one record at a time and return the number of records
; successfully read.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fread_unlocked
PUBLIC asm0_fread_unlocked

EXTERN l_ret, error_znc
EXTERN __stdio_verify_input, __stdio_recv_input_read

asm_fread_unlocked:

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

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   jr c, fread_immediate_error_ebadf
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_fread_unlocked:

   call __stdio_verify_input   ; check that input from stream is ok
   jr c, immediate_error       ; if input from stream is not possible
   
   ld a,b
   or c
   jp z, error_znc             ; if size == 0 report success
   
   push hl                     ; save nmemb

   push bc   
   exx
   pop hl                      ; hl'= size
   exx

next_record_loop:

   ; ix = FILE *
   ; de = char *p
   ; bc = size
   ; hl = records_remaining
   ; hl'= size
   ; stack = nmemb

   ld a,h
   or l
   jp z, l_ret - 1             ; if all records read, return success, hl = nmemb

   push bc
   push de
   push hl
   
   exx
   ld de,0                     ; de = num chars in record read
   exx
   
record_loop:

   ; ix = FILE *
   ; bc = num uncollected chars = max num chars to read
   ; de = void *buffer = destination address
   ; de'= total num chars read so far
   ; hl'= size
   ; stack = nmemb, size, char *p, records_remaining

   call __stdio_recv_input_read
   jr c, record_error          ; if eof or stream error
   
   exx
   
   sbc hl,de                   ; size == num chars read ?
   push hl                     ; save num uncollected chars
   add hl,de
   
   exx
   
   pop bc                      ; bc = num still uncollected chars
   jr c, record_error          ; if size < num chars read, should not happen

   jr nz, record_loop          ; if not all chars in record collected
   
record_complete:

   ; ix = FILE *
   ; hl'= size
   ; stack = nmemb, size, char *p, records_remaining

   pop de                      ; de = records_remaining
   pop hl                      ; hl = char *p
   pop bc                      ; bc = size
   
   add hl,bc                   ; p += size
   
   ex de,hl
   dec hl                      ; records_remaining--
   
   jr next_record_loop

record_error:

   pop de
   pop hl
   pop bc

   ; ix = FILE *
   ; hl = char *p
   ; bc = size
   ; de = records_remaining
   ; de'= number of bytes successfully read from record
   ; stack = nmemb

   ex (sp),hl
   
   or a
   sbc hl,de                   ; hl = number of records successfully read
   
   pop de                      ; de = char *p
   
   exx
   push de
   exx
   pop bc                      ; number of bytes read from incomplete record
   
   scf
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   PUBLIC fread_immediate_error_ebadf
   fread_immediate_error_ebadf:

ELSE

   PUBLIC fread_immediate_error_enolck
   EXTERN error_enolck_zc
   
   fread_immediate_error_enolck:
   
      call error_enolck_zc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

immediate_error:

   ; satisfy exit conditions for error
   ; carry set here
   
   ld hl,0
   ld c,l
   ld b,h
   
   ret
