
PUBLIC __stdio_file_init
PUBLIC __0_stdio_file_init

EXTERN mtx_recursive

EXTERN error_ebadf_zc, l_setmem_hl, asm_mtx_init

__stdio_file_init:

   ; initialize a FILE structure
   ;
   ; enter : hl = FILE *
   ;
   ; uses  : af, c, hl

   call __0_stdio_file_init
   
   ld c,mtx_recursive
   jp asm_mtx_init

__0_stdio_file_init:

   ld (hl),195
   inc hl
   ld (hl),badfile % 256
   inc hl
   ld (hl),badfile / 256
   inc hl

   xor a
   call l_setmem_hl - 8

   ret

badfile:

   jp error_ebadf_zc
