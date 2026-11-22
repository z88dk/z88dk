
; ===============================================================
; Jan 2014
; ===============================================================
; 
; FILE *fmemopen(void *buf, size_t size, const char *mode)
;
; Associate a memory buffer that does not grow with a stream.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fmemopen

EXTERN asm__fmemopen

asm_fmemopen:

   ; enter : hl = void *buf
   ;         bc = size_t size
   ;         de = char *mode
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            ix = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

   push bc
   push hl
   
   ld hl,0
   add hl,sp                   ; hl = void **bufp

   ld c,l
   ld b,h
   
   inc bc
   inc bc                      ; bc = size_t *sizep
   
   ld a,$a0                    ; mode mask disallows buffer growth
   call asm__fmemopen
   
   pop bc
   pop bc                      ; clear stack
   
   ret
