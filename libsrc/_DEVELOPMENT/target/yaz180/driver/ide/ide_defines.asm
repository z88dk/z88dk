
PUBLIC __IDE_CMD_READ, __IDE_CMD_WRITE
PUBLIC __IDE_CMD_STANDBY, __IDE_CMD_IDLE, __IDE_CMD_SLEEP
PUBLIC __IDE_CMD_CACHE_FLUSH, __IDE_CMD_ID

;==============================================================================
;
; DEFINES SECTION
;
;
; IDE reg: A0-A2: /CS0: /CS1: Use:
;
;       $0    000    0    1     IDE Data Port
;       $1    001    0    1     Read: Error code (also see $$)
;       $2    010    0    1     Number Of Sectors To Transfer
;       $3    011    0    1     Sector address LBA 0 (0:7)
;       $4    100    0    1     Sector address LBA 1 (8:15)
;       $5    101    0    1     Sector address LBA 2 (16:23)
;       $6    110    0    1     Head Register, Sector address LBA 3 (24:27) (also see **)
;       $7    111    0    1     Read: "Status", Write: Issue command (also see ##)
;       $8    000    1    0     Not Important
;       $9    001    1    0     Not Important
;       $A    010    1    0     Not Important
;       $B    011    1    0     Not Important
;       $C    100    1    0     Not Important
;       $D    101    1    0     Not Important
;       $E    110    1    0     2nd Status, Interrupt, and Reset
;       $F    111    1    0     Active Status Register 
;
;       $$ Bits in Error Register $1
;
;       Bit 7   = BBK   Bad Block Detected
;       Bit 6   = UNC   Uncorrectable Error
;       Bit 5   = MC    No media
;       Bit 4   = IDNF  Selector Id
;       Bit 3   = MCR   Media Change requested
;       Bit 2   = ABRT  Indecent Command - Doh!
;       Bit 1   = TK0NF Track 0 unavailable -> Trash
;       Bit 0   = AMNF  Address mark not found
;
;       ** Bits in LBA 3 Register $6:
;
;       Bit 7   = Always set to 1
;       Bit 6   = Always Set to 1 for LBA Mode Access
;       Bit 5   = Always set to 1
;       Bit 4   = Select Master (0) or Slave (1) drive
;       Bit 0:3 = LBA bits (24:27)
;
;       ## Bits in Command / Status Register $7:
;
;       Bit 7   = BSY   1=busy, 0=not busy
;       Bit 6   = RDY   1=ready for command, 0=not ready yet
;       Bit 5   = DWF   1=fault occured inside drive
;       Bit 4   = DSC   1=seek complete
;       Bit 3   = DRQ   1=data request ready, 0=not ready to xfer yet
;       Bit 2   = ECC   1=correctable error occured
;       Bit 1   = IDX   vendor specific
;       Bit 0   = ERR   1=error occured
;
;------------------------------------------------------------------------------
; IDE Command Constants.  These should never change.
;
DEFC    __IDE_CMD_READ        =   $20 ;read with retry
DEFC    __IDE_CMD_WRITE       =   $30 ;write with retry

DEFC    __IDE_CMD_STANDBY     =   $E0 ;immediate spindown of disk
DEFC    __IDE_CMD_IDLE        =   $E1 ;immediate idle of disk
DEFC    __IDE_CMD_SLEEP       =   $E6 ;powerdown, reset to recover
DEFC    __IDE_CMD_CACHE_FLUSH =   $E7 ;flush hardware write cache
DEFC    __IDE_CMD_ID          =   $EC ;identify drive
