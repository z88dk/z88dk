// Here is the source for String85.  I used Turnbo C++ to compile it.
// Do whatever you want with it, but if you use a major portion of it,
// give me a little credit, please.     -Dan Eble (eble.2@osu.edu)
// -------------------------------------------------------------------

#include <dos.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void fputc_and_sum(char byte, FILE *file);

unsigned checksum = 0; char checksum2 = 0;

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**
void main(int argc, char *argv[])
{
        FILE *infile, *outfile;
        char stringname[9], filename[13], len, makelib = 0;
        int ch;
        unsigned i, num;
        fpos_t infilebottom;

        if (argc != 2 && argc != 3)
        {
                puts("\nSTRING85  Copyright 1995 Dan Eble"
                     "\nUsage: STRING85 inputfile [-L]"
                     "\n       Don't put an extension on input file."
                     "\n       Output file will be .85s\n");
                return;
        }

        if (argc == 3 && (!strcmp(argv[2], "-L") || !strcmp(argv[2], "-l")))
                makelib = 1;

        strncpy(stringname, argv[1], 9);        // copy up to 8 bytes into stringname[]
        strcpy(filename, stringname);
        strcat(filename, ".85s");

        if ((infile = fopen(stringname, "rb")) == NULL)
        {
                puts("\nCannot open input file.\n");
                return;
        }

        if ((outfile = fopen(filename, "wb")) == NULL)
        {
                puts("\nCannot open output file.\n");
                return;
        }

        fseek(infile,0,SEEK_END);
        fgetpos(infile, &infilebottom);
        fseek(infile,0,SEEK_SET);
        infilebottom += 4;      // add 4 bytes for 00,FF,titlelength,checksum2

        fputs("**TI85**", outfile);     // id string
        fputc(26, outfile);             // ascii eof

        fputc(12, outfile);     // doesn't seem to change
        fputc(0, outfile);

        fputs("Machine code stored as a string.        DE", outfile);   // 42-bytes

        num = infilebottom+(unsigned)strlen(stringname)+10;
        fputc((char)num, outfile);      // next two things + 4
        fputc(num>>8, outfile);

        num = (unsigned)strlen(stringname)+4;
        fputc_and_sum((char)num, outfile);      // name length + 4
        fputc_and_sum(num>>8, outfile);

        num = infilebottom+2;
        fputc_and_sum((char)num, outfile);      // string length + 2
        fputc_and_sum(num>>8, outfile);         // (same as below)

        fputc_and_sum(0x0C, outfile);           // data type (string)

        fputc_and_sum(strlen(stringname), outfile);     // name length

        for (i = 0; i < strlen(stringname); i++)        // name
                fputc_and_sum(stringname[i], outfile);

        fputc_and_sum((char)(infilebottom+2), outfile); // string length + 2
        fputc_and_sum((infilebottom+2)>>8, outfile);    // (same as above)

        fputc_and_sum((char)infilebottom, outfile);     // string length
        fputc_and_sum(infilebottom>>8, outfile);

        fputc(0, outfile);      // program signature bytes

        if (makelib)
                fputc(0, outfile);      // library string
        else
                fputc_and_sum(0xfe, outfile);   // ff = zshell 2.0 and 1.0
                                                // fe = zshell 3.0 and later

        for (i = 0; (ch = fgetc(infile)) != EOF && ch != 0; i++)
                ;
        fseek(infile, 0, SEEK_SET);     // go back to file start

        fputc_and_sum((char)i, outfile);        // long name length
        checksum2 = (char)i;

        // copy the data
        for (i = 0; (ch = fgetc(infile)) != EOF; i++)
        {
                fputc_and_sum((char)ch, outfile);
                checksum2 += (char)ch;
        }

        fputc_and_sum(checksum2, outfile);

        fputc((char)checksum, outfile);
        fputc(checksum>>8, outfile);
        fclose(infile);
        fclose(outfile);
}

void fputc_and_sum(char byte, FILE *file)
{
        fputc(byte, file);
        checksum += byte;
}

