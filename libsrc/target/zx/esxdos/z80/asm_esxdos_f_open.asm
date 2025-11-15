; uchar esxdos_f_open(char *filename, uchar mode)
; uchar esxdos_f_open_p3(char *filename, uchar mode, void *header)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_open

EXTERN __esxdos_error_mc

asm_esxdos_f_open:

   ; F_OPEN:
   ; Open file.
   ; 
   ; A=drive
   ; HL=Pointer to null-terminated string containg path and/or filename
   ; B=file access mode (check config_esxdos.m4)
   ; DE=Pointer to BASIC header data / buffer to get filled with BASIC
   ;    header data (8 bytes like +3DOS). If you try to open a headerless
   ;    file, BASIC type is $ff. Only used when B specifies it.
   ;
   ; On return if OK, A=file handle.
   ;
   ; enter :     a = uchar drive
   ;            hl = char *filename
   ;             b = mode (__ESXDOS_MODE_*)
   ;            de = (optional) dst for +3 header (mode contains __ESXDOS_MODE_USE_HEADER)
   ;
   ; exit  : success
   ;
   ;            l = file handle
   ;            carry reset
   ;
   ;         error
   ;
   ;            hl = -1
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
   defb __ESXDOS_SYS_F_OPEN
   
   ld l,a
   ret nc
   
   jp __esxdos_error_mc
