; int esxdos_f_sync(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_sync

EXTERN asm_esxdos_f_sync

defc esxdos_ram_f_sync = asm_esxdos_f_sync
