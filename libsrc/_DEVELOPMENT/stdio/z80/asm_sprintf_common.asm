
XLIB asm_sprintf_common

LIB __stdio_varg_3, __stdio_nextarg_de

asm_sprintf_common:

   call __stdio_varg_3         ; de = char *s

   push hl
   exx
   pop hl

   call __stdio_nextarg_de     ; de = char *format

   ld c,l
   ld b,h                      ; bc = var *arg

   ret
