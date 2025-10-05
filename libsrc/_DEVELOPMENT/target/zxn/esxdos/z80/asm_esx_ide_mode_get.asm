; unsigned char esx_ide_mode_get(struct esx_mode *mode)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_mode_get
PUBLIC l_esx_ide_mode_get

EXTERN __esxdos_error_mc, error_znc

IF __ZXNEXT

asm_esx_ide_mode_get:

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

   xor a                       ; get

l_esx_ide_mode_get:

   exx
   
   ld de,__NEXTOS_IDE_MODE
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS
   
   jr nc, error_ide_mode       ; if error
   
   ; adjust rows and cols according to returned flags

check_double_width:

   bit 4,c
   jr z, check_double_height
   
   srl l                       ; halve number of columns

check_double_height:

   bit 5,c
   jr z, store_state
   
   srl h                       ; have number of rows
   
store_state:

   ex (sp),hl
   
   ld (hl),a
   inc hl
   and $03
   ld (hl),a                   ; layer
   dec hl
   ld a,(hl)
   rra
   rra
   and $03
   ld (hl),a                   ; submode
   inc hl
   inc hl
   
   ld (hl),e                   ; ink
   inc hl
   ld (hl),d                   ; paper
   inc hl
   ld (hl),c                   ; flags
   inc hl
   ld (hl),b                   ; width
   inc hl
   
   pop de
   
   ld (hl),e                   ; columns
   inc hl
   ld (hl),d                   ; rows

   jp error_znc

error_ide_mode:

   pop hl
   jp __esxdos_error_mc

ELSE

asm_esx_ide_mode_get:
l_esx_ide_mode_get:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
