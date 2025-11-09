; char *p3dos_dosname_from_catname(char *dosname, char *catname)

SECTION code_esxdos

PUBLIC asm_p3dos_dosname_from_catname

asm_p3dos_dosname_from_catname:

   ; enter : de = char *catname
   ;         hl = char *dosname
   ;
   ; exit  : hl = char *dosname
   ;
   ; uses  : af, bc, de, hl
   
   push hl
   
   ; 8-character filename
   
   ld b,8
   call name_copy
   
   ; dot
   
   ld (hl),'.'
   inc hl
   
   ; 3-character extension

   ld bc,0x03ff
   call name_copy
   
   ; terminate
   
   inc c
   jr nz, keep_dot
   
   dec hl

keep_dot:

   ld (hl),0
   
   pop hl
   ret

name_copy:

   push hl

name_loop:

   ld a,(de)
   inc de
   
   and 0x7f
   
   ld (hl),a
   inc hl
   
   cp ' '
   jr z, name_skip
   
   pop af
   push hl
   
   inc c

name_skip:

   djnz name_loop
   
   pop hl
   ret
