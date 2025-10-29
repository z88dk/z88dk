; struct esx_dirent_slice *esx_slice_dirent(struct esx_dirent *)

SECTION code_esxdos

PUBLIC asm_esx_slice_dirent

asm_esx_slice_dirent:

   ; return pointer to directory slice in dirent
   ;
   ; enter : hl = dirent *
   ;
   ; exit  : hl = dirent_slice *
   ;
   ; uses  : af, bc, hl
   
   inc hl
   
   xor a
   ld c,a
   ld b,a
   
   cpir
   ret
