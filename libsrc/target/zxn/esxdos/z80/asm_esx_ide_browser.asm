; unsigned char esx_ide_browser(uint8_t browsercaps, void *filetypes, char *help, char *dst_sfn, char *dst_lfn)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_browser

EXTERN error_znc, error_onc, __esxdos_error_mc, __esx_exx_mmu67_bc
EXTERN asm_p3dos_cstr_to_pstr, asm_p3dos_pstr_to_cstr, asm_p3dos_copy_pstr_to_cstr

IF __ZXNEXT

asm_esx_ide_browser:

   ; Call the NextZXOS file browser
   ;
   ; note that this function performs all ff-terminated to 0-terminated string conversions
   ; the buffers receiving names must lie outside mmu 6,7 as must the stack
   ;
   ; enter :  a = browser caps mask
   ;         ix = address of supported file types buffer
   ;         hl = address of zero-terminated help text
   ;         bc = address of buffer to receive 8.3 filename (0 if not wanted, zero terminated)
   ;         de = address of buffer to receive lfn filename (0 if not wanted, zero terminated)
   ;
   ; exit  : success
   ;
   ;            lfn and sfn filenames copied
   ;            hl = 0, carry reset
   ;
   ;         fail if user cancelled
   ;
   ;            hl = 1, carry reset
   ;
   ;         fail if error
   ;
   ;            hl = -1, carry set, errno set
   ;
   ; uses  : all except iy
   
   push hl                     ; save help text
   push bc                     ; save sfn buffer
   push de                     ; save lfn buffer
   
   push af                     ; save browser caps
   
   call asm_p3dos_cstr_to_pstr ; change string termination on help text
   
   pop af
   
   ex de,hl

IF __SDCC_IY

   push ix
   push ix
   pop iy
   pop hl
   
   ld ix,__SYS_IY

ELSE

   push ix
   pop hl

   ld iy,__SYS_IY

ENDIF

   ;  a = browser caps
   ; de = help text, ff terminated
   ; hl = ix = file types buffer
   ; stack = help text, sfn buffer, lfn buffer
   
   exx
   
   ld de,__NEXTOS_IDE_BROWSER
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS

   jr nc, error_browser
   jr nz, error_break

   ; successful call

   ; de = address of lfn in BANK 7 (ff terminated)
   ; hl = address of sfn in BANK 7 (ff terminated)
   
   ; page in BANK 7
   
   ld bc,0x0f0e                ; pages 14 and 15
   call __esx_exx_mmu67_bc     ; bc = old mmu6,7

   ; copy returned strings to destination buffers
   
   ex (sp),hl
   ex de,hl
   
   ; hl = result long filename (ff terminated)
   ; de = destination lfn
   ; bc = saved mmu6,7
   ; stack = help text, sfn buffer, result sfn
   
   ld a,d
   or e

   jr z, skip_lfn

   push bc
   call asm_p3dos_copy_pstr_to_cstr
   pop bc   

skip_lfn:

   pop hl                      ; hl = result sfn (ff terminated)
   pop de                      ; de = destination sfn
   
   ld a,d
   or e
   
   jr z, skip_sfn

   push bc
   call asm_p3dos_copy_pstr_to_cstr
   pop bc

skip_sfn:

   ; restore mmu6,7

   call  __esx_exx_mmu67_bc
   
   ; return to zero termination for help text
   
   pop hl
   call asm_p3dos_pstr_to_cstr
   
   jp error_znc                ; return success

error_break:

   pop hl
   pop hl
   pop hl                      ; hl = help text
   
   call asm_p3dos_pstr_to_cstr ; return to zero termination for help text
   
   jp error_onc                ; hl = 1, carry reset

error_browser:

   pop hl
   pop hl
   pop hl                      ; hl = help text
   
   push af
   
   call asm_p3dos_pstr_to_cstr ; return to zero termination for help text
   
   pop af
   jp __esxdos_error_mc

ELSE

asm_esx_ide_browser:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
