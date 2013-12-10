
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strndup(const char *s, size_t n)
;
; Copy at most n chars from string s into an allocated block of
; memory and return a pointer to the newly allocated block.
; User must deallocate the returned ptr with free().  Allocated
; block will be at most n+1 bytes.
;
; ===============================================================

XLIB strndup_callee
XDEF asm_strndup

LIB asm_strlen, l_minu_bc_hl, asm0_strdup

strndup_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_strndup:

   ; enter : hl = char *s
   ;         bc = size_t n
   ;
   ; exit : 
   ;         success
   ;
   ;           carry reset
   ;           hl = char *str (dup), must deallocate with free()
   ;           de = ptr to NUL at end of str (dup)
   ;
   ;        fail (no memory)
   ;
   ;           carry set, errno = enomem
   ;           hl = 0
   ;           de = char *s
   ;           bc = min(strlen(s)+1, n+1)
   ;
   ; uses  : af, bc, de, hl
   
   push hl                     ; save char *s
   
   call asm_strlen             ; hl = strlen(s)
   call l_minu_bc_hl           ; hl = min(strlen, n)
   inc hl                      ; include space for NUL
   
   jp asm0_strdup
