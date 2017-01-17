/*
$Id: sna_mng.c,v 1.1 2001-06-12 14:28:47 stefano Exp $

This utility comes from the "roudoudou" web site.
Translations are from Stefano Bodrato (12/6/2001).
Original README file follows.

--- --- --- --- --- --- --- --- --- ---

Snapshot Manager for msdos by Roudoudou, an
utility to transfer files in a 64 Ko .SNA
snapshots files
http://www.roudoudou.com

Snapshot Manager pour msdos par Roudoudou, un
utilitaire pour transf‚rer des fichiers dans
un fichier snapshot de 64 Ko
*/

#include<stdio.h>
#include<stdlib.h>

FILE *f;
int adress;
char buffer[70000];

void main(int argc, char **argv)
{
printf("Snapshot manager\n\n");

if (argc<6)
   {
   printf("sna_mng <function> <file_in> <file_out> <adress> <lenght>\n\n");

   printf("i : insere  file_in dans file_out a l'adresse adress\n");
   printf("e : extrait file_in dans file_out de l'adresse adress\n\n");
   
   printf("i : insert  file_in into file_out at the desired address\n");
   printf("e : extract file_in from file_out starting at the desired address\n");
   
   exit(0);
   }

adress=atoi(argv[4]);

if (!(argv[1][0]=='i' || argv[1][0]=='I' || argv[1][0]=='e' || argv[1][0]=='E'))
   exit(0);


if (argv[1][0]=='i' || argv[1][0]=='I')
   {
   f=fopen(argv[3],"rb");
   if (!f)
      {
      printf("%s non trouv‚ dukon!\n",argv[3]);
      printf("(%s not found!)\n",argv[3]);
      exit(0);
      }
   fread(buffer,65792,1,f);
   fclose(f);

   f=fopen(argv[2],"rb");
   if (!f)
      {
      printf("%s non trouv‚ dukon!\n",argv[2]);
      printf("(%s not found!)\n",argv[2]);
      exit(0);
      }
   fread(buffer+adress+0x100,atoi(argv[5]),1,f);
   fclose(f);

   f=fopen(argv[3],"wb");
   fwrite(buffer,65792,1,f);
   fclose(f);
   }
else
if (argv[1][0]=='e' || argv[1][0]=='E')
   {
   f=fopen(argv[2],"rb");
   if (!f)
      {
      printf("%s non trouv‚ dukon!\n",argv[2]);
      printf("(%s not found!)\n",argv[2]);
      exit(0);
      }
   fread(buffer,65792,1,f);
   fclose(f);

   f=fopen(argv[3],"wb");
   fwrite(buffer+adress+0x100,atoi(argv[5]),1,f);
   fclose(f);
   }
printf("fini\n");
printf("(The END)\n");
}
