; unsigned char esx_ide_get_lfn(struct esx_lfn *dir, struct esx_cat_entry *query)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_get_lfn

EXTERN __esxdos_error_mc, error_znc
EXTERN asm_p3dos_pstr_to_cstr

IF __ZXNEXT

asm_esx_ide_get_lfn:

   ; enter : hl = struct esx_lfn *dir
   ;         de = struct esx_cat_entry *query
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set to zxnextos code
   ;
   ; uses  : all except af', iy

   push de                    ; save query
   
   ld e,(hl)
   inc hl
   ld d,(hl)                  ; de = struct esx_cat *cat
   inc hl
   
   ld c,l
   ld b,h                      ; bc = &lfn

   ex (sp),hl
   push hl                     ; stack = &lfn, query
   
   ld hl,__ESX_FILENAME_LFN_MAX + 1
   add hl,bc
   
   ex (sp),hl                  ; save &time
   push hl                     ; save query

   ex de,hl                    ; hl = struct esx_cat *cat

   ; bc = &lfn
   ; hl = struct esx_cat *
   ; stack = &lfn, &time, query
   
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = cat.filename
   
   push de                     ; save cat.filename
   
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = cat.dir_handle
   
IF __SDCC_IY

   push de
   pop iy

ELSE

   push de
   pop ix                      ; ix = cat.dir_handle

ENDIF

   pop hl                      ; hl = cat.filename
   pop de                      ; de = query

   ; bc = &lfn
   ; de = query
   ; hl = filename
   ; ix = dir_handle
   ; stack = &lfn, &time

   exx

IF __SDCC_IY

   push iy
   pop hl

ELSE

   push ix
   pop hl

ENDIF

   ld de,__NEXTOS_IDE_GET_LFN
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS
   
   jr nc, error_get_lfn

   ; after an M_P3DOS call, return values
   ; normally in IX are instead in HL'

   ex (sp),hl                  ; hl = &time
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; write dos_time
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; write dos_date
   inc hl

   exx
   push hl
   exx
   pop de

   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; write file size

   ; zero terminate lfn
   
   pop hl                      ; hl = &lfn

   call asm_p3dos_pstr_to_cstr
   jp error_znc

error_get_lfn:

   pop hl
   pop hl

   jp __esxdos_error_mc

ELSE

asm_esx_ide_get_lfn:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
