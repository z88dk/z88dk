; ulong esxdos_f_fgetpos(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_f_fgetpos_fastcall

EXTERN _esxdos_ram_f_fgetpos_fastcall

defc _esxdos_dot_f_fgetpos_fastcall = _esxdos_ram_f_fgetpos_fastcall
