
XLIB asm_fprintf_common

LIB __stdio_varg_3, __stido_nextarg_de

asm_fprintf_common:

   call __stdio_varg_3
   
   ld ixl,e
   ld ixh,d                    ; ix = FILE *
   
   call __stdio_nextarg_de     ; de = char *format
   
   ld c,l
   ld b,h                      ; bc = void *arg_list
   
   ret
