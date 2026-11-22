; unsigned char esx_ide_get_lfn(struct esx_lfn *dir, struct esx_cat_entry *query)

SECTION code_esxdos

PUBLIC esx_ide_get_lfn_callee

EXTERN asm_esx_ide_get_lfn

esx_ide_get_lfn_callee:

   pop hl
	pop de
	ex (sp),hl

   jp asm_esx_ide_get_lfn
