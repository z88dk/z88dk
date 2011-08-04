/*
 *      OSCA architecture - FLOS definitions
 *
 *      Stefano Bodrato - 2011
 *
 *		$Id: flos.h,v 1.3 2011-08-04 14:10:12 stefano Exp $
 * 
 */


#ifndef __FLOS_H__
#define __FLOS_H__

#include <sys/compiler.h>
#include <sys/types.h>


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


// Errors coming from drivers are put in the highest byte, thus having values > than 0xFF

#define FERR_OK              0x00	// no errors 
#define FERR_DISK_FULL       0x01	// Volume Full
#define FERR_FILE_NOT_FOUND  0x02	// File Not Found
#define FERR_DIR_FULL        0x03	// Directory Full
#define FERR_NOT_DIR         0x04	// Not A Dir
#define FERR_DIR_NOT_EMPTY   0x05	// Dir Is Not Empty
#define FERR_NOT_FILE        0x06	// Not A File
#define FERR_EMPTY_FILE      0x07	// File Length Is Zero
#define FERR_OUT_OF_RANGE    0x08	// Address out of range
#define FERR_FILE_EXISTS     0x09	// File Name Already Exists
#define FERR_ROOT            0x0A	// Already at root
#define FERR_NO_FILE_NAME    0x0D	// No file name
#define FERR_INVALID_VOLUME  0x0E	// Invalid Volume
//#define FERR_INVALID_VOLUME  0x21	// Invalid Volume
#define FERR_NOT_FAT16       0x13	// not FAT16
#define FERR_NAME_TOO_LONG   0x15	// file name too long
#define FERR_EOF             0x1b	// requested bytes beyond end of file
#define FERR_NOT_PRESENT     0x22	// Device not present
#define FERR_DIR_NOT_FOUND   0x23	// Dir not found
#define FERR_FILE_NAME       0x25	// File name mismatch
#define FERR_NO_VOLUMES      0x28	// No Volumes


struct flos_capacity {
	u16_t	lsw;
	u8_t	msb;
};
	

struct flos_volume {
	u8_t	present;       //  1 = Volume is present, else zero (note: this does not mean it is a valid FAT16 volume.)
	u8_t	driver;        // Volume's host driver number
	u16_t	foo1;
	struct flos_capacity sectors;  // Volume's total capacity in sectors (3 bytes)
	u8_t	partition;     // Partition number on host drive (0/1/2/3)
	u8_t    boot_offset;   // Offset in sectors from MBR to partition boot sector (2 words, little endian)
	u16_t	foo2;
	u16_t	foo3;
};

struct flos_device {
	u8_t	driver;         // Device host driver number
	unsigned long capacity; // Device's TOTAL capacity in sectors (4 bytes)
	char    name[23];       // Zero terminated hardware name (22 ASCII bytes max followed by $00)
	char	foo[4];
};

struct flos_driver {
	char    name[8];       // 7 ASCII bytes, name of driver EG: "SD_CARD" + zero termination
	char	rd_sect[3];    // JP read_sector routine  
	char	wr_sect[3];    // JP write_sector routine  
	char	get_id[2];     // "get_id" routine starts here.  
};

struct flos_driver_table {
	struct flos_driver *driver0;
	struct flos_driver *driver1;
	struct flos_driver *driver2;
	struct flos_driver *driver3;
};

// Get the FLOS OS version
extern unsigned int __LIB__ flos_version();

// Get the OSCA architecture version
extern unsigned int __LIB__ osca_version();

// Video control
extern void __LIB__ page_in_video();
extern void __LIB__ page_out_video();
// Wait video HW to be ready
extern void __LIB__ wait_vrt();
extern int __LIB__ __FASTCALL__ flos_paper(int color);

// Disk control
extern int __LIB__ __FASTCALL__ change_volume(int volume);
extern struct flos_volume __LIB__ get_volume_list();
extern int __LIB__ get_volume_count();     // Total number of 'drives' (1..n)
extern int __LIB__ get_current_volume();   // Current 'drive' (0..n)
extern int __LIB__ check_volume_format();
extern unsigned long __LIB__ get_total_sectors();
// Directory related commands
extern int __LIB__ __FASTCALL__ delete_dir(char * dirname);
extern int __LIB__ parent_dir();
extern int __LIB__ root_dir();
extern int __LIB__ dir_move_first();
extern int __LIB__ dir_move_next();
extern int __LIB__ change_dir(char * dirname);
extern int __LIB__ dir_get_entry_type();  // 0=normal, 1=directory
extern int __LIB__ dir_get_entry_name();
extern unsigned long __LIB__ dir_get_entry_size();
extern void __LIB__ store_dir_position();
extern void __LIB__ restore_dir_position();
// FAT16 file handling
extern int __LIB__ __FASTCALL__ create_file(char * filename);
extern int __LIB__ __FASTCALL__ erase_file(char * filename);
extern int __LIB__ rename_file(char * filea, char * fileb);
extern unsigned long __LIB__ __FASTCALL__ get_file_size(char * filename);
extern unsigned int __LIB__ __FASTCALL__ get_first_file_cluster(char * filename);

// Drivers
extern struct flos_device __LIB__ get_device_list();
extern struct flos_driver_table __LIB__ get_driver_list();
extern int __LIB__ get_device_info();
extern int __LIB__ get_device_count();


#endif /* __FLOS_H__ */
