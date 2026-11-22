; void ts_vmod(unsigned char mode)

SECTION code_clib
SECTION code_arch

PUBLIC _ts_vmod

EXTERN asm_ts_vmod

_ts_vmod:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ts_vmod
