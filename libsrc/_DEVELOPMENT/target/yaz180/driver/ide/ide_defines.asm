;==============================================================================
;
; DEFINES SECTION
;

PUBLIC __IDE_CMD_RECAL, __IDE_CMD_READ, __IDE_CMD_WRITE, __IDE_CMD_INIT
PUBLIC __IDE_CMD_SPINDOWN, __IDE_CMD_SPINUP, __IDE_CMD_POWERDOWN
PUBLIC __IDE_CMD_CACHE_FLUSH, __IDE_CMD_ID

;------------------------------------------------------------------------------
; IDE Command Constants.  These should never change.
DEFC    __IDE_CMD_RECAL       =   $10 ;recalibrate the disk, wait for ready status
DEFC    __IDE_CMD_READ        =   $20 ;read with retry - $21 read no retry
DEFC    __IDE_CMD_WRITE       =   $30 ;write with retry - $31 write no retry
DEFC    __IDE_CMD_INIT        =   $91 ;initialize drive parameters

DEFC    __IDE_CMD_SPINDOWN    =   $E0 ;immediate spindown of disk
DEFC    __IDE_CMD_SPINUP      =   $E1 ;immediate spinup of disk
DEFC    __IDE_CMD_POWERDOWN   =   $E2 ;auto powerdown - sector count 5 sec units
DEFC    __IDE_CMD_CACHE_FLUSH =   $E7 ;flush hardware write cache
DEFC    __IDE_CMD_ID          =   $EC ;identify drive
