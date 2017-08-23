; uchar esxdos_f_opendir(char *path)
; uchar esxdos_f_opendir_p3(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_opendir

EXTERN __esxdos_error_mc

asm_esxdos_f_opendir:

   ; F_OPENDIR:
   ; Open dir.
   ;
   ; A=drive
   ; HL=Pointer to null-terminated string containg path to dir
   ; B=dir access mode (only BASIC header bit matters - if you
   ; want to read header info or not)
   ;
   ; On return if OK, A=dir handle.
   ;
   ; enter :     a = uchar drive
   ;             b = 0 or __ESXDOS_MODE_USE_HEADER
   ;            hl = char *path
   ;
   ; note  : hl is the parameter for dot commands and ix is used otherwise
   ;
   ; exit  : success
   ;
   ;            l = dir handle
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
   defb __ESXDOS_SYS_F_OPENDIR
   
   ld l,a
   ret nc

   jp __esxdos_error_mc
