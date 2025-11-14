; uchar esxdos_f_readdir(uchar handle, void *buf)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_readdir

EXTERN __esxdos_error_zc

asm_esxdos_f_readdir:

   ; F_READDIR:
   ; Read a dir entry to buffer pointed to by HL. A=handle.
   ;
   ; Buffer format:
   ;
   ; <asciiz> file/dirname
   ; <byte>   attributes (like MSDOS)
   ; <dword>  date
   ; <dword>  filesize
   ;
   ; If opened with BASIC header bit, after the normal entry
   ; follows the BASIC header (with type=$ff if headerless)
   ;
   ; On return, if A=1 theres more entries, if=0 then it's end
   ; of dir. FIXME-A should return size of entry, 0 if end of dir.
   ;
   ; enter :     a = uchar handle
   ;            hl = void *buf
   ;
   ; exit  : success
   ;
   ;            l = non-zero if more entries
   ;            carry reset
   ;
   ;         error
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : unknown

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READDIR
   
   ld l,a
   ret nc
   
   jp __esxdos_error_zc
