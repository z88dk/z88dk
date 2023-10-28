/** It should be notes that is is for compling FLASH APPS not ram programs.
 *  For ram programs see tixx.c
 *
 *  This file originally made by HeronErin. (github.com/HeronErin)
 *
 *
 *
 * *Heavily* Based on https://github.com/alberthdev/spasm-ng/blob/master/export.cpp
 * All credit to spasm for most of this
 *
 *
 */


#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#if defined(__APPLE__)
#  define COMMON_DIGEST_FOR_OPENSSL
#  include <CommonCrypto/CommonDigest.h>
#  define SHA1 CC_SHA1
#else
#  include <openssl/md5.h>
#endif

#include "gmp.h"



#include "appmake.h"
#include <stdio.h>

#if !defined(__MSDOS__) && !defined(__TURBOC__)
#ifndef _WIN32
#define stricmp strcasecmp
#endif
#endif



static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *appname      = NULL;
static char             *other_pages  = NULL;
static char              help         =0;
static char              single_page  =0;
static char              combine_pages   =0;


/* Options that are available for this module */
option_t ti8xk_options[] = {
{ 'h', "help",     "Display this help",                 OPT_BOOL,  &help},
{ 's', "single-page",     "Compile as single paged",    OPT_BOOL,  &single_page},
{ 'j', "combine-pages",     "Signal that you are combining pages", OPT_BOOL,  &combine_pages},
{ 'p', "other-pages", "A comma separated list of the pages without any spaces (ex main.o,page_1.o)", OPT_STR, &other_pages},
{ 'b', "binfile",  "Linked binary file",                OPT_STR,   &binname },
{ 'o', "output",   "Name of output file",               OPT_STR,   &outfile },
{ 'n', "name",   "Name of app to be displayed on the calc (8 chars)",        OPT_STR,   &appname },
{  0,  NULL,       NULL,                                OPT_NONE,  NULL }
};


#define name    (header8xk + 17)
#define hleng   sizeof(header8xk)
unsigned char header8xk[] = {
	'*','*','T','I','F','L','*','*',    /* required identifier */
	1, 1,                               /* version */
	1, 0x88,                            /* unsure, but always set like this */
	0x01, 0x01, 0x19, 0x97,             /* Always sets date to jan. 1, 1997 */
	8,                                  /* Length of name. */
	0,0,0,0,0,0,0,0};




/* Constants required for cryptography */
const unsigned char nbuf[]= {
	0xAD,0x24,0x31,0xDA,0x22,0x97,0xE4,0x17,
	0x5E,0xAC,0x61,0xA3,0x15,0x4F,0xA3,0xD8,
	0x47,0x11,0x57,0x94,0xDD,0x33,0x0A,0xB7,
	0xFF,0x36,0xBA,0x59,0xFE,0xDA,0x19,0x5F,
	0xEA,0x7C,0x16,0x74,0x3B,0xD7,0xBC,0xED,
	0x8A,0x0D,0xA8,0x85,0xE5,0xE5,0xC3,0x4D,
	0x5B,0xF2,0x0D,0x0A,0xB3,0xEF,0x91,0x81,
	0xED,0x39,0xBA,0x2C,0x4D,0x89,0x8E,0x87};
const unsigned char pbuf[]= {
	0x5B,0x2E,0x54,0xE9,0xB5,0xC1,0xFE,0x26,
	0xCE,0x93,0x26,0x14,0x78,0xD3,0x87,0x3F,
	0x3F,0xC4,0x1B,0xFF,0xF1,0xF5,0xF9,0x34,
	0xD7,0xA5,0x79,0x3A,0x43,0xC1,0xC2,0x1C};
const unsigned char qbuf[]= {
	0x97,0xF7,0x70,0x7B,0x94,0x07,0x9B,0x73,
	0x85,0x87,0x20,0xBF,0x6D,0x49,0x09,0xAB,
	0x3B,0xED,0xA1,0xBA,0x9B,0x93,0x11,0x2B,
	0x04,0x13,0x40,0xA1,0x6E,0xD5,0x97,0xB6,0x04};

// q ^ (p - 2))
const unsigned char qpowpbuf[] = {
	0xA3,0x82,0x96,0xAF,0x3D,0xDD,0x9B,0x94,
	0xAE,0xA0,0x2F,0x2C,0xE3,0x8B,0xCD,0xD9,
	0xC9,0x11,0x75,0x4F,0x00,0xE4,0xDF,0x47,
	0x38,0xCD,0x98,0x16,0x47,0xF5,0x2B,0x0F};
