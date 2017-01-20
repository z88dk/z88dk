/*
 *      ZXMMC / ZXMMC+ / Badaloc (ZX Spectrum clone) libs
 *
 *      Stefano Bodrato - Feb. 2010
 *
 *		$Id: zxmmc.h,v 1.4 2016-06-11 19:53:08 dom Exp $
 * 
 */


#ifndef __ZXMMC_H__
#define __ZXMMC_H__

#include <sys/compiler.h>


// Commands for the SD/MMC card
#define	MMC_GO_IDLE_STATE			0x40
#define	MMC_SEND_OP_COND			0x41
#define	MMC_ALL_SEND_CID			0x42
#define	MMC_SET_RELATIVE_ADDR		0x43
#define	MMC_SEND_RELATIVE_ADDR		0x43	// Alias
#define	MMC_SET_DSR					0x44
#define	MMC_SLEEP_AWAKE				0x45
#define MMC_SWITCH					0x46
#define MMC_SELECT_CARD				0x47
#define MMC_SEND_EXT_CSD			0x48
#define	MMC_READ_CSD				0x49
#define	MMC_SEND_CSD				0x49	// Alias
#define	MMC_READ_CID				0x4A
#define	MMC_SEND_CID				0x4A	// Alias
#define	MMC_READ_DAT_UNTIL_STOP		0x4B
#define	MCC_TERMINATE_MULTI_READ	0x4C
#define	MMC_STOP_TRANSMISSION		0x4C	// Alias
#define MMC_READ_STATUS				0x4D
#define MMC_SEND_STATUS				0x4D	// Alias
#define MMC_GO_INACTIVE_STATE		0x4F
#define	MMC_SET_BLOCK_SIZE			0x50
#define MMC_SET_BLOCKLEN			0x50	// Alias
#define	MMC_READ_SINGLE_BLOCK		0x51
#define	MMC_READ_BLOCK				0x51	// Alias
#define	MMC_READ_MULTIPLE_BLOCK		0x52
#define	MMC_WRITE_DAT_UNTIL_STOP	0x54
#define	MMC_SET_BLOCK_COUNT			0x57
#define	MMC_WRITE_SINGLE_BLOCK		0x58
#define	MMC_WRITE_BLOCK				0x58	// Alias
#define	MMC_WRITE_MULTIPLE_BLOCK	0x59
#define MMC_PROGRAM_CID				0x5A
#define MMC_PROGRAM_CSD				0x5B
#define MMC_SET_WRITE_PROT			0x5C
#define MMC_CLR_WRITE_PROT			0x5D
#define MMC_SEND_WRITE_PROT			0x5E
#define MMC_TAG_SECTOR_START		0x60
#define MMC_TAG_SECTOR_END			0x61
#define MMC_UNTAG_SECTOR			0x62
#define MMC_TAG_ERASE_GROUP_START	0x63
#define MMC_ERASE_GROUP_START		0x63	// Alias
#define MMC_TAG_ERASE_GROUP_END		0x64
#define MMC_ERASE_GROUP_END			0x64	// Alias
#define MMC_UNTAG_ERASE_GROUP		0x65
#define MMC_ERASE					0x66
#define MMC_FAST_IO					0x67
#define MMC_GO_IRQ_STATE			0x68
#define MMC_LOCK_UNLOCK				0x6A
#define MMC_APP_CMD					0x77
#define MMC_GEN_CMD					0x78
#define MMC_READ_OCR				0x7A
#define MMC_SPI_READ_OCR			0x7A	// Alias
#define MMC_CRC_ON_OFF				0x7B
#define MMC_SPI_CRC_ON_OFF			0x7B	// Alias

// Data Tokens
#define MMC_STARTBLOCK_READ			0xFE
#define MMC_STARTBLOCK_WRITE		0xFE
#define MMC_STARTBLOCK_MWRITE		0xFC
#define	MMC_STOP_TRAN				0xFD
#define MMC_STOPTRAN_WRITE			0xFD	// Alias


