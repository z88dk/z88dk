
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)
;
; Write nmemb records of size bytes pointed at by ptr.  Output
; one record at a time and return the number of records
; successfully transmitted.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fwrite_unlocked
PUBLIC asm0_fwrite_unlocked

EXTERN __stdio_verify_output, __stdio_send_output_raw_buffer_unchecked, error_enolck_zc

asm_fwrite_unlocked:

   ; enter : ix = FILE *
   ;         hl = char *ptr
   ;         bc = size
   ;         de = nmemb
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = number of records successfully transmitted
   ;            de = char *p = ptr following all records
   ;            bc = size
   ;            carry reset
   ;
   ;         fail
   ;
   ;            de = char *p (ptr to current record not transmitted completely)
   ;            bc = number of bytes in last incomplete record transmitted
   ;            hl = number of records successfully transmitted
   ;            carry set, errno set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   push hl
   call __stdio_verify_valid
   pop hl
   
   jr c, fwrite_immediate_error_ebadf

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_fwrite_unlocked:

   call __stdio_verify_output  ; check that output on stream is ok
   jr c, immediate_error       ; if output on stream not possible

   ld a,b
   or c
   jr z, immediate_success     ; if size == 0

   push de                     ; save nmemb
   
record_loop:

   ; ix = FILE *
   ; hl = char *p
   ; bc = size
   ; de = records_remaining
   ; stack = nmemb

   ld a,d
   or e
   jr z, loop_done

   push bc
   push de
   push hl

   call __stdio_send_output_raw_buffer_unchecked
   
   pop hl
   pop de
   pop bc
   
   jr c, record_error
   
   add hl,bc                   ; hl = ptr += size
   dec de                      ; records_remaining--
   
   jr record_loop

record_error:

   ; hl' = number of bytes in current record successfully written
   ; ix = FILE *
   ; hl = char *p
   ; bc = size
   ; de = records_remaining
   ; stack = nmemb

   ex (sp),hl
   
   or a
   sbc hl,de                   ; hl = number of records successfully transmitted
   
   pop de                      ; de = char *p
   
   exx
   push hl
   exx
   pop bc                      ; bc = num bytes of last record successfully transmitted

   scf
   ret

loop_done:

   ; ix = FILE *
   ; hl = char *p
   ; bc = size
   ; de = records_remaining
   ; stack = nmemb

   ex de,hl
   pop hl
   
   ret

immediate_success:

   ; satisfy exit conditions for success
   
   ex de,hl
   
   ld l,c
   ld h,b                      ; hl = 0
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   PUBLIC fwrite_immediate_error_ebadf
   fwrite_immediate_error_ebadf:

ELSE

   PUBLIC fwrite_immediate_error_enolck
   EXTERN error_enolck_zc

fwrite_immediate_error_enolck:

   push hl
   call error_enolck_zc
   pop hl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

immediate_error:

   ; satisfy exit conditions for error
   ; carry set here
   
   ex de,hl
   
   ld hl,0
   ld c,l
   ld b,h
   
   ret
