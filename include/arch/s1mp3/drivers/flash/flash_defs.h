/*
	02/03/2006 03:15
	fc: added constructors ids.
*/

#ifndef __FLASH_DEFS_H__
#define __FLASH_DEFS_H__


#define FLASH_TYPE_AMD         0x01
#define FLASH_TYPE_AMI         0x02
#define FLASH_TYPE_FUJITSU     0x04
#define FLASH_TYPE_HITACHI     0x07
#define FLASH_TYPE_INMOS       0x08
#define FLASH_TYPE_INTERSIL    0x0b
#define FLASH_TYPE_MOSTEK      0x0d
#define FLASH_TYPE_MOTOROLA    0x0e
#define FLASH_TYPE_NEC         0x10
#define FLASH_TYPE_ROCKWELL    0x13	/* Conexant */
#define FLASH_TYPE_PHILIPS     0x15
#define FLASH_TYPE_SYNERTEK    0x16
#define FLASH_TYPE_XICOR       0x19
#define FLASH_TYPE_ZILOG       0x1a
#define FLASH_TYPE_MITSUBISHI  0x1c
#define FLASH_TYPE_ATMEL       0x1f
#define FLASH_TYPE_STMICRO     0x20	/* STM / Thomson */
#define FLASH_TYPE_WAFERSCALE  0x23	/* Wafer scale integration */
#define FLASH_TYPE_TRISTAR     0x25
#define FLASH_TYPE_VISIC       0x26
#define FLASH_TYPE_MICROCHIP   0x29	/* Microchip technology */
#define FLASH_TYPE_RICOH       0x2a
#define FLASH_TYPE_MICRON      0x2c	/* Micron technology */
#define FLASH_TYPE_ACTEL       0x2f
#define FLASH_TYPE_CATALYST    0x31
#define FLASH_TYPE_PANASONIC   0x32
#define FLASH_TYPE_CYPRESS     0x34
#define FLASH_TYPE_ZARLINK     0x37     /* Plessey */
#define FLASH_TYPE_UTMC        0x38
#define FLASH_TYPE_INTCMOS     0x3b     /* Vertex */
#define FLASH_TYPE_TEKTRONIX   0x3d
#define FLASH_TYPE_SUN         0x3e
#define FLASH_TYPE_MOSEL       0x40
#define FLASH_TYPE_XEROX       0x43
#define FLASH_TYPE_SUNDISK     0x45
#define FLASH_TYPE_ECT         0x46     /* Elan circuit tech */
#define FLASH_TYPE_XILINX      0x49
#define FLASH_TYPE_COMPAQ      0x4a
#define FLASH_TYPE_SCI         0x4c
#define FLASH_TYPE_I3DS        0x4f	/* I3 Design system */
#define FLASH_TYPE_CROSSPOINT  0x51     /* Crosspoint solutions */
#define FLASH_TYPE_ALLIANCE    0x52     /* Alliance semiconductor */
#define FLASH_TYPE_HP          0x54     /* Hewlett packard */
#define FLASH_TYPE_NEWMEDIA    0x57
#define FLASH_TYPE_MHS         0x58
#define FLASH_TYPE_KAWASAKI    0x5b     /* Kawasaki steel */
#define FLASH_TYPE_TECMAR      0x5d
#define FLASH_TYPE_EXAR        0x5e
#define FLASH_TYPE_NORTHERNTEL 0x61     /* Northern telecom */
#define FLASH_TYPE_SANYO       0x62
#define FLASH_TYPE_CRYSTALSC   0x64     /* Crystal semiconductor */
#define FLASH_TYPE_ASPARIX     0x67
#define FLASH_TYPE_CONVEX      0x68     /* Convex computer */
#define FLASH_TYPE_TRANSWITCH  0x6b
#define FLASH_TYPE_CANNON      0x6d
#define FLASH_TYPE_ALTERA      0x6e
#define FLASH_TYPE_QUALCOMM    0x70
#define FLASH_TYPE_AMS         0x73     /* Austra micro */
#define FLASH_TYPE_ASTER       0x75     /* Aster electronics */
#define FLASH_TYPE_BAYNET      0x76     /* Bay networks */
#define FLASH_TYPE_THESYS      0x79
#define FLASH_TYPE_SOLBOURNE   0x7a     /* Solbourne computer */
#define FLASH_TYPE_DIALOG      0x7c
#define FLASH_TYPE_FAIRCHILD   0x83
#define FLASH_TYPE_GTE         0x85
#define FLASH_TYPE_HARRIS      0x86
#define FLASH_TYPE_INTEL       0x89
#define FLASH_TYPE_ITT         0x8a
#define FLASH_TYPE_MONOLITHIC  0x8c     /* Monolithic memories */
#define FLASH_TYPE_NATSEMI     0x8f     /* National semiconductor */
#define FLASH_TYPE_RCA         0x91
#define FLASH_TYPE_RAYTHEON    0x92
#define FLASH_TYPE_SEEQ        0x94
#define FLASH_TYPE_TEXAS       0x97     /* Texas instruments */
#define FLASH_TYPE_TOSHIBA     0x98
#define FLASH_TYPE_EUROTECH    0x9b     /* Eurotechnique */
#define FLASH_TYPE_LUCENT      0x9d
#define FLASH_TYPE_EXEL        0x9e
#define FLASH_TYPE_LATTICE     0xa1     /* Lattice semiconductor */
#define FLASH_TYPE_NCR         0xa2
#define FLASH_TYPE_IBM         0xa4
#define FLASH_TYPE_INTLCMOS    0xa7     /* Intl. CMOS Technology */
#define FLASH_TYPE_SSSI        0xa8
#define FLASH_TYPE_VLSI        0xab
#define FLASH_TYPE_HYNIX       0xad     /* Hyundai Electronics */
#define FLASH_TYPE_OKI         0xae     /* OKI Semiconductor */
#define FLASH_TYPE_SHARP       0xab
#define FLASH_TYPE_IDT         0xb3
#define FLASH_TYPE_DEC         0xb5
#define FLASH_TYPE_LSILOGIC    0xb6
#define FLASH_TYPE_THINKING    0xb9     /* Thinking machine */
#define FLASH_TYPE_THOMSON     0xba     /* Thomson CSF */
#define FLASH_TYPE_HONEYWELL   0xbc
#define FLASH_TYPE_SST         0xbf
#define FLASH_TYPE_INFINEON    0xc1     /* Siemens */
#define FLASH_TYPE_MACRONIX    0xc2
#define FLASH_TYPE_PLUSLOGIC   0xc4
#define FLASH_TYPE_EUROPEAN    0xc7     /* European silicon */
#define FLASH_TYPE_APPLE       0xc8     /* Apple computer */
#define FLASH_TYPE_PROTOCOL    0xcb     /* Protocol engines */
#define FLASH_TYPE_SEIKO       0xcd     /* Seiko instruments */
#define FLASH_TYPE_SAMSUNG     0xce
#define FLASH_TYPE_KLIC        0xd0
#define FLASH_TYPE_TANDEM      0xd3
#define FLASH_TYPE_ISILICON    0xd5     /* Intg. silicon solutions */
#define FLASH_TYPE_BROOKTREE   0xd6
#define FLASH_TYPE_PERFSEMI    0xd9     /* Performance semi. */
#define FLASH_TYPE_WINBOND     0xda     /* Winbond electronic */
#define FLASH_TYPE_BRIGHTMICRO 0xdc
#define FLASH_TYPE_PCMCIA      0xdf
#define FLASH_TYPE_LGSEMI      0xe0
#define FLASH_TYPE_ARRAY       0xe3     /* Array microsystems */
#define FLASH_TYPE_ANALOGDEV   0xe5     /* Analog devices */
#define FLASH_TYPE_PCMSIERRA   0xe6
#define FLASH_TYPE_QUALITYSEMI 0xe9
#define FLASH_TYPE_NIMBUSTECH  0xea
#define FLASH_TYPE_MICRONAS    0xec
#define FLASH_TYPE_NEXCOM      0xef
#define FLASH_TYPE_SONY        0xf1
#define FLASH_TYPE_CRAY        0xf2     /* Cray research */
#define FLASH_TYPE_VITESSE     0xf4
#define FLASH_TYPE_ZENTRUM     0xf7
#define FLASH_TYPE_TRW         0xf8
#define FLASH_TYPE_ALLIEDSIGN  0xfb     /* Allied signal */
#define FLASH_TYPE_MEDIAVISION 0xfd
#define FLASH_TYPE_LEVELONE    0xfe

