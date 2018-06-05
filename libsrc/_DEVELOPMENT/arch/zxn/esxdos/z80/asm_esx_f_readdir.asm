; unsigned char esx_f_readdir(unsigned char handle,struct esx_dirent *dirent)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_readdir

EXTERN __esxdos_error_mc

asm_esx_f_readdir:

   ; enter :  a = handle
   ;         hl = dirent *
   ;
   ; exit  : success
   ;
   ;            hl = 0 if no more directory entries
   ;               = 1 if directory entry returned
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_READDIR
   
   ld l,a
   ld h,0
   
   ret nc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_READDIR ($a4) *
; ***************************************************************************
; Read next directory entry.
; Entry:
; A=handle
; IX=buffer
; Exit (success):
; A=number of entries returned (0 or 1)
; If 0, there are no more entries
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
;
; Buffer format:
; 1 byte file attributes (MSDOS format)
; ? bytes file/directory name, null-terminated
; 2 bytes timestamp (MSDOS format)
; 2 bytes datestamp (MSDOS format)
; 4 bytes file size
;
; NOTES:
; If the directory was opened with the esx_mode_use_lfn bit, long filenames
; (up to 260 bytes plus terminator) are returned; otherwise short filenames
; (up to 12 bytes plus terminator) are returned.
; If opened with the esx_mode_use_header bit, after the normal entry follows the
; 8-byte +3DOS header (for headerless files, type=$ff, other bytes=zero).
