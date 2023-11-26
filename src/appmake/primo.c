/*
 *      Short program to create a Primo .pri file
 *
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *extfile      = NULL;
static char             *type         = "pri";
static char             *ptpname      = NULL;
static char              help         = 0;

/* Options that are available for this module */
option_t primo_options[] = {
    { 'h', "help",     "Display this help",                 OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",                OPT_STR,   &binname },
    { 'o', "output",   "Name of output file (input name)",  OPT_STR,   &outfile },
    { 'e', "ext",      "Extension of output file (.pri)",   OPT_STR,   &extfile },
    { 't', "type",     "Type of generated primo executable (pri|ptp), default is pri", 
                                                            OPT_STR,   &type },
    { 'n', "ptpname",  "File name in ptp file",             OPT_STR,   &ptpname},
    {  0,  NULL,       NULL,                                OPT_NONE,  NULL }
};

void writePriFile(FILE *fpin, FILE *fpout, int len) {
    writebyte(0xD9,fpout); // Assembly block
    writeword(0x4400,fpout); // Start Address 
    writeword(len, fpout); // len of data in block
    for (int i = 0, c; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }
    writebyte(0xC3,fpout); // Assembly execution
    writeword(0x4400,fpout); // Jump to start Address 
}

typedef struct {
    char ptp_start_byte;
    uint16_t  ptp_size;
} ptphdr_t;

typedef struct {
    char type;
    char bn;
    char ns;
    char *name;
    char crc;
    uint16_t blksize;
} blk_name_t;

typedef struct {
    char type;
    char bn;
    char crc;
    uint16_t blksize;
} blk_close_t;

typedef struct  {
    char type;
    char bn;
    uint16_t load_address;
    char nb;
    char *data;
    char crc;
    uint16_t blksize;
} blk_data_t;

typedef struct blk_chain_t {
    char *block;
    struct blk_chain_t *next;
} blk_chain_t;

blk_chain_t *ptp_blks_head = NULL;
blk_chain_t *ptp_blks_tail = NULL;

void add_ptp_block(char *blk) {
    blk_chain_t *item = (blk_chain_t *)malloc(sizeof(blk_chain_t));
    item->block = blk;
    item->next = NULL;
    if(ptp_blks_head == NULL) {
        ptp_blks_head = ptp_blks_tail = item;
    } else {
        ptp_blks_tail->next = item;
        ptp_blks_tail = item;
    }
}

char calc_datablk_crc(blk_data_t *datablk) {
    int crc = 0;
    crc += datablk->bn;
    crc += datablk->load_address % 256;
    crc += datablk->load_address / 256;
    crc += datablk->nb;
    int l = datablk->nb==0 ? 256 : ((int)datablk->nb & 0xff);
    for(int i=0; i<l; i++)
        crc += datablk->data[i];
    
    return crc % 256;
}

char dec2bcd(char num) {
    return (num/10)*16 + num%10;
}

ptphdr_t *add_ptp_header(void) {
    ptphdr_t *ptphdr = (ptphdr_t *)malloc(sizeof(ptphdr_t));
    ptphdr->ptp_start_byte = (char)0xff;
    ptphdr->ptp_size = 0;
    add_ptp_block((char *)ptphdr);
    return ptphdr;
}

blk_name_t *add_name_blk(char *ptpname) {
    blk_name_t *nameblk = (blk_name_t *)malloc(sizeof(blk_name_t));
    int crc = 0;
    nameblk->type = (char)0x83;       // BASIC prg name block
    nameblk->bn = 0x00;    // always 0x00
    nameblk->ns = (int)strlen(ptpname);
    nameblk->name = ptpname;
    crc+=nameblk->ns;
    for(int i=0; i<strlen(ptpname); i++)
        crc += ptpname[i];
    nameblk->crc = crc % 256;
    nameblk->blksize = 4 + (int)strlen(ptpname);
    add_ptp_block((char *)nameblk);
    return nameblk;
}

blk_data_t *add_fixmem_data_blk(uint16_t *free_mem_start) {
    blk_data_t *datablk = (blk_data_t *)malloc(sizeof(blk_data_t));
    datablk->type = (char)0xf9;   // 'assembly' block
    datablk->bn = 0x01;
    datablk->load_address = 0x40F9;
    datablk->nb = 2;
    datablk->data = (char *) free_mem_start;
    datablk->crc = calc_datablk_crc(datablk);
    datablk->blksize = 8;
    add_ptp_block((char *)datablk);
    return datablk;
}

    // BASIC boot up code: 10 a=call(17408) - Call $4400
    // f9 43  - start of next line at 43ea
    // 0a 00  - line number
    // 41 d5  -  a=
    // c1 28  -  CALL(
    // 31 37 34 30 38  - 17408
    // 29     -  )
    // 00     - end of line
    // 00 00  - end of program at $43f9
    char basichdr[] =  {(char)0xf9, 0x43, 0x0a, 0x00, 0x41, (char)0xd5, (char)0xc1, 0x28, 0x31, 0x37, 0x34, 0x30, 
                        0x38, 0x29, 0x00, 0x00, 0x00, 
                        0x5a, 0x38, 0x38, 0x44, 0x4b}; // z88dk
blk_data_t *add_basicboot_data_blk(void) {
    blk_data_t *datablk = (blk_data_t *)malloc(sizeof(blk_data_t));
    datablk->type = (char)0xf1;   // BASIC program block
    datablk->bn = 0x02;
    datablk->load_address = 0x0000;
    datablk->nb = 22;
    datablk->data = basichdr;
    datablk->crc = calc_datablk_crc(datablk);
    datablk->blksize = 6 + 22;
    add_ptp_block((char *)datablk);
    return datablk;
}

int add_data_blks(FILE *infile, int len, int *blknum) {
    int addr_offset = 22;
    int blk_size_sum = 0;
    while(len>0) {
        int readlen = len>256 ? 256 : len;
        len-=readlen;
        char *databuf = (char *)malloc(readlen);
        for(int i=0; i<readlen; i++)
            databuf[i] = getc(infile);
        blk_data_t *datablk = (blk_data_t *)malloc(sizeof(blk_data_t));
        datablk->type = (char)0xf1;   // BASIC program block
        datablk->bn = dec2bcd((*blknum)++);
        datablk->load_address = addr_offset;
        datablk->nb = readlen==256 ? 0 : readlen;
        datablk->data = databuf;
        datablk->crc = calc_datablk_crc(datablk);
        datablk->blksize = 6 + readlen; 
        addr_offset += datablk->nb==0 ? 256 : ((int)datablk->nb & 0xff);
        add_ptp_block((char *)datablk);
        blk_size_sum += datablk->blksize + 3;
    }
    return blk_size_sum;
}

blk_close_t *add_close_blk(int blknum) {
    blk_close_t *closeblk = (blk_close_t *)malloc(sizeof(blk_close_t));
    closeblk->type = (char)0xb1;   // BASIC closing block
    closeblk->bn = dec2bcd(blknum);
    closeblk->crc = closeblk->bn;
    closeblk->blksize = 3;
    add_ptp_block((char *)closeblk);
    return closeblk;
}


void writePtpFile(FILE *fpin, FILE *fpout, int len) {
    // ptp file header
    ptphdr_t *ptphdr = add_ptp_header();
    uint16_t ptpfilesize = 3;   // the ptp header is 3 bytes long

    // ptp name block
    blk_name_t *nameblk = add_name_blk(ptpname);
    ptpfilesize += nameblk->blksize + 3; // 0x55 <blksize> <blk>

    // set free addr in primo so variables shall be created _after_ the loaded code
    uint16_t free_addr = 0;
    blk_data_t *datablk = add_fixmem_data_blk(&free_addr);
    ptpfilesize += datablk->blksize + 3;

    blk_data_t *basicblk = (blk_data_t *)add_basicboot_data_blk();
    ptpfilesize += basicblk->blksize + 3;

    int blknum = 3;
    ptpfilesize += add_data_blks(fpin, len, &blknum);

    // closing block
    blk_close_t *closeblk = add_close_blk(blknum);
    ptpfilesize += closeblk->blksize + 3;
    
    ptphdr->ptp_size = ptpfilesize;
    free_addr = 0x4400 + len;

    blk_chain_t *ptp_blks = ptp_blks_head;
    while(ptp_blks!=NULL) {
        char type = *ptp_blks->block;
        switch(type) {
            case (char)0xff: {      // ptp file header 
                ptphdr_t *hdr = (ptphdr_t *)ptp_blks->block;
                writebyte(hdr->ptp_start_byte, fpout);
                writeword(hdr->ptp_size, fpout);
                break;
            }
            case (char)0x83: {     // name block
                writebyte(0x55, fpout);    // normal block
                writeword(nameblk->blksize, fpout);
                writebyte(nameblk->type, fpout);
                writebyte(nameblk->bn, fpout);
                writebyte(nameblk->ns, fpout);
                for(int i=0; i<nameblk->ns; i++) {
                    writebyte(nameblk->name[i], fpout);
                }
                writebyte(nameblk->crc, fpout);
                break;
            }
            case (char)0xf1:
            case (char)0xf9: {
                writebyte(0x55, fpout);    // normal block
                datablk = (blk_data_t *)ptp_blks->block;
                writeword(datablk->blksize, fpout);
                writebyte(datablk->type, fpout);
                writebyte(datablk->bn, fpout);
                writeword(datablk->load_address, fpout);
                writebyte(datablk->nb, fpout);
                int l = datablk->nb==0 ? 256 : ((int)datablk->nb & 0xff);
                for(int i=0; i<l; i++) {
                    writebyte(datablk->data[i], fpout);
                }
                writebyte(datablk->crc, fpout);
                break;
            }
            case (char)0xb1: {
                writebyte(0xaa, fpout);
                writeword(closeblk->blksize, fpout);
                writebyte(closeblk->type, fpout);
                writebyte(closeblk->bn, fpout);
                writebyte(closeblk->crc, fpout);
            }
        }
        ptp_blks = ptp_blks->next;
    }
}

/*
 * Execution starts here
 */

int primo_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    int     t = 0; // default: pri, 1:ptp

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if(type!=NULL) {
        if(strcmp(type, "ptp") == 0) {
            t=1;
            if(extfile==NULL)
                extfile = ".ptp";
        } else if (strcmp(type, "pri") == 0) {
            if(extfile==NULL)
                extfile = ".pri";
        } else {
            return -1;
        }
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename, extfile);
    } else {
        strcpy(filename,outfile);
    }

	if ( (fpin=fopen_bin(binname, NULL) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",binname);
    }

    if (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    if(t == 0) {
        writePriFile(fpin, fpout, len);
    } else {
        if(ptpname == NULL) {
            ptpname = (char *)malloc(strlen(filename+1));
            strcpy(ptpname, filename);
        }
        if(strlen(ptpname)>16)
            ptpname[16] = 0;
        writePtpFile(fpin, fpout, len);
        free(ptpname);
    }
    
    fclose(fpin);
    fclose(fpout);

    return 0;
}

