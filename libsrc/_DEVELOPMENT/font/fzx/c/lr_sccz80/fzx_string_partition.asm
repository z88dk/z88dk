
; char *fzx_string_partition(char *s, uint width)

XLIB fzx_string_partition

LIB asm_fzx_string_partition

fzx_string_partition:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_fzx_string_partition
