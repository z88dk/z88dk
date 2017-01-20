/*
 *      SD Card generic libraries
 *
 *      Stefano Bodrato - 2012
 *
 *		$Id: sdcard.h,v 1.9 2012-10-15 10:40:45 stefano Exp $
 * 
 */


#ifndef __SDCARD_H__
#define __SDCARD_H__

#include <sys/compiler.h>


// Commands for the SD/MMC card
#define	SD_GO_IDLE_STATE			0x40
#define	SD_SEND_OP_COND			0x41
#define	SD_ALL_SEND_CID			0x42
#define	SD_SET_RELATIVE_ADDR		0x43
#define	SD_SEND_RELATIVE_ADDR		0x43	// Alias
#define	SD_SET_DSR					0x44
#define	SD_SLEEP_AWAKE				0x45
#define SD_SWITCH					0x46
#define SD_SELECT_CARD				0x47
#define SD_SEND_EXT_CSD			0x48
#define	SD_READ_CSD				0x49
#define	SD_SEND_CSD				0x49	// Alias
#define	SD_READ_CID				0x4A
#define	SD_SEND_CID				0x4A	// Alias
#define	SD_READ_DAT_UNTIL_STOP		0x4B
#define	MCC_TERMINATE_MULTI_READ	0x4C
#define	SD_STOP_TRANSMISSION		0x4C	// Alias
#define SD_READ_STATUS				0x4D
#define SD_SEND_STATUS				0x4D	// Alias
#define SD_GO_INACTIVE_STATE		0x4F
#define	SD_SET_BLOCK_SIZE			0x50
#define SD_SET_BLOCKLEN			0x50	// Alias
#define	SD_READ_SINGLE_BLOCK		0x51
#define	SD_READ_BLOCK				0x51	// Alias
#define	SD_READ_MULTIPLE_BLOCK		0x52
#define	SD_WRITE_DAT_UNTIL_STOP	0x54
#define	SD_SET_BLOCK_COUNT			0x57
#define	SD_WRITE_SINGLE_BLOCK		0x58
#define	SD_WRITE_BLOCK				0x58	// Alias
#define	SD_WRITE_MULTIPLE_BLOCK	0x59
#define SD_PROGRAM_CID				0x5A
#define SD_PROGRAM_CSD				0x5B
#define SD_SET_WRITE_PROT			0x5C
#define SD_CLR_WRITE_PROT			0x5D
#define SD_SEND_WRITE_PROT			0x5E
#define SD_TAG_SECTOR_START		0x60
#define SD_TAG_SECTOR_END			0x61
#define SD_UNTAG_SECTOR			0x62
#define SD_TAG_ERASE_GROUP_START	0x63
#define SD_ERASE_GROUP_START		0x63	// Alias
#define SD_TAG_ERASE_GROUP_END		0x64
#define SD_ERASE_GROUP_END			0x64	// Alias
#define SD_UNTAG_ERASE_GROUP		0x65
#define SD_ERASE					0x66
#define SD_FAST_IO					0x67
#define SD_GO_IRQ_STATE			0x68
#define SD_LOCK_UNLOCK				0x6A
#define SD_APP_CMD					0x77
#define SD_GEN_CMD					0x78
#define SD_READ_OCR				0x7A
#define SD_SPI_READ_OCR			0x7A	// Alias
#define SD_CRC_ON_OFF				0x7B
#define SD_SPI_CRC_ON_OFF			0x7B	// Alias

// Data Tokens
#define SD_STARTBLOCK_READ			0xFE
#define SD_STARTBLOCK_WRITE		0xFE
#define SD_STARTBLOCK_MWRITE		0xFC
#define	SD_STOP_TRAN				0xFD
#define SD_STOPTRAN_WRITE			0xFD	// Alias


// Error codes (z88dk internals)
#define sd_error_spi_mode_failed		0x01

#define sd_error_mmc_init_failed		0x10
#define sd_error_sd_init_failed			0x11
#define sd_error_sdhc_init_failed		0x12
#define sd_error_vrange_bad				0x13
#define sd_error_check_pattern_bad		0x14

