
XLIB __stdio_file_init

LIB error_ebadf_zc, l_setmem_hl

__stdio_file_init:

   ; initialize a FILE structure
   ;
   ; enter : hl = FILE *
   ;
   ; uses  : af, c, hl

   ld (hl),195
   inc hl
   ld (hl),badfile % 256
   inc hl
   ld (hl),badfile / 256
   inc hl

   xor a
   call l_setmem_hl - 8
   
   ld c,mtx_recursive
   jp asm_mtx_init

badfile:

   jp error_ebadf_zc