#define FLASH_TYPE_32Mbyte     0x75     /* 32MByte */
#define FLASH_TYPE_64Mbyte     0x76     /* 64MByte */
#define FLASH_TYPE_128Mbyte    0x79     /* 128MByte */
#define FLASH_TYPE_128Mbyte2   0xf1     /* 128Mbyte Hynix HY27UF081G2M */
#define FLASH_TYPE_256Mbyte    0x71     /* 256MByte */
#define FLASH_TYPE_256Mbyte2   0xda     /* 256MByte */
#define FLASH_TYPE_512Mbyte    0xdc     /* 512Mbyte Samsung K9K4G08U0M */
#define FLASH_TYPE_1024Mbyte   0xd3     /* 1GByte   Samsung K9WAG08U1M */
#define FLASH_TYPE_2048Mbyte   0xd5     /* 2GByte */

#define FLASH_DENSITY_SINGLE                    0x00
#define FLASH_DENSITY_SPECIAL_TOSHIBA           0x01
#define FLASH_DENSITY_DUAL                      0x02

#define FLASH_COMMAND_DISABLE                   0x37
#define FLASH_COMMAND_READID                    0x90
#define FLASH_COMMAND_READID_TOSHIBA_EXTENDED   0x91
#define FLASH_COMMAND_RESET                     0xff
#define FLASH_COMMAND_READ_STATUS_REGISTER      0x70
#define FLASH_COMMAND_RANDOM_DATA_INPUT         0x85
#define FLASH_COMMAND_CACHE_READ_EXIT           0x34

