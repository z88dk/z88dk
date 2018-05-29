; struct esx_dirent_slice *esx_slice_dirent(struct esx_dirent *)

SECTION code_esxdos

PUBLIC _esx_dirent_slice_fastcall

EXTERN asm_esx_slice_dirent

defc _esx_dirent_slice_fastcall = asm_esx_slice_dirent
