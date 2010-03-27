/*
 *      IDEDOS
 *
 *      Stefano Bodrato - Mar 2010
 *
 *		$Id: idedos.h,v 1.1 2010-03-27 18:59:26 stefano Exp $
 * 
 */


#ifndef __IDEDOS_H__
#define __IDEDOS_H__


// IDEDOS signature, for strncmp comparison
#define IDEDOS_SIGNATURE  "PLUSIDEDOS"
#define IDEDOS_SIGNATURE_LEN  10


// Partition types
#define		P_SYSTEM	0x01	// "Partition of partitions", starting at phisical sector 1 (cylinder 0, head 0 or 1).

#define		P_SWAP		0x02	// Swap partition.
#define		P_P3DOS		0x03	// +3DOS partition. The max size for just under 32MB. The XDPB has logical geometry.
#define		P_CPM		0x04	// CP/M partition with XDPB that reflects phisical disk structure. 
#define		P_BOOT		0x05	// Just code used to boot a hardware.  If found, the partition contents is loaded into RAM and started. 
#define		P_MOVIE		0x0F	// Movie partition. A sequence of screenshoots and optional sound track.
#define		P_FAT16		0x10	// MS-DOS (FAT16) partition.
#define		P_UZIX		0x20	// UZI(X) partition.
#define		P_TRDOS		0x30	// TR-DOS diskimage. Usual geometry 80/2/16, 640kB.
#define		P_SAMDOS	0x31	// +D/SAMDOS diskimage (B-DOS record: swapped L/H bytes!). Geometry 80/2/10, 800kB.
#define		P_MB02		0x32	// MB-02 diskimage. Usual goeometry 82/2/11, 1804kB.
#define		P_TOSA2		0x33	// TOS A.2 diskimage. Usual goeometry 40/1/16, 160kB or 80/2/16, 640kB.

// CP/M format partitions used for non-CP/M purposes.
#define		P_ZXP3		0x40	// ZX Spectrum +3 diskimages.
#define		P_ELWRO800	0x41	// Elwro 800 Junior diskimages.
#define		P_CPC		0x48	// Amstrad CPC diskimages.
#define		P_PCW		0x48	// Amstrad PCW diskimages.

#define		P_UNUSED	0x00	// Unused partition/free handle
#define		P_BAD		0xFE	// Bad disk space.
#define		P_FREE		0xFF	// Free disk space.


// Partition table entry
struct IDEDOS_PARTITION {
char			name[16];		// Partition name (case-insensitive, sometimes space-padded).

unsigned char	type;			// Partition type (0=free handle).
unsigned int	start_cyl;		// Starting cylinder.
unsigned char	start_head;		// Starting head.
unsigned int	end_cyl;		// Ending cylinder.
unsigned char	end_head;		// Ending head.
unsigned long	last_sector;	// Largest logical sector number.

unsigned char	shift;			// Shift from sector 1 of partition start (0 for no shift).
unsigned char	v_sector;		// Virtual sector size (0-128B, 1-256B, 2-512B, 3-1kB).
unsigned char	v_first_sector;	// Virtual first sector number (0..240).
unsigned char	v_heads;		// Virtual heads (1, 2, more?).
unsigned char	v_sectors;		// Virtual sectors (usually 5, 8, 9, 16, 18).
unsigned char	extra[32];		// Type-specific information. For example XDPB, movie format.
};

// IDEDOS system partition extra data (type 1)
struct IDEDOS_SYSTEM_EXTRA {
unsigned int	cyls;			// Number of cylinders
unsigned char	heads;			// Number of heads
unsigned char	spt;			// Sectors Per Track
unsigned int	spc;			// Sectors Per Cylinder
unsigned int	max_part;		// Maximum number of partitions including the system one
};
					
#endif /* __IDEDOS_H__ */