#define FLASH_COMMAND1_READ1                    0x00
#define FLASH_COMMAND2_READ1                    0x30
#define FLASH_COMMAND1_READ_FOR_COPY_BACK       0x00
#define FLASH_COMMAND2_READ_FOR_COPY_BACK       0x35
#define FLASH_COMMAND1_PAGE_PROGRAM_START       0x80
#define FLASH_COMMAND2_PAGE_PROGRAM_START       0x10
#define FLASH_COMMAND1_COPY_BACK_PGM_START      0x85
#define FLASH_COMMAND2_COPY_BACK_PGM_START      0x10
#define FLASH_COMMAND1_CACHE_PROGRAM            0x80
#define FLASH_COMMAND2_CACHE_PROGRAM            0x15
#define FLASH_COMMAND1_BLOCK_ERASE              0x60
#define FLASH_COMMAND2_BLOCK_ERASE              0xd0
#define FLASH_COMMAND1_RANDOM_DATA_OUTPUT       0x05
#define FLASH_COMMAND2_RANDOM_DATA_OUTPUT       0xe0
#define FLASH_COMMAND1_CACHE_READ_START         0x00
#define FLASH_COMMAND2_CACHE_READ_START         0x31

/* Status Register Coding */
#define FLASH_STATUS_PAGE_PROGRAM_PASS      0x00
#define FLASH_STATUS_BLOCK_ERASE_PASS       0x00
#define FLASH_STATUS_CACHE_PROGRAM_PASS     0x00

#define FLASH_STATUS_CACHE_PROGRAM_PREVIOUS_PASS    0x01

#define FLASH_STATUS_PAGE_PROGRAM_ACTIVE        0x05
#define FLASH_STATUS_BLOCK_ERASE_ACTIVE         0x05
#define FLASH_STATUS_CACHE_PROGRAM_CONTROLLER   0x05
#define FLASH_STATUS_BLOCK_READ_ACTIVE          0x05
#define FLASH_STATUS_CACHE_READ_CONTROLLER      0x05

#define FLASH_STATUS_PAGE_PROGRAM_READY         0x06
#define FLASH_STATUS_BLOCK_ERASE_READY          0x06
#define FLASH_STATUS_CACHE_PROGRAM_REGISTER     0x06
#define FLASH_STATUS_BLOCK_READ_READY           0x06
#define FLASH_STATUS_CACHE_READ_READY           0x06

#define FLASH_STATUS_WRITE_PROTECT                  0x07

#define NAND_ENABLE_CE1 0x01
#define NAND_ENABLE_CE2 0x02
#define NAND_ENABLE_CE3 0x03
#define NAND_ENABLE_CE4 0x04
#define NAND_ENABLE_CE5 0x05
#define NAND_ENABLE_CE6 0x06

/* Error codes for flash status */
#define FLASH_STATUS_ERROR                      0x03
#define FLASH_STATUS_WRITE_PROTECTED            0x02
#define FLASH_STATUS_OK                         0x00

/* Error codes for determining flash types */
#define FLASH_TYPE_ERROR                        0xff
#define FLASH_TYPE_ERROR2                       0x03

/* Flash storage area definitions */
#define FLASH_MAX_DEVICES                       0x06   /* 6 possible flash devices */
#define FLASH_INFO_STORAGE_SIZE                 0x02   /* 2 bytes per flash device */

#define FLASH_SECTORSIZE_0x00FC                 0x00fc
#define FLASH_SECTORSIZE_0x01F8                 0x01f8
#define FLASH_SECTORSIZE_0x03F0                 0x03f0
#define FLASH_SECTORSIZE_0x07E0                 0x07e0
#define FLASH_SECTORSIZE_0x0FC0                 0x0fC0
#define FLASH_SECTORSIZE_0x1080                 0x1080
#define FLASH_SECTORSIZE_0x2100                 0x2100

#endif /* __FLASH_DEFS_H__ */

