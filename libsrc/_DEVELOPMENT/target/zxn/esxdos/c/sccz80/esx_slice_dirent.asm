; struct esx_dirent_slice *esx_slice_dirent(struct esx_dirent *)

SECTION code_esxdos

PUBLIC esx_slice_dirent

EXTERN asm_esx_slice_dirent

defc esx_slice_dirent = asm_esx_slice_dirent

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_slice_dirent
defc _esx_slice_dirent = esx_slice_dirent
ENDIF

