
; char *_memstrcpy_(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memstrcpy__callee

EXTERN asm__memstrcpy

_memstrcpy__callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm__memstrcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __memstrcpy__callee
defc __memstrcpy__callee = _memstrcpy__callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ____memstrcpy__callee
defc ____memstrcpy__callee = _memstrcpy__callee
ENDIF