// (p + 1) / 4
const unsigned char p14buf[] = {
	0x97,0x0B,0x55,0x7A,0x6D,0xB0,0xBF,0x89,
	0xF3,0xA4,0x09,0x05,0xDE,0xF4,0xE1,0xCF,
	0x0F,0xF1,0xC6,0x7F,0x7C,0x7D,0x3E,0xCD,
	0x75,0x69,0x9E,0xCE,0x50,0xB0,0x30,0x07};
// (q + 1) / 4
const unsigned char q14buf[] = {
	0xE6,0x3D,0xDC,0x1E,0xE5,0xC1,0xE6,0x5C,
	0xE1,0x21,0xC8,0x6F,0x5B,0x52,0xC2,0xEA,
	0x4E,0x7B,0xA8,0xEE,0xE6,0x64,0xC4,0x0A,
	0xC1,0x04,0x50,0xA8,0x5B,0xF5,0xA5,0x2D,0x01};


void intelhex_spasm (FILE* outfile, const unsigned char* buffer, int size, unsigned int base_address) {
	const char hexstr[] = "0123456789ABCDEF";
	int page = 0;
	int bpnt = 0;
	unsigned int ci, temp, i, address;
	unsigned char chksum;
	unsigned char outbuf[128];

	//We are in binary mode, we must handle carriage return ourselves.

	while (bpnt < size){
		fprintf(outfile,":02000002%04X%02X\r\n",page,(unsigned char) ( (~(0x04 + page)) +1));
		page++;
		address = base_address;
		for (i = 0; bpnt < size && i < 512; i++) {
			 chksum = (address>>8) + (address & 0xFF);
			 for(ci = 0; ((ci < 64) && (bpnt < size)); ci++) {
				temp = buffer[bpnt++];
				outbuf[ci++] = hexstr[temp>>4];
				outbuf[ci] = hexstr[temp&0x0F];
				chksum += temp;
			}
			outbuf[ci] = 0;
			ci>>=1;
			fprintf(outfile,":%02X%04X00%s%02X\r\n",ci,address,outbuf,(unsigned char)( ~(chksum + ci)+1));
			address +=0x20;
		}
	}
	fprintf(outfile,":00000001FF");
}



int siggen(const unsigned char* hashbuf, unsigned char* sigbuf, int* outf) {
	mpz_t mhash, p, q, r, s, temp, result;

	unsigned int lp,lq;
	int siglength;

/* Intiate vars */
	mpz_init(mhash);
	mpz_init(p);
	mpz_init(q);
	mpz_init(r);
	mpz_init(s);
	mpz_init(temp);
	mpz_init(result);

/* Import vars */
	mpz_import(mhash, 16, -1, 1, -1, 0, hashbuf);
	mpz_import(p, sizeof(pbuf), -1, 1, -1, 0, pbuf);
	mpz_import(q, sizeof(qbuf), -1, 1, -1, 0, qbuf);
/*---------Find F----------*/
/*      M' = m*256+1      */
	mpz_mul_ui(mhash, mhash, 256);
	mpz_add_ui(mhash, mhash, 1);

/* calc f {2, 3,  0, 1 }  */
	lp = mpz_legendre(mhash, p) == 1 ? 0 : 1;
	lq = mpz_legendre(mhash, q) == 1 ? 1 : 0;
	*outf = lp+lq+lq;

/*apply f */
	if (lp == lq)
		mpz_mul_ui(mhash, mhash, 2);
	if (lq == 0) {
		mpz_import(temp, sizeof(nbuf), -1, 1, -1, 0, nbuf);
		mpz_sub(mhash, temp, mhash);
	}

/* r = ( M' ^ ( ( p + 1) / 4 ) ) mod p */
	mpz_import(result, sizeof(p14buf), -1, 1, -1, 0, p14buf);
	mpz_powm(r, mhash, result, p);

/* s = ( M' ^ ( ( q + 1) / 4 ) ) mod q */
	mpz_import(result, sizeof(q14buf), -1, 1, -1, 0, q14buf);
	mpz_powm(s, mhash, result, q);

/* r-s */
	mpz_set_ui(temp, 0);
	mpz_sub(temp, r, s);

/* q ^ (p - 2)) */
	mpz_import(result, sizeof(qpowpbuf), -1, 1, -1, 0, qpowpbuf);

/* (r-s) * q^(p-2) mod p */
	mpz_mul(temp, temp, result);
	mpz_mod(temp, temp, p);

/* ((r-s) * q^(p-2) mod p) * q + s */
	mpz_mul(result, temp, q);
	mpz_add(result, result, s);

/* export sig */
	siglength = mpz_sizeinbase(result, 16);
	siglength = (siglength + 1) / 2;
	mpz_export(sigbuf, NULL, -1, 1, -1, 0, result);

/* Clean Up */
	mpz_clear(p);
	mpz_clear(q);
	mpz_clear(r);
	mpz_clear(s);
	mpz_clear(temp);
	mpz_clear(result);
	return siglength;
}




