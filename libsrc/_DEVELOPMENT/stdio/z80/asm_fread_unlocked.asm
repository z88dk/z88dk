
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

XLIB asm_fread_unlocked
XDEF fread_immediate_error_enolck

LIB __stdio_verify_input, __stdio_recv_input_raw_read

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

   call __stdio_verify_input   ; check that input from stream is ok
   jr c, immediate_error       ; if input from stream is not possible
   
   ld a,b
   or c
   jr z, immediate_success     ; if size == 0
   
   push hl                     ; save nmemb
   
record_loop:

   ; ix = FILE *
   ; de = char *p
   ; bc = size
   ; hl = records_remaining
   ; stack = nmemb
   
   ld a,h
   or l
   jr z, loop_done
   
   push bc
   push de
   push hl
   
   call __stdio_recv_input_raw_read
   
   pop de
   pop hl
   pop bc
   
   jr c, record_error
   
   add hl,bc                   ; p += size
   
   ex de,hl
   dec hl                      ; records_remaining--
   
   jr record_loop

record_error:

   ; bc'= number of bytes successfully read from stream
   ; ix = FILE *
   ; hl = char *p
   ; bc = size
   ; de = records_remaining
   ; stack = nmemb

   ex (sp),hl
   
   or a
   sbc hl,de                   ; hl = number of records successfully read
   
   pop de                      ; de = char *p
   
   exx
   push bc
   exx
   pop bc                      ; number of bytes read from incomplete record
   
   scf
   ret

loop_done:

   ; ix = FILE *
   ; de = char *p
   ; bc = size
   ; stack = nmemb

   pop hl
   ret

immediate_success:

   ; satisfy exit conditions for success
     
   ld l,c
   ld h,b                      ; hl = 0
   
   ret

fread_immediate_error_enolck:

   call error_enolck_zc

immediate_error:

   ; satisfy exit conditions for error
   ; carry set here
   
   ld hl,0
   ld c,l
   ld b,h
   
   ret

