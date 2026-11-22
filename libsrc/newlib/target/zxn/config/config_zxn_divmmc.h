// ------------------------------------------
// DivMMC entry points
// ------------------------------------------

// Enable automap on an instruction fetch from each rst address
#define REG_DIVMMC_ENTRY_POINTS_0 0xB8

// Automap always on that address (1) or only when rom3 is present (0)
#define REG_DIVMMC_ENTRY_POINTS_VALID_0 0xB9

// Instant (1) or delayed (0) mapping on that address
#define REG_DIVMMC_ENTRY_POINTS_TIMING_0 0xBA

// Bits of the three registers above (one per rst address)
#define RDEP0_ADDRESS_0000 0x01
#define RDEP0_ADDRESS_0008 0x02
#define RDEP0_ADDRESS_0010 0x04
#define RDEP0_ADDRESS_0018 0x08
#define RDEP0_ADDRESS_0020 0x10
#define RDEP0_ADDRESS_0028 0x20
#define RDEP0_ADDRESS_0030 0x40
#define RDEP0_ADDRESS_0038 0x80

// Automap on the remaining entry points
#define REG_DIVMMC_ENTRY_POINTS_1 0xBB

// Enable automap on 0x3dxx for TRDOS (instant and rom3 only)
#define RDEP1_TRDOS_3DXX 0x80

// Disable automap on 0x1ff8-0x1fff (delayed)
#define RDEP1_DISABLE_1FF8 0x40

// Enable automap on the NextZXOS tape traps 0x056a and 0x04d7 (delayed and rom3 only)
#define RDEP1_NEXTZXOS_TAPE_056A 0x20
#define RDEP1_NEXTZXOS_TAPE_04D7 0x10

// Enable automap on the esxdos and original DivMMC tape traps 0x0562 and 0x04c6 (delayed and rom3 only)
#define RDEP1_ESXDOS_TAPE_0562 0x08
#define RDEP1_ESXDOS_TAPE_04C6 0x04

// Enable automap on 0x0066 with the nmi button (instant or delayed)
#define RDEP1_NMI_0066_INSTANT 0x02
#define RDEP1_NMI_0066_DELAYED 0x01