int fsize(FILE *fp);




// Apps need to be exactly 8 chars in length
void pad_tik_name(char* to, char* from){
    char is_finished = 0;
    for (char i = 0; i < 8; ++i){
        char c = (is_finished ? ' ' : *from);
        if (c==0){
            c = ' ';
            is_finished = 1;
        }
        *to = c;


        to++;
        from++;
    }
}
/* Starting from 0006 searches for a field
 * in the in file buffer. */
int findfield( unsigned char byte, const unsigned char* buffer ) {
	int pnt=6;
	while (buffer[pnt++] == 0x80) {
		if (buffer[pnt] == byte) {
			pnt++;
			return pnt;
		} else
			pnt += (buffer[pnt]&0x0F);
		pnt++;
	}
	return 0;
}

/* This implements findfield but with byte splitting, e.g.
 * prefix for first 4 bits and size for last 4 bits.
 * Uses return by arg to return both location and app field size.
 * Actual return value indicates success or failure. Location and size
 * will be set to 0 if failure.
 */
int findfield_flex( unsigned char prefix_byte, const unsigned char* buffer, int *buf_field_loc, int *buf_field_size ) {
	int pnt=6;
	while (buffer[pnt++] == 0x80) {
		if ((buffer[pnt] & 0xF0) == (prefix_byte & 0xF0)) {
			*buf_field_size = (buffer[pnt] & 0x0F);
			pnt++;
			*buf_field_loc = pnt;
			return 0;
		} else
			pnt += (buffer[pnt] & 0x0F);
		pnt++;
	}
	*buf_field_loc = 0;
	*buf_field_size = 0;
	return 1;
}




