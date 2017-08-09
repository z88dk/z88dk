; int esxdos_f_sync(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_f_sync

EXTERN _esxdos_ram_f_sync

defc _esxdos_dot_f_sync = _esxdos_ram_f_sync
