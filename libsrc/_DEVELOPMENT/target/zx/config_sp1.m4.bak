divert(-1)

###############################################################
# SP1 SPRITE LIBRARY CONFIGURATION
# rebuild the library if changes are made
#

# Display characteristics

define(`SP1V_DISPORIGX',   0)           # x coordinate of top left corner of area managed by sp1 in characters
define(`SP1V_DISPORIGY',   0)           # y coordinate of top left corner of area managed by sp1 in characters
define(`SP1V_DISPWIDTH',  32)           # width of area managed by sp1 in characters (16, 24, 32 ok as of now)
define(`SP1V_DISPHEIGHT', 24)           # height of area managed by sp1 in characters

# Buffers

define(`SP1V_PIXELBUFFER', 0xd1f7)      # address of an 8-byte buffer to hold intermediate pixel-draw results
define(`SP1V_ATTRBUFFER',  0xd1ff)      # address of a single byte buffer to hold intermediate colour-draw results

# Data structure locations

define(`SP1V_TILEARRAY',   0xf000)      # address of the 512-byte tile array associating character codes with tile graphics, must lie on 256-byte boundary (LSB=0)
define(`SP1V_UPDATEARRAY', 0xd200)      # address of the 10*SP1V_DISPWIDTH*SP1V_DISPHEIGHT byte update array
define(`SP1V_ROTTBL',      0xf000)      # location of the 3584-byte rotation table.  Must lie on 256-byte boundary (LSB=0).  Table begins $0200 bytes ahead of this
                                        #  pointer ($f200-$ffff in this default case).  Set to $0000 if the table is not needed (if, for example, all sprites
                                        #  are drawn at exact horizontal character coordinates or you use pre-shifted sprites only).
# SP1 variables

define(`SP1V_UPDATELISTH', 0xd1ed)      # address of 10-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
define(`SP1V_UPDATELISTT', 0xd1ef)      # address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn

# NOTE: SP1V_UPDATELISTT is located inside the dummy struct_sp1_update pointed at by SP1V_UPDATELISTH

#
# DEFAULT MEMORY MAP
#
# With these default settings the memory map is:
#
# ADDRESS (HEX)   LIBRARY  DESCRIPTION
#
# f200 - ffff     SP1.LIB  horizontal rotation tables
# f000 - f1ff     SP1.LIB  tile array
# d200 - efff     SP1.LIB  update array for full size screen 32x24
# d1ff - d1ff     SP1.LIB  attribute buffer
# d1f7 - d1fe     SP1.LIB  pixel buffer
# d1ed - d1f6     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
#  * d1ef - d1f0  SP1.LIB  update list tail pointer (inside dummy struct sp1_update)
# d1d4 - d1ec     --free-  25 bytes free
# d1d1 - d1d3     -------  JP to im2 service routine (im2 table filled with 0xd1 bytes)
# d101 - d1d0     --free-  208 bytes
# d000 - d100     IM2.LIB  im 2 vector table (257 bytes)
# ce00 - cfff     -------  z80 stack (512 bytes) set SP=d000

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `SP1V_DISPORIGX'
PUBLIC `SP1V_DISPORIGY'
PUBLIC `SP1V_DISPWIDTH'
PUBLIC `SP1V_DISPHEIGHT'

PUBLIC `SP1V_PIXELBUFFER'
PUBLIC `SP1V_ATTRBUFFER'

PUBLIC `SP1V_TILEARRAY'
PUBLIC `SP1V_UPDATEARRAY'
PUBLIC `SP1V_ROTTBL'

PUBLIC `SP1V_UPDATELISTH'
PUBLIC `SP1V_UPDATELISTT'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `SP1V_DISPORIGX'   = SP1V_DISPORIGX
defc `SP1V_DISPORIGY'   = SP1V_DISPORIGY
defc `SP1V_DISPWIDTH'   = SP1V_DISPWIDTH
defc `SP1V_DISPHEIGHT'  = SP1V_DISPHEIGHT

defc `SP1V_PIXELBUFFER' = SP1V_PIXELBUFFER
defc `SP1V_ATTRBUFFER'  = SP1V_ATTRBUFFER

defc `SP1V_TILEARRAY'   = SP1V_TILEARRAY
defc `SP1V_UPDATEARRAY' = SP1V_UPDATEARRAY
defc `SP1V_ROTTBL'      = SP1V_ROTTBL

defc `SP1V_UPDATELISTH' = SP1V_UPDATELISTH
defc `SP1V_UPDATELISTT' = SP1V_UPDATELISTT
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `SP1V_DISPORIGX'    SP1V_DISPORIGX
`#define' `SP1V_DISPORIGY'    SP1V_DISPORIGY
`#define' `SP1V_DISPWIDTH'    SP1V_DISPWIDTH
`#define' `SP1V_DISPHEIGHT'   SP1V_DISPHEIGHT

`#define' `SP1V_PIXELBUFFER'  SP1V_PIXELBUFFER
`#define' `SP1V_ATTRBUFFER'   SP1V_ATTRBUFFER

`#define' `SP1V_TILEARRAY'    SP1V_TILEARRAY
`#define' `SP1V_UPDATEARRAY'  SP1V_UPDATEARRAY
`#define' `SP1V_ROTTBL'       SP1V_ROTTBL

`#define' `SP1V_UPDATELISTH'  SP1V_UPDATELISTH
`#define' `SP1V_UPDATELISTT'  SP1V_UPDATELISTT
')
