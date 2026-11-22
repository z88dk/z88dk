
; unsigned long cpm_get_offset(void *p)
; fastcall

SECTION code_clib
SECTION code_arch

PUBLIC cpm_get_offset

EXTERN asm_cpm_get_offset

defc cpm_get_offset = asm_cpm_get_offset
