// SimCoupe .DSK Manipulator
// 1.0.0 MacOS by Andrew Collier
//
// quick and dirty ANSI C port by Thomas Harte!!
// Command line enhancement by Frode Tennebø

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <libgen.h>


void	doOpenCommand(FILE **f, char *fname);
void 	doSaveCommand(FILE **f, char *fname);
void	Menu(void);
void	Usage(void);
void	AskChanges(void);
void	SaveDsk(char *fname);
void	NewDsk(void);
void	OpenDsk(char *dskimage);
void	DirectoryDsk(void);
void	LoadFile(void);
void	SaveFile(char *fname);

unsigned char *	Addr(int track,int sector,int offset);



unsigned char	*image;
FILE	*dsk;
FILE	*file;

int 	validdsk;
int	changes;

/* something of a small patch for the scanf newline type problem */
char no_newlines_getchar(void)
{
	char key;

	do
	{
		key = getchar();
	}
	while(key == '\n');

	return key;
}
/* pathetic little patch ends */

char *getfname(char *title)
{
char *ret;
        
	ret = malloc(256);

	printf("%s",title);
	scanf("%s",ret);

	return ret;
}

void doOpenCommand(FILE **f, char *fname)
{
	*f = NULL;
	if (!fname)
	{
	     fname = getfname("Open file name:");
	}

	if(fname)
	{

		*f = fopen(fname, "r");
	};
}



void doSaveCommand(FILE **f, char *fname)
{
	*f = NULL;
	if (!fname)
	{
	     fname = getfname("Save file as:");
	}

	*f = fopen(fname, "w");

}




int main(int argc, char **argv)
{
char	command;


	if ((image = malloc(819200)) == (unsigned char *) NULL)
	{
		printf("Sorry, not enough free memory to load .DSK file\n");
		getchar();
	}
	else
	{

	        /* We have commands - add the file(s) to the diskimage */
	        if (argc >= 2 )
		{
		        if (argv[1][0] == '-')
			{
			        if (argv[1][1] == 'h')
				{
				     Usage();
				     exit(0);
				}
			}
			if (argc < 3)
			{
			     Usage();
			     exit(1);
			}

			
			OpenDsk(argv[1]);
			SaveFile(argv[2]);
			SaveDsk(argv[1]);

			exit(0);
		}


		command = 'X';
		validdsk = 0;
		changes = 0;

		Menu();


		while (command != 'Q')
		{

			printf ("? ");
			command = toupper(getchar());
			printf ("%c\n",command);

			switch (command)
			{
			case '?':
			case 'H':
				Menu();
			break;

			case 'N':
				AskChanges();
				NewDsk();
			break;

			case 'O':
				AskChanges();
				OpenDsk(NULL);
			break;

			case 'D':
				DirectoryDsk();
			break;

			case 'L':
				LoadFile();
			break;

			case 'S':
				SaveFile(NULL);
			break;

			case 'W':
				SaveDsk(NULL);
			break;

			case 'Q':
				AskChanges();
			break;
			}
		};
	};

	return 0;
}



void Menu(void)
{
	printf ("** Andrew Collier's SimCoupe .DSK manipulator **\n");
	printf ("** Command line enhancements by Frode Tennebø **\n\n");
	printf ("N: New .DSK file\n");
	printf ("O: Open .DSK file\n");
	printf ("W: Write changes\n");
	printf ("D: Directory .DSK file\n");
	printf ("S: Save file into .DSK\n");
	printf ("L: Load file from .DSK\n");
	printf ("Q: Quit program\n");
}

void Usage(void)
{
	printf ("** Andrew Collier's SimCoupe .DSK manipulator **\n");
	printf ("** Command line enhancements by Frode Tennebø **\n\n");
	printf ("Usage: dskman [[-h][DSK-file]] [file]\n\n");
	printf ("  -h  This help\n\n");
	printf ("Example: dskman test.dsk file\n");
	printf ("         dskman (by itself) will get you into the original menu mode\n");
}

