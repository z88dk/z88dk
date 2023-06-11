
; char *_memupr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memupr__callee

EXTERN asm__memupr

_memupr__callee:

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

   jp asm__memupr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __memupr__callee
defc __memupr__callee = _memupr__callee
ENDIF

