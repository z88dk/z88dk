; int esxdos_f_close(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_f_close

EXTERN _esxdos_ram_f_close

defc _esxdos_dot_f_close = _esxdos_ram_f_close
