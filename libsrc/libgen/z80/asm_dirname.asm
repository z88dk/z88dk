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

IF __CPU_GBZ80__ | __CPU_INTEL__
   dec hl
   ld a,b
   or c
   jp __lg_return_dot
   dec bc
   ld a,(hl)
   jr loop_find
ELSE
   
   cpd                         ; hl--, bc--
   ld a,(hl)
   
   jp pe, loop_find
   jp __lg_return_dot          ; if no slash found
ENDIF

loop_remove:

   ; remove multiple slashes

IF __CPU_GBZ80__ | __CPU_INTEL__
   dec hl
   ld a,b
   or c
   jp z,__lg_return_slash
   dec bc
   ld a,(hl)
ELSE
   
   cpd                         ; hl--, bc--
   jp po, __lg_return_slash    ; if only slashes
   
   ld a,(hl)
ENDIF
   
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
