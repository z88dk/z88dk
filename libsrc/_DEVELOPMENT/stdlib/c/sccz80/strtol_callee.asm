
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtol_callee

EXTERN asm_strtol

strtol_callee:
IF __CPU_GBZ80__
   pop af	;return
   pop bc	;radix
   pop de	;endptr
   pop hl	;nptr
   push af
ELSE
   pop hl
   pop bc
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_strtol

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtol_callee
defc _strtol_callee = strtol_callee
ENDIF

