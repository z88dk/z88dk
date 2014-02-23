
XLIB __stdio_file_destroy

LIB asm_mtx_destroy, __0_stdio_file_init

__stdio_file_destroy:

   ; releases the mutex associated with the FILE
   ; and invalidates the FILE
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE * (now dead FILE)
   ;
   ; uses  : af, bc, de, hl
   
   ld e,ixl
   ld d,ixh                    ; de = FILE *
   
   ld hl,7
   add hl,de                   ; hl = & FILE->mtx
   
   ex de,hl
   call __0_stdio_file_init

   ex de,hl
   jp asm_mtx_destroy
