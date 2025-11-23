; struct esx_dirent_slice *esx_slice_dirent(struct esx_dirent *)

SECTION code_esxdos

PUBLIC _esx_slice_dirent_fastcall

EXTERN asm_esx_slice_dirent

defc _esx_slice_dirent_fastcall = asm_esx_slice_dirent
