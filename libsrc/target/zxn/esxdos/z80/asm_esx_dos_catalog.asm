; unsigned char esx_dos_catalog(struct esx_cat *cat)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_dos_catalog
PUBLIC l_asm_esx_dos_catalog

EXTERN error_znc, __esxdos_error_mc

IF __ZXNEXT

asm_esx_dos_catalog:

   ; enter : hl = struct esx_cat *cat (some members initialized)
   ;              note that this structure must be in main memory
   ;
   ; exit  : success
   ;
   ;            hl = number of catalog entries filled in (0 if cat is done)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except af', iy

   scf                         ; indicate this is the first catalog call

l_asm_esx_dos_catalog:

   ld c,(hl)                   ; c = filter
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = filename
   inc hl

   push hl                     ; save & cat.dir_handle
   
   inc hl
   inc hl
   
   ld a,(hl)                   ; a = completed_sz
   inc hl

   ld b,(hl)                   ; b = n+1 >= 2
   inc hl
   
   ex de,hl                    ; hl = filename, de = buffer

   jr c, first_call            ; if this is a first call to dos_catalog
   
next_call:

   inc a
   cp b
   
   jp nz, error_znc - 1        ; indicate catalog is finished

   push bc
   push de
   push hl

   ex de,hl                    ; hl = cat[]

   ld d,b                      ; d = cat_sz
   dec d
   ld e,13                     ; e = size of cat entry
   
   mul de

   ex de,hl
   
   add hl,de                   ; hl = last cat entry, de = first cat entry
   
   ld bc,13
   ldir

rejoin:

   pop hl
   pop de
   pop bc
   
catalog:

   exx
   
   ld de,__NEXTOS_DOS_CATALOG
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS
   
   pop de                      ; de = & cat.dir_handle
   jp nc, __esxdos_error_mc    ; if error
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; write directory handle
   inc hl

   dec b                       ; change to number of entries written
   ld (hl),b                   ; write completed sz
   
   xor a
   
   ld l,b
   ld h,a                      ; hl = number of completed entries
   
   ret

first_call:

   push bc
   push de
   push hl
   
   ld l,e
   ld h,d
   
   inc de
   
   ld bc,12
   ld (hl),b
   
   ldir                        ; zero first cat entry

   jr rejoin

ELSE

asm_esx_dos_catalog:
l_asm_esx_dos_catalog:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
