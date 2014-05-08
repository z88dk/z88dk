
PUBLIC error_emfile_zc

EXTERN __EMFILE

EXTERN errno_zc

   pop hl
   
error_emfile_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=EMFILE

   ld hl,__EMFILE
   jp errno_zc
