
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strdup(const char * s)
;
; Copy string s into an allocated block of memory and return
; a pointer to the newly allocated block.  User must deallocate
; the returned ptr with free().
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_strdup
XDEF asm0_strdup

LIB asm_strlen, malloc, error_enomem_zc, l_saturated_inc_hl

asm_strdup:

   ; enter: hl = char *s
   ;
   ; exit : 
   ;        success
   ;
   ;           carry reset
   ;           hl = char *str (dup), must deallocate with free()
   ;           de = ptr to terminating 0 at end of str (dup)
   ;
   ;        fail (insufficient memory)
   ;
   ;           carry set, errno = enomem
   ;           hl = 0
   ;           de = char *s
   ;           bc = strlen(s)+1
   ;
   ; uses : af, bc, de, hl

   push hl                     ; save char *s
   
   call asm_strlen             ; hl = length

asm0_strdup:

   inc hl                      ; include space for NUL
 
   push hl
   call malloc                 ; malloc(hl bytes)
   pop bc                      ; bc = length
   
   pop de                      ; de = char *s
   jp c, error_enomem_zc
   
   push hl                     ; save char *str (dup)

   ex de,hl
   ldir
   
   ; ensure terminating NUL written, strndup requires it
   
   dec de
   xor a
   ld (de),a
   
   pop hl
   ret
