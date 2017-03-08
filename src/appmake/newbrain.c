/*
 *        BIN to NEWBRAIN .BAS file
 *
 *        Stefano Bodrato 4/2007
 *
 *        $Id: newbrain.c,v 1.8 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              ascii        = 0;
static char              help         = 0;

/* Options that are available for this module */
option_t newbrain_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    { 'a', "ascii",     "Generate a BASIC loader in plain text", OPT_BOOL, &outfile },
    {  0 , "blockname", "Name of the binary block in tape",      OPT_STR,  &blockname},
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int newbrain_exec()
{
    char    filename[FILENAME_MAX+1];
    FILE    *fpin, *fpout, *fpout2;
    int    pos;

    int        c;
    int        i,p,l,b;
    int        len;
    int        lnum;

    unsigned long       checksum;

        
    if ( help || binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

    if ( blockname == NULL ) blockname = binname;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".txt");
    } else {
        strcpy(filename,outfile);
    }


    if ( origin != -1 ) {
        pos = origin;
    } else {
		if ( (pos = get_org_addr(crtfile)) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }


	if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }


/*
 *        Now we try to determine the size of the file
 *        to be converted
 */
    if  (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        myexit("Couldn't determine size of file\n",1);
    }

    len=ftell(fpin);


    fseek(fpin,0L,SEEK_SET);


    if ( ascii ) {

            /* All in a BASIC program */

            if ( (fpout=fopen(filename,"w") ) == NULL ) {
                printf("Can't open output text format file %s\n",filename);
                myexit(NULL,1);
            }
                    
            fprintf(fpout,"10 IF TOP>%i THEN RESERVE TOP-%i\n",pos-1,pos-1);
            fprintf(fpout,"20 FOR i=0TO%i:READa:POKE%i+i,a:NEXT i\n",len-1,pos);
            fprintf(fpout,"30 CALL%i\n",pos);
            fprintf(fpout,"40 END\n");
            lnum=100;
            /* ... M/C ...*/
            for (i=0; i<len;i++) {
                if ((i % 60) == 0) {
                    fprintf(fpout,"\n");
                    fprintf(fpout,"%i DATA ",lnum);
                    lnum=lnum+2;
                }
                else
                    fputc(',',fpout);
                c=getc(fpin);
                fprintf(fpout,"%i",c);
            }
            fprintf(fpout,"\n");
            
            fclose(fpin);
            fclose(fpout);

    } 
    else    /*  Much more efficient LOADER  */
    {

            /* binary block */

            suffix_change(filename,".dat");
        
            if ( (fpout2=fopen(filename,"wb") ) == NULL ) {
                printf("Can't open output dat Binary file %s\n",filename);
                myexit(NULL,1);
            }

            checksum=0x3b;                 /* Init checksum */
                fputc (0,fpout2);
            writeword_cksum(strlen(blockname), fpout2, &checksum);
            for (i=0; i<strlen(blockname); i++) {
                fputc (blockname[i],fpout2);
                checksum += blockname[i];
            }
            writebyte_cksum(0x81, fpout2, &checksum);
            writeword((checksum%65536),fpout2);   /* name checksum */
        
            /* Block */
            for (b=0; b<=(len/1024); b++) {
            
              for (i=0; i<10;i++)          /* block leading zeroes */
                fputc (0,fpout2);
              
              checksum=0x3b;               /* Init checksum */
        
              p = (b * 1024) + 1024 -1;    /* set the pointer at the end of the block */
              l = 1024;
        
              if ( p > (len - 1) ) {       /* is last block smaller ? */
                 p = len - 1;
                 l = len - (b * 1024);
              }
              
              /* Block length*/
              writeword_cksum(l, fpout2, &checksum);
              
              for (i=p; i>(p-l); i--) {
                  fseek(fpin, i, SEEK_SET);
                  c = getc(fpin);
                  writebyte_cksum(c, fpout2, &checksum);
              }
              
              writebyte_cksum(b+1, fpout2, &checksum);
              writeword((checksum%65536), fpout2);
            }
        
            for (i=0; i<9;i++)        /* tail */
              fputc (0,fpout2);

            fclose(fpin);
            fclose(fpout2);



            /* TEMP BASIC loader */     
        
            suffix_change(filename,".tmp");

            if ( (fpout=fopen(filename,"wb") ) == NULL ) {
                printf("Can't open temp output file %s\n",filename);
                myexit(NULL,1);
            }

            fputc(0x0d,fpout);
            
            fprintf(fpout,"10 ");
            fputc(0xAC,fpout);        /* RESERVE */
            fputc(0xA8,fpout);        /* TOP */
            fputc(0x82,fpout);        /* - */
            fprintf(fpout,"%i",pos);  /* memory location */
            fputc(0x0d,fpout);

            fprintf(fpout,"20 ");
            fputc('b',fpout);
            fputc(0x8c,fpout);        /* = */
            fprintf(fpout,"121:");  /* 121 */
            fputc(0x89,fpout);        /* IF */
            fputc(0xa4,fpout);        /* PEEK */
            fprintf(fpout,"(51)");
            fputc(0x8d,fpout);        /* > */
            fprintf(fpout,"127");
            fputc(0xb4,fpout);        /* THEN */
            fprintf(fpout,"b");
            fputc(0x8c,fpout);        /* = */
            fputc(0xa4,fpout);        /* PEEK */
            fprintf(fpout,"(168)");
            fputc(0x81,fpout);        /* + */
            fprintf(fpout,"256");
            fputc(0x83,fpout);        /* * */
            fputc(0xa4,fpout);        /* PEEK */
            fprintf(fpout,"(169):");
            fputc(0x9e,fpout);        /* POKE */
            fprintf(fpout,"169,");
            fputc(0x96,fpout);        /* INT */
            fprintf(fpout,"((b");
            fputc(0x81,fpout);        /* + */
            fprintf(fpout,"23)");
            fputc(0x84,fpout);        /* / */
            fprintf(fpout,"256):");
            fputc(0x9e,fpout);        /* POKE */
            fprintf(fpout,"168,b");
            fputc(0x81,fpout);        /* + */
            fprintf(fpout,"23");
            fputc(0x82,fpout);        /* - */
            fprintf(fpout,"256");
            fputc(0x83,fpout);        /* * */
            fputc(0xa4,fpout);        /* PEEK */
            fprintf(fpout,"(169)");
            fputc(0x0d,fpout);

            fprintf(fpout,"30 ");
            fputc(0x8b,fpout);        /* FOR */
            fprintf(fpout," i ");
            fputc(0x8c,fpout);        /* = */
            fprintf(fpout," 0 ");
            fputc(0xb6,fpout);        /* TO */
            fprintf(fpout," 22:");
            fputc(0x9c,fpout);        /* READ */
            fprintf(fpout," c:");
            fputc(0x9e,fpout);        /* POKE */
            fprintf(fpout," b");
            fputc(0x81,fpout);        /* + */
            fprintf(fpout,"i,c:");
            fputc(0x8c,fpout);        /* NEXT */
            fprintf(fpout," i:");
            fputc(0x9d,fpout);        /* DATA */
            fprintf(fpout," 253,110,32,253,102,33,22,0,30,1,1,"); 
            fprintf(fpout,"%i",len%256);  /* LSB for Length */
            fputc(',',fpout);
            fprintf(fpout,"%i",len/256);  /* MSB for Length */
            fprintf(fpout,",231,49,119,35,11,120,177,200,24,246"); 
            fputc(0x0d,fpout);

            fprintf(fpout,"40 ");
            fputc(0x97,fpout);        /* OPEN */
            /* fputc(' ',fpout); */
            fputc(0xb3,fpout);        /* # */
            fprintf(fpout,"1,");
            fputc('"',fpout);
            fprintf(fpout,"%s",blockname);
            fputc('"',fpout);
            fputc(0x0d,fpout);
            
            fprintf(fpout,"50 ");
            fputc(0x9f,fpout);        /* CALL */
            fprintf(fpout," b : ");
            fputc(0x9f,fpout);        /* CALL */
            fprintf(fpout," %i",pos);
            fputc(0x0d,fpout);
            
            fputc(0x04,fpout);
            fputc(0x0d,fpout);
            fclose(fpout);            


            
            /* Now convert in tape format */

            if ( (fpin=fopen(filename,"rb") ) == NULL ) {
                fprintf(stderr,"Can't read temp file%s\n",binname);
                myexit(NULL,1);
            }

            if  (fseek(fpin,0,SEEK_END)) {
                fclose(fpin);
                myexit("Couldn't determine size of temp file\n",1);
            }
        
            len=ftell(fpin);

            suffix_change(filename,".bas");
        
            if ( (fpout2=fopen(filename,"wb") ) == NULL ) {
                printf("Can't open output BASIC Binary file %s\n",filename);
                myexit(NULL,1);
            }
                
            /* header for binary block */
        
            checksum=0x3b;              /* Init checksum */

            fputc (0,fpout2);
            writeword_cksum(strlen(filename), fpout2, &checksum);
            for (i=0; i<strlen(filename); i++) {
                fputc (filename[i],fpout2);             /* +1 ?? */
                checksum += filename[i];
            }
            writebyte_cksum(0x81, fpout2, &checksum);
            writeword((checksum%65536),fpout2); /* name checksum */
        
            for (i=0; i<10;i++)         /* zero filling the next part */
                fputc (0,fpout2);

            checksum=0x3b;              /* Init checksum */

            /* Block length*/
            writeword_cksum(len, fpout2, &checksum);
        
            /* Block */
            for (i=len-1; i>=0; i--) {
                  fseek(fpin, i, SEEK_SET);
                  c=getc(fpin);
                  writebyte_cksum(c, fpout2, &checksum);
            }
        
            writebyte_cksum(0x41, fpout2, &checksum);
            
            writeword((checksum%65536),fpout2);  /* block checksum */
            for (i=0; i<9;i++)                   /* tail  */
                fputc (0,fpout2);

            fclose(fpin);
            fclose(fpout2);


            /* TAPE directory */
            
            if ( (fpout=fopen("_dir.txt","w") ) == NULL ) {
                printf("Can't open output text format file %s\n",filename);
                myexit(NULL,1);
            }
            fprintf(fpout,"%s\n",filename);
            suffix_change(filename,".dat");
            fprintf(fpout,"%s\n",filename);
            fclose(fpout);
            
            suffix_change(filename,".tmp");
            remove(filename);

    }    
    return 0;
}
