; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_seek

EXTERN __esxdos_error_mc

asm_esxdos_f_seek:

   ; F_SEEK:
   ; Seek BCDE bytes. A=handle
   ; L=mode (0 from start of file, 1 fwd from current pos, 2 back from current pos).
   ; On return BCDE=current file pointer. FIXME-Should return bytes actually seeked
   ;
   ; enter :     a = uchar handle
   ;          bcde = ulong seek distance
   ;             l = uchar whence
   ;
   ; exit  : success
   ;
   ;            dehl = current file position
   ;            carry reset
   ;
   ;         error
   ;
   ;            dehl = -1
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
   defb __ESXDOS_SYS_F_SEEK
   
   ex de,hl
   ld e,c
   ld d,b
   
   ret nc
   
   ld de,-1
   jp __esxdos_error_mc