void AskChanges(void)
{
char command;

	if (changes)
	{
		printf ("Unsaved changes to DSK\nSave before continuing? Y/N\n");
		command = 'X';

		while ((command != 'Y') && (command != 'N'))
		{
			command = toupper(getchar());
		}

		if (command == 'Y')
		{
			SaveDsk(NULL);

		}

	}
}


void SaveDsk(char *fname)
{
	doSaveCommand(&dsk, fname);
	if (dsk != NULL)
	{
		if (fwrite (image, (size_t) 1, (size_t) 819200, dsk) == 819200)
		{
			changes = 0;
			printf ("OK\n");
		}
		else
		{
			printf ("Sorry, there has been a disk write error\n");
		};

		fclose(dsk);
	}




}




void NewDsk(void)
{
int i;

	for (i = 0; i<819200; i++)
	{
		*(image+i) = (unsigned char)0;
	}

	validdsk = 1;
	changes = 1;
}



void OpenDsk(char *dskimage)
{
	doOpenCommand(&dsk, dskimage);

	if (dsk != NULL)
	{

		fseek (dsk, 0, 2);
		if (ftell (dsk) == 819200)
		{
			fseek (dsk, 0 , 0);


			if (fread (image, (size_t) 1, (size_t) 819200, dsk) == 819200)
			{
				validdsk = 1;
				printf (".DSK loaded\n");
				changes = 0;
			}
			else
			{
				validdsk = 0;
				printf ("Sorry, there has been a disk read error\n");
			};
		}
		else
		{
			printf ("Sorry, this is not a valid .DSK file\n");
			validdsk = 0;
		};
		fclose (dsk);
	}
	else
	{
	     printf ("Sorry, no such .DSK file\n");
	     if (dskimage)
	     {
		     exit(1);
	     }
	}
}


void	DirectoryDsk(void)
{
	if (validdsk != 0)
	{
	int maxdtrack,nfiles,nfsect,flen,i,stat,track,sect,half;
	char filename[11];

		if ( *(image+255) == 255)
		{
			printf ("*** SAMDOS directory:\n");
			maxdtrack = 4;

		}
		else
		{
			maxdtrack = 4 + *(image+255);

			for (i=0; i<10; i++)
			{
				filename[i] = *(image+210+i);

			};
			filename[10]=0;

			printf ("*** MasterDos directory: %s\n",filename);
		}


		nfiles = 0;
		nfsect = 10 * (160 - maxdtrack) + (maxdtrack > 4);

		for (track = 0; track < maxdtrack; track++)
		{
			for (sect = 1; sect <= 10; sect ++)
			{
				for (half = 0; half < 2; half ++)
				{
					if ((track != 4) || (sect != 1))
					{
						if ((stat = *Addr(track,sect,256*half)) != 0)
						{

							for (i=0; i<10; i++)
							{
								filename[i] = *Addr(track,sect,256*half+1+i);
								if ((filename[i]<32) || (filename[i]>126)) filename[i]='?';

							};
							filename[10]=0;

							printf("%s ",filename);

							if (stat & 128) printf ("H"); else printf(".");
							if (stat & 64) printf ("P"); else printf(".");


							flen = *Addr(track,sect,256*half +240);
							flen += 256* *Addr(track, sect, 256*half +241);
							flen += 16384* *Addr(track,sect,256*half +239);

							printf("%6.0f ",(float)flen);

							nfsect -= *Addr(track,sect,256*half +12);
							nfsect -= 256* *Addr(track,sect,256*half +11);

							//if ((++nfiles %4) == 0) printf("\n");
						}
						else if ((*Addr(track,sect,256*half +1)) == 0)
						{
							half = 1;
							sect = 10;
							track = maxdtrack;
						};
					};
				};
			};
		};

		printf("\n%d files, %d K free\n",nfiles,nfsect/2);


	}
	else
	{
		printf ("No loaded .DSK file\n");
	};
}



