; uchar esxdos_m_gethandle(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_m_gethandle

EXTERN __esxdos_error_mc

asm_esxdos_m_gethandle:

   ; M_GETHANDLE:
   ; Get file handle of just loaded BASIC program in A.
   ; To be used with single-file loaders (Condommed for example).
   ;
   ; enter : none
   ;
   ; exit  : success
   ;
   ;            hl = file handle
   ;            carry reset
   ;
   ;         error
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : unknown
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_M_GETHANDLE
   
   ld l,a
   ret nc
   
   jp __esxdos_error_mc
