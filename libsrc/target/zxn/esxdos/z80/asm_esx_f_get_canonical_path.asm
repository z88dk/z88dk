; unsigned char esx_f_get_canonical_path(char *pathname, char *canonical)

SECTION code_esxdos

PUBLIC asm_esx_f_get_canonical_path

EXTERN l_asm_esx_f_getcwd

asm_esx_f_get_canonical_path:

   ; enter : hl = canonical
   ;         de = pathname
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

   ld a,$ff
   jp l_asm_esx_f_getcwd