#define sd_error_illegal_command			0x20
#define sd_error_bad_command_response		0x21
#define sd_error_data_token_timeout			0x22
#define sd_error_write_timeout				0x23
#define sd_error_write_failed				0x24
#define sd_error_too_big					0x25


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

#define SD_INIT_ERROR -1



struct SD_INFO {
unsigned char	slot;		// 0, 1, etc..
unsigned char	port;		// SD_0 or SD_1 (as above, but specifies HW address)
unsigned char	flags;		// (sd_card_info) bit4: Block mode access, bit 0:3 card type (0:MMC,1:SD,2:SDHC)

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


#define SD_TYPE_MMC    0
#define SD_TYPE_SD     1
#define SD_TYPE_SDHC   2


// Initialize the SD card (Returns -1 on error, or ptr to card ID string)
extern char __LIB__  *sd_initialize(int slot);

// Initialize the SD card (0 = OK)
extern int __LIB__ sd_load(unsigned char slot, struct SD_INFO descriptor);

// Compute the SD/MMC card size (in bytes).
//  Valid only for SD and MMC and only if size is <= 2GB, otherwise 0.
extern unsigned long __LIB__  sd_size(struct SD_INFO descriptor);

// Compute the SD/MMC card size (in sectors).
extern unsigned long __LIB__  sd_sectors(struct SD_INFO descriptor);

// Given a linear address, read 512 bytes from the SD or MMC card (only for cards < 2GB)
extern int __LIB__            sd_read_block_2gb(struct SD_INFO descriptor, long sector, unsigned char *address);
extern int __LIB__  sd_read_block_2gb_callee(struct SD_INFO descriptor, long sector, unsigned char *address);

// Given a linear address, write 512 bytes to the SD or MMC  card (only for cards < 2GB)
extern int __LIB__            sd_write_block_2gb(struct SD_INFO descriptor, long sector, unsigned char *address);
extern int __LIB__  sd_write_block_2gb_callee(struct SD_INFO descriptor, long sector, unsigned char *address);

// Read a given sector from the SD card
extern int __LIB__            sd_read_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
extern int __LIB__  sd_read_sector_callee(struct SD_INFO descriptor, long sector, unsigned char *address);

// Write a given sector to the SD card
extern int __LIB__            sd_write_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
extern int __LIB__  sd_write_sector_callee(struct SD_INFO descriptor, long sector, unsigned char *address);

// Unpack bits to read CID or CSD or other, bit count begins on the less signigicant position
// of a 16 byte (128 bit) long block, thus on the rightmost bit
extern unsigned long __LIB__             UNSTUFF_BITS(unsigned char *data, unsigned int start, unsigned int size);
extern unsigned long __LIB__   UNSTUFF_BITS_callee(unsigned char *data, unsigned int start, unsigned int size);

#define sd_read_block_2gb(a,b,c)  sd_read_block_2gb_callee(a,b,c)
#define sd_write_block_2gb(a,b,c)  sd_write_block_2gb_callee(a,b,c)
#define sd_read_sector(a,b,c)  sd_read_sector_callee(a,b,c)
#define sd_write_sector(a,b,c)  sd_write_sector_callee(a,b,c)
#define UNSTUFF_BITS(a,b,c)    UNSTUFF_BITS_callee(a,b,c)


// Reserved functions, internal use only
//extern void __LIB__  sd_initialize(int card);
/*
extern void __LIB__ sd_deselect_card();
extern void __LIB__ sd_send_eight_clocks();
extern void __LIB__ sd_wait_data_token();
extern void __LIB__ pause_4ms();
// WIP, perhaps a card number parameter should be added
extern void __LIB__ sd_power_off();
extern void __LIB__ sd_power_on();
*/
// Asks CRT0 stub to reserve some service variables for SDCARD
#pragma output NEED_SDCARD

#endif /* __SDCARD_H__ */
