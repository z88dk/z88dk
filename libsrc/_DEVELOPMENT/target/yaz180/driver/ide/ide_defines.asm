;==============================================================================
;
; DEFINES SECTION
;

PUBLIC __IDE_CMD_READ, __IDE_CMD_WRITE, __IDE_CMD_INIT
PUBLIC __IDE_CMD_SLEEP, __IDE_CMD_SPINUP, __IDE_CMD_POWERDOWN
PUBLIC __IDE_CMD_CACHE_FLUSH, __IDE_CMD_ID

;------------------------------------------------------------------------------
; IDE Command Constants.  These should never change.
DEFC    __IDE_CMD_READ        =   $20 ;read with retry - $21 read no retry
DEFC    __IDE_CMD_WRITE       =   $30 ;write with retry - $31 write no retry
DEFC    __IDE_CMD_INIT        =   $91 ;initialize drive parameters

DEFC    __IDE_CMD_STANDBY     =   $E0 ;immediate spindown of disk
DEFC    __IDE_CMD_IDLE        =   $E1 ;immediate idle of disk
DEFC    __IDE_CMD_SLEEP       =   $E6 ;powerdown, reset to recover
DEFC    __IDE_CMD_CACHE_FLUSH =   $E7 ;flush hardware write cache
DEFC    __IDE_CMD_ID          =   $EC ;identify drive