void LoadFile(void)
{
char	filename[11];
int i,t,s,h,length,maxdtrack,ss,tt;
unsigned char *found;

	if (validdsk != 0)
	{

		printf ("Filename: ");

		i=0;
		filename[i] = no_newlines_getchar();
		while ((i<10) && (filename[i] != '\n'))
		{
			filename[++i] = getchar();
		}
		while (filename[i] != '\n')
		{
			filename[i] = getchar();
		}
		while (i<10)
		{
			filename[i++]=' ';
		}
		filename[10]=0;

		found = NULL;

		if ( *(image+255) == 255)
		{
			maxdtrack = 4;
		}
		else
		{
			maxdtrack = 4 + *(image+255);
		}

		for (t=0; t<maxdtrack; t++)
		{
			for (s=1; s<11; s++)
			{
				for (h=0; h<2; h++)
				{
					for (i=0; i<10; i++)
					{
						if (toupper (*Addr(t,s,256*h+1+i)) != toupper(filename[i]))
						{
							i = 10;
						}
						else if (i==9)
						{
							found = Addr(t,s,256*h);
							i=10;
							h=2;
							s=10;
							t=maxdtrack;
						};
					};
				};
			};
		};


		if (found == NULL)
		{
			printf ("\nFile %s not found\n",filename);
		}
		else
		{
			doSaveCommand(&file, NULL);
			if (file != NULL)
			{

				length = *(found +240);
				length += 256* *(found +241);
				length += 16384* *(found +239);

				i = length;

				t = *(found + 13);
				s = *(found + 14);

				if (i>=501)
				{
					fwrite(Addr(t,s,9),1,501,file);
					i -= 501;
				}
				else
				{
					fwrite(Addr(t,s,9),1,i,file);
					i=0;
				};

				while (i>0)
				{
					tt = *Addr(t,s,510);
					ss = *Addr(t,s,511);

					t = tt;
					s = ss;

//					printf("t %d  s %d\t",t,s);

					if (i>=510)
					{
						fwrite(Addr(t,s,0),1,510,file);
						i -= 510;
					}
					else
					{
						fwrite(Addr(t,s,0),1,i,file);
						i=0;
					};

				};

				fclose(file);

				printf("Filename %s Length %d ",filename,length);


				length = *(found +237);
				length += 256* *(found +238);
				length += 16384* ((*(found +236) & 31) -1);

				printf ("Start %d ", length);





				length = *(found +243);
				length += 256* *(found +244);
				length += 16384* (1 + *(found +242) & 31);


				if (length != 589823) printf ("Execute %d ", length);

				printf ("\n");
			};
		};
	};
}



