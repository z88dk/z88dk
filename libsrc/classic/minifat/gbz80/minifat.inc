; FIL, FATFS, DIR, and FILINFO layouts. Match include/fatfs.h.
; Arguments are caller-cleaned, last argument at sp+2, first deepest.
; A long is 4 bytes at the low address, low word first.
; Success is HL = 0 and carry set. Failure is HL = FRESULT and carry clear.

DEFC    FR_OK           = 0
DEFC    FR_DISK_ERR     = 1
DEFC    FR_INT_ERR      = 2
DEFC    FR_NOT_READY    = 3
DEFC    FR_NO_FILE      = 4
DEFC    FR_NO_PATH      = 5
DEFC    FR_INVALID_NAME = 6
DEFC    FR_DENIED       = 7
DEFC    FR_EXIST        = 8
DEFC    FR_INVALID_OBJECT = 9
DEFC    FR_WRITE_PROTECTED = 10
DEFC    FR_INVALID_DRIVE = 11
DEFC    FR_NOT_ENABLED  = 12
DEFC    FR_NO_FILESYSTEM = 13
DEFC    FR_NOT_ENOUGH_CORE = 17
DEFC    FR_INVALID_PARAMETER = 19

DEFC    FA_READ         = $01
DEFC    FA_WRITE        = $02
DEFC    FA_CREATE_NEW   = $04
DEFC    FA_CREATE_ALWAYS = $08
DEFC    FA_OPEN_ALWAYS  = $10
DEFC    FA_SEEKEND      = $20
DEFC    FA_OPEN_APPEND  = $30
DEFC    FA_MODIFIED     = $40
DEFC    FA_DIRTY        = $80
DEFC    FA_MODE_MASK    = $3F
DEFC    FA_CREATE_MASK  = $1C

DEFC    AM_RDO          = $01
DEFC    AM_HID          = $02
DEFC    AM_SYS          = $04
DEFC    AM_VOL          = $08
DEFC    AM_DIR          = $10
DEFC    AM_ARC          = $20

DEFC    FS_FAT12        = 1
DEFC    FS_FAT16        = 2
DEFC    FS_FAT32        = 3

DEFC    FIL_ID          = 0
DEFC    FIL_FLAG        = 2
DEFC    FIL_ERR         = 3
DEFC    FIL_ATTR        = 4
DEFC    FIL_FPTR        = 6
DEFC    FIL_SIZE        = 10
DEFC    FIL_SCLUST      = 14
DEFC    FIL_CLUST       = 18
DEFC    FIL_SECT        = 22
DEFC    FIL_DIRSEC      = 26
DEFC    FIL_DIROFS      = 30
DEFC    FIL_BYTES       = 32

DEFC    FATFS_TYPE      = 0
DEFC    FATFS_PDRV      = 1
DEFC    FATFS_ID        = 2

DEFC    DIR_ID          = 0
DEFC    DIR_DPTR        = 4
DEFC    DIR_SCLUST      = 8
DEFC    DIR_CLUST       = 12
DEFC    DIR_SECT        = 16

DEFC    FI_SIZE         = 0
DEFC    FI_DATE         = 4
DEFC    FI_TIME         = 6
DEFC    FI_ATTR         = 8
DEFC    FI_NAME         = 9

DEFC    DIR_Attr        = 11
DEFC    DIR_CrtTime     = 14
DEFC    DIR_LstAccDate  = 18
DEFC    DIR_ClusHI      = 20
DEFC    DIR_WrtTime     = 22
DEFC    DIR_WrtDate     = 24
DEFC    DIR_ClusLO      = 26
DEFC    DIR_FileSize    = 28
