
; int ffs(int i)

SECTION code_clib
SECTION code_string

PUBLIC ffs

EXTERN asm_ffs

defc ffs = asm_ffs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ffs
defc _ffs = ffs
ENDIF