void SaveFile(char *fname)
{
char	filename[11], *basen;
unsigned char	sectmap[195],usedmap[195],*found;
int filelength,maxdtrack,s,t,h,i,m,a,tt,ss;


	if (validdsk != 0)
	{
		doOpenCommand(&file, fname);
		if (file == NULL)
		{
			printf("Sorry, file not found\n");
			exit(1);
		}

		fseek (file, 0, 2);
		filelength = ftell(file);
		fseek (file,0,0);

		if ( *(image+255) == 255)
		{
			maxdtrack = 4;
		}
		else
		{
			maxdtrack = 4 + *(image+255);
		};

		for (i=0; i<195; i++)
		{
			sectmap[i] = usedmap[i] = 0;
		}

		for (t=0; t<maxdtrack; t++)
		{
			for (s=1; s<11; s++)
			{
				for (h=0; h<2; h++)
				{
					for (i=0; i<195; i++)
					{
						sectmap[i] |= *Addr(t,s,256*h+15+i);
					}
				}
			}
		}

		if (maxdtrack>4)
		{
			sectmap[0] &= 254;
			sectmap[1] &= 3;

			if (maxdtrack>5)
			{
				a=1;
				m=4;

				for (i=0; i<10*(maxdtrack - 4); i++)
				{
					sectmap[a] &= m;

					m *=2;
					if (m==256)
					{
						a ++;
						m = 1;

					}

				}
			}
		}



		for (t=0; t<maxdtrack; t++)
		{
			for (s=1; s<11; s++)
			{
				for (h=0; h<2; h++)
				{

					if (*Addr(t,s,256*h) == 0)
					{
						found = Addr(t,s,256*h);
						h=2;
						s=10;
						t=maxdtrack;


					}

				}
			}
		}

		i=0;
		for (a=0;a<195;a++)
		{
			for(m=1;m<256;m *=2)
			{
				i += !(sectmap[a] && m);

			}
		}

		if (filelength > (510*i - 9))
		{
			printf("Sorry, not enough space on dsk\n");
		}
		else
		{

			t=4;
			s=1;
			m=1;
			a=0;

			while ((sectmap[a] & m))
			{
				m *= 2;
				if (m==256)
				{
					m =1;
					a ++;
				}

				s++;
				if (s==11)
				{
					s=1;
					t++;

					if (t==80)
						t=128;
				}

			}


			memset(filename, 32, 10);
			filename[10]=0;
			if (!fname) 
			{
			        printf ("Save Filename:");

				i=0;
				filename[i] = no_newlines_getchar();
				while ((i<10) && (filename[i] != '\n'))
				{
				     filename[++i] = getchar();
				}
				while (filename[i] != '\n')
				{
				     filename[i] = getchar();
				}
				while (i<10)
				{
				     filename[i++]=' ';
				}
			}
			else
			{
			     basen = basename(fname);
			     strncpy(filename, basen, strlen(basen));
			     printf ("Save Filename:%s\n", filename);
			}


			*(found) = 19;
			*Addr(t,s,0) = 19;
			for (i=0; i<10; i++)
			{
				*(found+1+i) = filename[i];
			}

			i = (filelength+9)/510;
			*(found+11) = i/256;
			*(found+12) = i%256;
			*(found+13) = t;
			*(found+14) = s;
			*(found+220) = 0;

			*(found+236) = 1;
			*Addr(t,s,8) = 1;
			*(found+237) = 0;
			*Addr(t,s,3) = 0;
			*(found+238) = 128;
			*Addr(t,s,4) = 128;

			*(found+239) = filelength/16384;
			*Addr(t,s,7) = filelength/16384;
			*(found+240) = filelength%256;
			*Addr(t,s,1) = filelength%256;
			*(found+241) = (filelength%16384)/256;
			*Addr(t,s,2) = (filelength%16384)/256;

			*(found+242) = 255;
			*(found+243) = 255;
			*(found+244) = 255;

			if (filelength < 502)
			{
				fread(Addr(t,s,9),1,filelength,file);
				*Addr(t,s,510) = 0;
				*Addr(t,s,511) = 0;

				usedmap[a] |= m;
				sectmap[a] |= m;
			}
			else
			{

				fread(Addr(t,s,9),1,501,file);
				filelength -= 501;
				usedmap[a] |= m;
				sectmap[a] |= m;

				while (filelength > 0)
				{
					printf ("t %d s %d, ",t,s);

					tt = t;
					ss = s;

					while ((sectmap[a] & m))
					{
						m *= 2;
						if (m==256)
						{
							m =1;
							a ++;
						}

						s++;
						if (s==11)
						{
							s=1;
							t++;

							if (t==80)
								t=128;
						}

					}

					*Addr(tt,ss,510) = t;
					*Addr(tt,ss,511) = s;

					if (filelength > 510)
					{
						fread(Addr(t,s,0),1,510,file);
						filelength -= 510;
						usedmap[a] |= m;
						sectmap[a] |= m;
					}
					else
					{
						fread(Addr(t,s,0),1,filelength,file);
						filelength = 0;
						usedmap[a] |= m;
						sectmap[a] |= m;

						*Addr(t,s,510) = 0;
						*Addr(t,s,511) = 0;
					}

				}
			}
			for (i=0;i<195;i++)
			{
				*(found+15+i) = usedmap[i];

			}

			changes = 1;
			printf ("OK\n");

		}
	}
}




unsigned char	*Addr(int track,int sector,int offset)
{
unsigned char *a;

	if (track < 80)
	{
		a = image + 10240*track + 512*(sector-1) + offset;
	}
	else
	{
		a = image + 5120 + 10240*(track - 128) + 512*(sector-1) + offset;
	}

	return a;
}
