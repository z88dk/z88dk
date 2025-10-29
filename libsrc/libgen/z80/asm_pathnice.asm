; char *pathnice(char *path)

SECTION code_string

PUBLIC asm_pathnice

EXTERN asm_isspace, __lg_remove_tail

asm_pathnice:

   ; remove leading and trailing whitespace
   ; change backward slash to forward slash
   ; remove repeated slash
   ; remove trailing slashes
   ;
   ; enter : hl = char *path
   ;
   ; exit  : hl = char *path_nice
   ;
   ; uses  : af, bc, de, hl
   
loop_ws:

   ; remove leading whitespace

   ld a,(hl)
   inc hl
   
   call asm_isspace
   jr nc, loop_ws
   
   dec hl
   push hl                     ; save path

change_slashes:

   ld e,l
   ld d,h                      ; copy dst for path
   
   ld c,0                      ; last char seen

loop_slashes:

   ; change instances of backward slash to forward slash
   
   cp '\\'
   jr z, is_slash

   cp '/'
   jr nz, not_slash

is_slash:

   ld a,'/'

   cp c
   jr nz, not_slash            ; if slash not repeating
   
   dec de

not_slash:

   ; copy path char to dst

   ld c,a
   ld (de),a

   or a
   
   inc de
   inc hl
   
   ld a,(hl)
   jr nz, loop_slashes

remove_tail:

   ; remove trailing whitespace and slashes

   pop hl                      ; hl = char *path
   
   call __lg_remove_tail
   ret nc
   
   ex de,hl
   ret
