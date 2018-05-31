; struct esx_dirent_slice *esx_slice_dirent(struct esx_dirent *)

SECTION code_esxdos

PUBLIC _esx_slice_dirent

EXTERN asm_esx_slice_dirent

_esx_slice_dirent:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_slice_dirent
