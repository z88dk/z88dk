
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_file_constructor
PUBLIC __0_stdio_file_constructor

EXTERN mtx_recursive
EXTERN error_ebadf_zc, l_setmem_hl, asm_mtx_init

__stdio_file_constructor:

   ; initialize a FILE structure
   ;
   ; enter : hl = FILE *
   ;
   ; uses  : af, c, hl

   call __0_stdio_file_constructor
   
   ld c,mtx_recursive
   jp asm_mtx_init

__0_stdio_file_constructor:

   ld (hl),195
   inc hl
   ld (hl),error_ebadf_zc % 256
   inc hl
   ld (hl),error_ebadf_zc / 256
   inc hl

   xor a
   jp l_setmem_hl - 8
