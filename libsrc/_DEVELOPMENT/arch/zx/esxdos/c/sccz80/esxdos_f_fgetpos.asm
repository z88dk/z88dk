; ulong esxdos_f_fgetpos(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_fgetpos_fastcall

EXTERN asm_esxdos_f_fgetpos

defc esxdos_f_fgetpos_fastcall = asm_esxdos_f_fgetpos
