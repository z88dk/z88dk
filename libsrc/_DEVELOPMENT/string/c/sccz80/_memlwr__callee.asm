
; char *_memlwr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memlwr__callee

EXTERN asm__memlwr

_memlwr__callee:

IF __CPU_GBZ80__
   pop de	;ret
   pop bc	;n
   pop hl	;p
   push de
ELSE
   pop hl
   pop bc
   ex (sp),hl
ENDIF

   jp asm__memlwr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __memlwr__callee
defc __memlwr__callee = _memlwr__callee
ENDIF