int ti8xk_exec(char *target){
    FILE *fp, *fp2;
    int size, tempnum, pnt, field_sz, pages, i, siglength, total_size, f;
    char safe_name[9] = {0};
    unsigned char *buffer;


    if ( help ) {
		// printf("Appmake must receive a -name\n");
        return -1;
    }
	if (binname == NULL && single_page){
		printf("Appmake: Binary file not found\n");
		return -1;
	}
	if (appname == NULL){
		printf("Appmake: App name not found\n");
		return -1;
	}

	if (!(single_page || combine_pages )){
		printf("Appmake must be marked as -single-page or -combine-pages\n");
		return -1;
	}
	if (single_page && combine_pages){
		printf("Appmake must not be marked as -single-page and -combine-pages at the same time\n");
		return -1;
	}


    if (outfile == NULL && single_page){
        int temp_size = strlen(binname);
        outfile = malloc(temp_size+5); // Small memory leak
        strncpy(outfile,binname,temp_size);
        outfile[temp_size] = '.';
        outfile[temp_size+1] = '8';
        outfile[temp_size+2] = 'x';
        outfile[temp_size+3] = 'k';
        outfile[temp_size+4] = 0;
    }else if(outfile == NULL&&combine_pages){
		printf("Multi page apps must have an output file");
		return -1;
	}



	if (single_page){
		fp = fopen_bin(binname, NULL);
		if (!fp)
			exit_log(1,"Failed to open input file: %s\n", binname);
		size = i = fsize(fp);
		buffer = (unsigned char *) calloc(1, size+256);
		fread(buffer, size, 1, fp); // To memory

		if (size >= 1<<14){
			free(buffer);
			printf("App marked as single paged, but is too large for just one page");
			return -1;
		}
	}else{
		int bufferSize = 256;
		int pageStart = 0;
		int fileNameIndex;
		char fileName[256]={0};

		buffer = malloc(bufferSize);

		while (1){
			bufferSize+=1<<14;
			buffer=realloc(buffer, bufferSize);

			fileNameIndex=0;
			while(1){
				if (isspace(*other_pages) || *other_pages == ',' || *other_pages==0){
					if (fileNameIndex < 255)
						fileName[fileNameIndex] =0;
					break;
				}
				if (fileNameIndex < 255)
					fileName[fileNameIndex] = *other_pages;

				fileNameIndex++;
				other_pages++;
			}

			FILE* page_fp = fopen_bin(fileName, NULL);
			size = i = pageStart + fsize(page_fp);
			fread(buffer+pageStart, fsize(page_fp), 1, page_fp);

			fclose(page_fp);
			if (isspace(*other_pages) || *other_pages==0)
				break;
			other_pages++;
			pageStart+=1<<14;
		}
	}







	if (single_page && size >= 1<<14){
		free(buffer);
		printf("App marked as single paged, but is too large for just one page");
		return -1;
	}
	if (combine_pages && size <= 1<<14){
		free(buffer);
		printf("App marked as multi paged, but smaller than one page");
		return -1;
	}



    if ((tempnum = ((size+96)%16384))) {
		if (tempnum < 97 && size > 16384)
		{
			free(buffer);
			printf("Signing error: Not enough room for signature on last page\n");
            // SetLastSPASMError(SPASM_ERR_SIGNER_ROOM_FOR_SIG);

			return -1;
		}
		if (tempnum<1024 && (size+96)>>14)
		{
            printf("Signing warning: Only %d bytes are used on the last APP page\n", tempnum);
			// SetLastSPASMWarning(SPASM_WARN_SMALL_LAST_PAGE, tempnum);
		}
	}




	if (!(buffer[0] == 0x80 && buffer[1] == 0x0F)) {
		free(buffer);
		// SetLastSPASMError(SPASM_ERR_SIGNER_MISSING_LENGTH);
        printf("App header not detected\n");
		return -1;
	}

    /* Fix app header fields */
    /* Length Field: set to size of app - 6 */


	size -= 6;
	buffer[2] = size >> 24;         //Stored in Big Endian
	buffer[3] = (size>>16) & 0xFF;
	buffer[4] = (size>> 8) & 0xFF;
	buffer[5] = size & 0xFF;
	size += 6;


    /* Program Type Field: Must be present and shareware (0104) */
	pnt = findfield(0x12, buffer);
	if (!pnt || ( buffer[pnt++]!=1) || (buffer[pnt]!=4) ) {
		free(buffer);
		// SetLastSPASMError(SPASM_ERR_SIGNER_PRGM_TYPE);
        printf("Program type field missing or incorrect\n");
		return -1;
	}

    /* Pages Field: Corrects page num*/
	pnt = findfield(0x81, buffer);
	if (!pnt) {
		free(buffer);
		// SetLastSPASMError(SPASM_ERR_SIGNER_MISSING_PAGES);
        printf("Page count field missing\n");
		return -1;
	}

	pages = size>>14; /* this is safe because we know there's enough room for the sig */
	if (size & 0x3FFF) pages++;
	buffer[pnt] = pages;


    /* Name Field: Can be a variable number of characters, no checking if valid */
	if (findfield_flex(0x40, buffer, &pnt, &field_sz)) {
		free(buffer);
		// SetLastSPASMError(SPASM_ERR_SIGNER_MISSING_NAME);
        printf("Name field missing\n");
		return -1;
	}

    pad_tik_name((char*)&safe_name, appname);

	/* Set name length */
	*(name - 1) = 8;
	/* Only copy the part of the name defined in the size returned */
	for (i=0; i < 8; i++) name[i]=buffer[i+pnt]=safe_name[i];


    /* Md5 stuff */
    unsigned char hashbuf[16];
    MD5 (buffer, size, hashbuf);


    /* Generate the signature to the buffer */
	siglength = siggen(hashbuf, buffer+size+3, &f );

    /* append sig */
	buffer[size + 0] = 0x02;
	buffer[size + 1] = 0x2d;
	buffer[size + 2] = (unsigned char) siglength;
	total_size = size + siglength + 3;
	if (f) {
		buffer[total_size++] = 1;
		buffer[total_size++] = f;
	}
    else buffer[total_size++] = 0;
    /* sig must be 96 bytes ( don't ask me why) */
	tempnum = 96 - (total_size - size);
	while (tempnum--) buffer[total_size++] = 0xFF;


    /*  Write to file  */

    fp2 = fopen(outfile, "wb");


    for (i = 0; i < hleng; i++) fputc(header8xk[i], fp2);
	for (i = 0; i < 23; i++)    fputc(0, fp2);
	fputc(0x73, fp2);
	fputc(0x24, fp2);
	for (i = 0; i < 24; i++)    fputc(0, fp2);
	tempnum =  77 * (total_size>>5) + pages * 17 + 11;
	size = total_size & 0x1F;
	if (size) tempnum += (size<<1) + 13;
	fputc( tempnum & 0xFF, fp2); //little endian
	fputc((tempnum >> 8) & 0xFF, fp2);
	fputc((tempnum >> 16)& 0xFF, fp2);
	fputc( tempnum >> 24, fp2);

/* Convert to 8xk */
	intelhex_spasm(fp2, buffer, total_size, 0x4000);


    fclose(fp2);


    printf("Automatically converting to %s as a flash app containing %i pages\n", outfile, pages);


	if (single_page)
    	fclose(fp);





    free(buffer);
	return 0;

}



