
XLIB __stdio_parse_permission

__stdio_parse_permission:

   ; parse the fopen permission string
   ; valid characters include "rwab+"
   ;
   ; enter : de = char *permission
   ;
   ; exit  : de = char *permission_ptr (address of non-matching char)
   ;         success, permission string valid
   ;
   ;            c = flags = IOB0 00AC
   ;            carry reset
   ;
   ;         fail, permission string invalid
   ;
   ;            carry set
   ;
   ; note  : IOB0 00AC
   ;
   ;          I =  1  open for reading
   ;          O =  1  open for writing
   ;          B =  1  binary mode (may be relevant for a driver)
   ;          A =  1  append writes
   ;         AC = 00  file must exist, do not create
   ;              10  open if exists but create if it does not exist
   ;              01  create and/or truncate
   ;              11  create and/or truncate
   ;
   ; uses  : af, bc, de, hl

   ld c,0

flags_loop:

   ld b,5
   ld hl,permission_table

   ld a,(de)
   or a
   jr z, check_validity        ; if end of permission string reached
   
match_loop:

   cp (hl)
   inc hl
   
   jr z, found_flag
   
   inc hl
   djnz match_loop

   ; no match

invalid:

   scf
   ret

found_flag:

   ld a,(hl)
   or c
   ld c,a
   
   inc de
   jr flags_loop

check_validity:

   ; c = flags = IOB0 00AC
   
   ld a,c
   and $c0                     ; valid set of flags must have I and/or O set
   ret nz
   
   scf
   ret

permission_table:

   defb 'r', $80
   defb 'w', $41
   defb 'a', $42
   defb '+', $c0
   defb 'b', $20
