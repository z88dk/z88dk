
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream
;
; Write nmemb records of size bytes pointed at by ptr.  Output
; one record at a time and return the number of records
; successfully transmitted.
;
; ===============================================================

XLIB asm_fwrite
XDEF asm_fwrite_unlocked

LIB __stdio_verify_output, __stdio_send_output_raw_buffer_unchecked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_zc

asm_fwrite:

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

   call __stdio_lock_acquire
   jr c, immediate_error_enolck
   
   call asm_fwrite_unlocked
   jp __stdio_lock_release

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
   
   jp record_loop

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

immediate_error_enolck:

   push hl
   call error_enolck_zc
   pop hl

immediate_error:

   ; satisfy exit conditions for error
   ; carry set here
   
   ex de,hl
   
   ld hl,0
   ld c,l
   ld b,h
   
   ret
