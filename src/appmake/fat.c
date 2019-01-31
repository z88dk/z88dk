
#include "appmake.h"

#include "ff.h"			/* Obtains integer types */
#include "diskio.h"		/* Declarations of disk functions */

static int fat_write_file_to_image(const char *disc_format, const char *container, const char* output_file, const char* binary_name, const char* crt_filename, const char* boot_filename);

static char             *c_binary_name      = NULL;
static char             *c_crt_filename      = NULL;
static char             *c_disc_format       = NULL;
static char             *c_output_file      = NULL;
static char             *c_boot_filename     = NULL;
static char             *c_disc_container    = "dsk";
static char              help         = 0;



/* Options that are available for this module */
option_t fat_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'f', "format",   "Disk format",                OPT_STR,   &c_disc_format},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &c_binary_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &c_crt_filename },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &c_output_file },
    { 's', "bootfile", "Name of the boot file",      OPT_STR,   &c_boot_filename },
    {  0,  "container", "Type of container (raw,dsk)", OPT_STR, &c_disc_container },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static cpm_discspec dsdd_fat12 = {
    .name = "FAT12-DSDD",
    .sectors_per_track = 9,
    .tracks = 80,
    .sides = 2,
    .sector_size = 512,
    .gap3_length = 0x2a,
    .filler_byte = 0xe5,
    .boottracks = 0,
    .directory_entries = 0,
    .extent_size = 2048
};


int fat_exec(char *target)
{
    if (help)
        return -1;
    if (c_binary_name == NULL) {
        return -1;
    }
    if (c_disc_format == NULL || c_disc_container == NULL ) {
        return -1;
    }
    return fat_write_file_to_image(c_disc_format, c_disc_container, c_output_file, c_binary_name, c_crt_filename, c_boot_filename);
}

static cpm_handle* h;

int fat_write_file_to_image(const char *disc_format, const char *container, const char* output_file, const char* binary_name, const char* crt_filename, const char* boot_filename)
{
    char          buf[1024];
    cpm_discspec* spec = &dsdd_fat12;
    char *disc_name = "a.raw";
    int (*writer)(cpm_handle *h, const char *filename) = cpm_write_raw;
    int ret;

    h = cpm_create(spec);

    ret = f_mkfs("1", FM_FAT, 1024, buf, sizeof(buf));
	printf("Mkfs gave %d\n",ret);

    if (writer(h, disc_name) < 0) {
        exit_log(1, "Can't write disc image");
    }
    cpm_free(h);
    return 0;
}




/*-----------------------------------------------------------------------*/
/* Get Drive Status                                                      */
/*-----------------------------------------------------------------------*/

DSTATUS disk_status (
	BYTE pdrv		/* Physical drive nmuber to identify the drive */
)
{
    return RES_OK;
}



/*-----------------------------------------------------------------------*/
/* Inidialize a Drive                                                    */
/*-----------------------------------------------------------------------*/

DSTATUS disk_initialize (
	BYTE pdrv				/* Physical drive nmuber to identify the drive */
)
{
    return RES_OK;
}



/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/

DRESULT disk_read (
	BYTE pdrv,		/* Physical drive nmuber to identify the drive */
	BYTE *buff,		/* Data buffer to store read data */
	DWORD sector,	/* Start sector in LBA */
	UINT count		/* Number of sectors to read */
)
{
    cpm_read_sector_lba(h, sector, count, buff);

    return RES_OK;
}



/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/

#if FF_FS_READONLY == 0

DRESULT disk_write (
	BYTE pdrv,			/* Physical drive nmuber to identify the drive */
	const BYTE *buff,	/* Data to be written */
	DWORD sector,		/* Start sector in LBA */
	UINT count			/* Number of sectors to write */
)
{
    cpm_write_sector_lba(h, sector, count, buff);

    return RES_OK;
}

#endif


/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/

DRESULT disk_ioctl (
	BYTE pdrv,		/* Physical drive nmuber (0..) */
	BYTE cmd,		/* Control code */
	void *buff		/* Buffer to send/receive control data */
)
{
    int    val;
    switch ( cmd ) {
    case GET_SECTOR_COUNT:
        val = cpm_get_sector_count(h);
	printf("Get sector count %d\n",val);
        *(DWORD *)buff = val;
        break;

    case GET_SECTOR_SIZE:
    case GET_BLOCK_SIZE:
        val = cpm_get_sector_size(h);
        *(WORD *)buff = val;
        break;
    }
    return RES_OK;
}

