
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_file_destructor

EXTERN asm_mtx_destroy, __0_stdio_file_constructor, l_offset_ix_de

__stdio_file_destructor:

   ; invalidates the FILE
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE * (now dead FILE)
   ;
   ; uses  : af, bc, de, hl
   
   ld hl,7
   call l_offset_ix_de         ; hl = & FILE->mtx, de = FILE *
   
   ex de,hl
   call __0_stdio_file_constructor

   ex de,hl                    ; hl = & FILE->mtx
   jp asm_mtx_destroy
