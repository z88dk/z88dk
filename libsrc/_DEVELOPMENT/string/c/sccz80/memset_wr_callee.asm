
; void *memset_wr(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset_wr_callee

EXTERN asm_memset_wr

memset_wr_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

   jp asm_memset_wr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memset_wr_callee
defc _memset_wr_callee = memset_wr_callee
ENDIF

