; int esxdos_f_sync(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_f_sync_fastcall

EXTERN _esxdos_ram_f_sync_fastcall

defc _esxdos_dot_f_sync_fastcall = _esxdos_ram_f_sync_fastcall
