
; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_string

PUBLIC asm_bcopy

EXTERN asm_memcpy

defc asm_bcopy = asm_memcpy

   ; enter : bc = size_t len
   ;         hl = void *s2 = src
   ;         de = void *s1 = dst
   ;
   ; exit  : hl = void *s1 = dst
   ;         de = ptr in s1 to one byte past last byte copied
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

