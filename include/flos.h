/*
 *      OSCA architecture - FLOS definitions
 *
 *      Stefano Bodrato - 2011
 *
 *		$Id: flos.h,v 1.1 2011-07-27 15:11:27 stefano Exp $
 * 
 */


#ifndef __FLOS_H__
#define __FLOS_H__

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

#define SPI_IDLE				0x01
#define SPI_ERASE_RESET			0x02
#define SPI_ILLEGAL_COMMAND		0x04
#define SPI_COM_CRC				0x08
#define SPI_ERASE_SEQ			0x10
#define SPI_ADDRESS				0x20
#define SPI_PARAMETER			0x40



// Get the FLOS OS version
extern void __LIB__ flos_version();


#endif /* __FLOS_H__ */
