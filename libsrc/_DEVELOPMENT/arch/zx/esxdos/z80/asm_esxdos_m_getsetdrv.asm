; uchar esxdos_m_getsetdrv(uchar drive)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_m_getsetdrv

EXTERN __esxdos_error_mc

asm_esxdos_m_getsetdrv:

   ; M_GETSETDRV:
   ; If A=0 -> Get default drive in A. Else set default drive passed in A.
   ;
   ; LOGICAL DRIVES
   ; =========================
   ; 
   ; --------------------------------------------------
   ; BIT   |         7-3           |       2-0        |
   ; --------------------------------------------------
   ;       | Drive letter from A-Z | Drive number 0-7 |
   ; --------------------------------------------------
   ;
   ; Programs that need to print all available drives (ie, file selector)
   ; just need to:
   ;
   ; a) Process higher 5 bits to print Drive letter
   ; b) Print the 'd'
   ; c) Process the lower 3 bits to print Drive number.
   ;
   ; enter :     l = uchar drive, 0 = get, set otherwise
   ;
   ; exit  : success
   ;
   ;             l = default drive on get
   ;             carry reset
   ;
   ;         error
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : unknown
   
   ld a,l
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_M_GETSETDRV
   
   ld l,a
   ret nc
   
   jp __esxdos_error_mc
