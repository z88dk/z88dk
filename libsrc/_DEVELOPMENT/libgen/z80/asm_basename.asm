; char *basename(char *path)

SECTION code_string

PUBLIC asm_basename

EXTERN __lg_remove_tail, __lg_return_dot

asm_basename:

   ; point to final component of path
   ; may modify path to eliminate trailing slashes
   ;
   ; enter : hl = char *path
   ;
   ; exit  : hl = char *basename
   ;         de = char *path
   ;
   ; uses  : af, bc, de, hl

   call __lg_remove_tail       ; remove trailing whitespace and slashes
   ret nc                      ; if result determined

   ; find start of basename
   
   call find_start
   inc hl                      ; advance to first char in basename
   
   ld a,(hl)

   or a
   jp z, __lg_return_dot       ; if empty string
   
   cp '.'
   ret nz
   
   inc hl
   ld a,(hl)
   dec hl
   
   cp '.'
   ret nz                      ; if not ".."

   jp __lg_return_dot

find_start:

   cp '/'
   ret z
   
   cpd                         ; hl--, bc--
   ld a,(hl)   

   jp pe, find_start
   
   scf
   ret
