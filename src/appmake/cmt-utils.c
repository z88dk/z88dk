#include "appmake.h"

#define MAX_BLOCK_LEN 0xff
#define HEADER_BYTE   0x3a




static void cmt_write_header(FILE *fpout, int address)
{
    uint8_t low = address % 256;
    uint8_t high = address >> 8;
    int  sum =low + high;

    fputc(HEADER_BYTE, fpout);
    fputc(low, fpout);
    fputc(high, fpout);
    fputc(-sum & 0xff,fpout);
}

static void cmt_write_tail(FILE *fpout)
{
    fputc(HEADER_BYTE, fpout);
    fputc(0, fpout);
    fputc(0, fpout);
}

static void cmt_write_block(FILE *fpout, uint8_t *data, int len)
{
    int i, sum = len;

    fputc(HEADER_BYTE, fpout);
    fputc(len, fpout);
    
    for ( i = 0; i < len; i++ ) {
        fputc(data[i], fpout);
        sum += data[i];
    }
    fputc(-sum & 0xff, fpout);
}

void cmt_write(FILE *fpout, int address, uint8_t *data, int datalen)
{
    int offs;
    
    cmt_write_header(fpout, address);
    for ( offs = 0; offs < datalen; offs += MAX_BLOCK_LEN ) {
        int len = datalen - offs;

        if ( len > MAX_BLOCK_LEN ) len = MAX_BLOCK_LEN;
        cmt_write_block(fpout, data + offs, len);

    }
    cmt_write_tail(fpout);
}