// MMC/SD in SPI mode reports two status bytes for SEND_STATUS
// and only one status byte in all the other cases.

/* SD/MMC states */
#define STATE_IDLE  0		// Idle state, after power on or GO_IDLE_STATE command
#define STATE_READY 1		// Ready state, after card replies non-busy to SD_APP_OP_COND
#define STATE_IDENT 2		// Identification state, after ALL_SEND_CID
#define STATE_STBY  3		// Standby state, when card is deselected
#define STATE_TRAN  4		// Transfer state, after card is selected and ready for data transfer
#define STATE_DATA  5		// 
#define STATE_RCV   6		// Receive data state
#define STATE_PRG   7		// Programming state
#define STATE_DIS   8		// Disconnect state
#define STATE_INA   9		// Inactive state, after GO_INACTIVE_STATE

#define CARD_BUSY 0xff

#define SPI_IDLE				0x01
#define SPI_ERASE_RESET			0x02
#define SPI_ILLEGAL_COMMAND		0x04
#define SPI_COM_CRC				0x08
#define SPI_ERASE_SEQ			0x10
#define SPI_ADDRESS				0x20
#define SPI_PARAMETER			0x40


// Values for shadow ROM paging
#define ROM_STANDARD			0
#define ROM_NMI_PATCHED			0x62
#define ROM_NMI_PATCHED_128		0x67



struct MMC {
unsigned char	slot;		// 0 or 1
unsigned char	port;		// MMC_0 or MMC_1

// CID - Card Identification section (overall 16 bytes)
unsigned char	CID[1];		// First byte in CID is the Manufacturer ID (MID)
char			name[7];	// OEM/Application ID + PNM, product Name
unsigned char	PRV;		// Product Revision (BCD, Firmware.Hardware)
unsigned char	PSN[4];		// Product serial number
unsigned char	MDT[2];		// Manufacturer date code (BCD, second byte used for month/year + 1997 [or + 2000])
unsigned char	CID_CRC;	// CRC byte

// CSD - (overall 16 bytes + 2 spare) - it will need to be decoded with specific functions
unsigned char	CSD[16];	// Two higher bits should be set to 0
int				csdfoo;		// Terminate with two extra bytes, to avoid overflows.
};




// Set the ROM page
extern int __LIB__  mmc_fastpage(unsigned char page) __z88dk_fastcall;

// Initialize the MMC card (0 = OK, 1 = Card RESET ERROR, 2 = Card INIT ERROR, 3 = UNKNOWN RESPONSE)
extern int __LIB__ mmc_load(unsigned char slot, struct MMC descriptor) __smallc;

// Send a command to the MMC card
extern int __LIB__ mmc_command(struct MMC mmc_descriptor, unsigned char command, long parameter, unsigned char checksum) __smallc;

// Compute the SD/MMC card size (in bytes).  Valid only if size is <= 2GB, otherwise 0.
extern unsigned long __LIB__  mmc_size(struct MMC mmc_descriptor) __z88dk_fastcall;

// Wait for a response code from the latest command issued to ZXMMC
// extern int __LIB__ mmc_wait_response();  // cs_low somewhere..

// Wait for the data being transferred ($FE), if anything goes wrong get the err. code or $FF if timeout.
extern int __LIB__ mmc_waitdata_token();

// Read multiple 512 byte data blocks from the MMC card (fastest way)
extern int __LIB__ mmc_read_multidata(struct MMC mmc_descriptor, long card_address, unsigned char *address, int block_count) __smallc;

// Read 512 bytes from the MMC card
extern int __LIB__ mmc_read_block(struct MMC mmc_descriptor, long card_address, unsigned char *address) __smallc;

// Write a 512 byte data block to the MMC card
extern int __LIB__ mmc_write_block(struct MMC mmc_descriptor, long card_address, unsigned char *address) __smallc;


// Asks CRT0 stub to reserve some service variables for ZXMMC
#pragma output NEED_ZXMMC

#endif /* __ZXMMC_H__ */
