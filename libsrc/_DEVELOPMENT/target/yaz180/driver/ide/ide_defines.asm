;==============================================================================
;
; DEFINES SECTION
;

PUBLIC IDE_CMD_RECAL, IDE_CMD_READ, IDE_CMD_WRITE, IDE_CMD_INIT
PUBLIC IDE_CMD_SPINDOWN, IDE_CMD_SPINUP, IDE_CMD_POWERDOWN
PUBLIC IDE_CMD_CACHE_FLUSH, IDE_CMD_ID

;------------------------------------------------------------------------------
; IDE Command Constants.  These should never change.
DEFC    IDE_CMD_RECAL       =   $10 ;recalibrate the disk, wait for ready status
DEFC    IDE_CMD_READ        =   $20 ;read with retry - $21 read no retry
DEFC    IDE_CMD_WRITE       =   $30 ;write with retry - $31 write no retry
DEFC    IDE_CMD_INIT        =   $91 ;initialize drive parameters

DEFC    IDE_CMD_SPINDOWN    =   $E0 ;immediate ide_spindown of disk
DEFC    IDE_CMD_SPINUP      =   $E1 ;immediate ide_spinup of disk
DEFC    IDE_CMD_POWERDOWN   =   $E2 ;auto powerdown - sector count 5 sec units
DEFC    IDE_CMD_CACHE_FLUSH =   $E7 ;flush hardware write cache
DEFC    IDE_CMD_ID          =   $EC ;identify drive
