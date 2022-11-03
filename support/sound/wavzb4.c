/*
 *  Audio format conversion for 4bit analog players
 *  Converting a WAV to 4bit, unsigned, little endian audio stream
 *
 *  Usage: wav4bz [wavfile] [.h file]
 *
 *
 *  Stefano, Nov 2022
 *
 *  $Id: wavzb4.c $
 */

#include <stdio.h>
#include <stdlib.h>



int main(int argc, char *argv[])
{
    char    name[11];
    FILE    *fpin, *fpout;
    int     bits,stereo;
    long    rate;
    long    i,len,len0;
    int     h,l,count;
    long    pos;

    if (argc != 3 ) {
        fprintf(stdout,"Usage: %s [wav file] [output hex file]\n",argv[0]);
        exit(1);
    }


    if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
        printf("Can't open input file\n");
        exit(1);
    }




    if ((getc(fpin)!='R') || (getc(fpin)!='I') || (getc(fpin)!='F') || (getc(fpin)!='F')) {
        printf("Not a WAV file\n");
        fclose(fpin);
        exit(1);
    }
    
    //Overall file size
    getc(fpin);
    getc(fpin);
    getc(fpin);
    getc(fpin);

    if ((getc(fpin)!='W') || (getc(fpin)!='A') || (getc(fpin)!='V') || (getc(fpin)!='E')) {
        printf("Not a WAV format\n");
        fclose(fpin);
        exit(1);
    }
    //'fmt '
    if ((getc(fpin)!='f') || (getc(fpin)!='m') || (getc(fpin)!='t') || (getc(fpin)!=' ')) {
        printf("Not a WAV format\n");
        fclose(fpin);
        exit(1);
    }


    //Length of format data (should be 16)
    getc(fpin);
    getc(fpin);
    getc(fpin);
    getc(fpin);

    //Type of format (1 is PCM)
    if (getc(fpin)!=1) {
        printf("Unsupported PCM format\n");
        fclose(fpin);
        exit(1);
    }
    getc(fpin);
    
    //1 or 2 channels ?
    if (stereo=getc(fpin)-1) {
        printf("STEREO to mono conversion\n");
    }
    getc(fpin);


    // Sample Rate
    rate=getc(fpin)+256*getc(fpin)+65536*getc(fpin);
    getc(fpin);
    
    printf ("Sample rate: %d\n",rate);

    //(Sample Rate * BitsPerSample * Channels) / 8
    getc(fpin);
    getc(fpin);
    getc(fpin);
    getc(fpin);
    
    //(BitsPerSample * Channels) / 8
    len0=getc(fpin)+256*getc(fpin);
    
    bits=getc(fpin)+256*getc(fpin);
    printf ("%d bit samples\n",bits);
    if (bits > 16) {
        printf("Unsupported bit resolution\n");
        fclose(fpin);
        exit(1);
    }

    if ((getc(fpin)!='d') || (getc(fpin)!='a') || (getc(fpin)!='t') || (getc(fpin)!='a')) {
        printf("Unknown WAV file format\n");
        fclose(fpin);
        exit(1);
    }

    // Data block length
    len=getc(fpin)+256*getc(fpin)+65536*getc(fpin);
    getc(fpin);


    // Good to create an output file now
    if ( (fpout=fopen(argv[2],"wb") ) == NULL ) {
        printf("Can't open output file\n");
        exit(1);
    }

    fprintf(fpout,"extern char sound[]={\n");

    count=0;
    for (i=0; i<((bits/2)*(len/(bits+bits*stereo)));i++) {

        if (count == 128) {
            count=0;
            fprintf (fpout,"\n");
        }

        // Deal with sign bit
        if (bits==16) h=((getc(fpin)+256*getc(fpin))^0x8000)>>8;
        else h=getc(fpin);

        //h &= 0xe0;  // Try this to remove noise
        h &= 0xf0;
        
        if (stereo) {
            getc(fpin);
            if (bits==16) getc(fpin);
        }

        // Deal with sign bit
        if (bits==16) l=((getc(fpin)+256*getc(fpin))^0x8000)>>8;
        else l=getc(fpin);

        l>>=4;
        //l &= 0x0e;  // Try this to remove noise
        l &= 0x0f;
        

        if (stereo) {
            getc(fpin);
            if (bits==16) getc(fpin);
        }
        
        //  Skip samples if the bitrate is too high
        if ((rate < 16000) || (((count) % (rate/8000))==1)) {
            fprintf (fpout,"0x%x",l+h);
                fprintf (fpout,", ");
        }

        count++;        
    }

    pos=ftell(fpout);
    fseek(fpout,pos-2,SEEK_SET);
    fprintf (fpout,"};");

    fclose(fpin);
    fclose(fpout);
}
        
