; ulong esxdos_f_fgetpos(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_f_fgetpos

EXTERN _esxdos_ram_f_fgetpos

defc _esxdos_dot_f_fgetpos = _esxdos_ram_f_fgetpos
