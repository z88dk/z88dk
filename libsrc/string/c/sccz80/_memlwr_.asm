
; char *_memlwr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memlwr_

EXTERN asm__memlwr

_memlwr_:

   pop de
   pop bc
   pop hl

   push hl
   push bc
   push de

   jp asm__memlwr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __memlwr_
defc __memlwr_ = _memlwr_
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ____memlwr_
defc ____memlwr_ = _memlwr_
ENDIF

