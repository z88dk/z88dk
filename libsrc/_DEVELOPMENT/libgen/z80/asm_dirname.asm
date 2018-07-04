; char *dirname(char *path)

SECTION code_string

PUBLIC asm_dirname

EXTERN __lg_remove_tail, __lg_return_dot, __lg_return_slash

asm_dirname:

   ; point to parent directory of path
   ; may modify path
   ;
   ; enter : hl = char *path
   ;
   ; exit  : hl = char *dirname
   ;
   ; uses  : af, bc, de, hl
   
   call __lg_remove_tail       ; remove trailing whitespace and slashes
   ret nc                      ; if result determined

loop_find:

   ; find slash

   cp '/'
   jr z, loop_remove
   
   cpd                         ; hl--, bc--
   ld a,(hl)
   
   jp pe, loop_find
   jp __lg_return_dot          ; if no slash found

loop_remove:

   ; remove multiple slashes
   
   cpd                         ; hl--, bc--
   jp po, __lg_return_slash    ; if only slashes
   
   ld a,(hl)
   
   cp '/'
   jr z, loop_remove

   ; terminate dirname
   
   inc hl
   ld (hl),0
   
   ; dirname starts at beginning
   
   ex de,hl
   
   ld a,(hl)
   or a
   
   ret nz                      ; if dirname is not empty
   jp __lg_return_dot
