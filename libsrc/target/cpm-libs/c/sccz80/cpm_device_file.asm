; FILE *cpm_device_file(const char *name)  sccz80 fastcall (hl = name)

SECTION code_clib
SECTION code_arch

PUBLIC cpm_device_file

EXTERN asm_cpm_device_file

defc cpm_device_file = asm_cpm_device_file
