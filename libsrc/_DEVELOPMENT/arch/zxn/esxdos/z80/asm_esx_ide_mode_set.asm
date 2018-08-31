; unsigned char esx_ide_mode_set(struct esx_mode *mode)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_mode_set

EXTERN l_esx_ide_mode_get

asm_esx_ide_mode_set:

   ; enter : hl = struct esx_mode *mode
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = nextzxos error code
   ;
   ; uses  : all except af', iy
   
   push hl
   
   ld c,(hl)                   ; submode
   inc hl
   ld b,(hl)                   ; layer
   
   ld a,1                      ; set
   
   jp l_esx_ide_mode_get
