/*
	$Id: csp2sgz.c,v 1.3 2015-03-06 18:23:51 stefano Exp $
	
	Support tool for the sprite editor by Daniel McKinnon
	Convert the old ".csp" files to the new ".sgz" format

*/

#include <allegro.h>
#include <winalleg.h>
//#include <allegro/allegro.h>

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <zlib.h>


typedef struct spritetype
{
	int size_x, size_y;
	int p[ 255 ][ 255 ];
} spritetype;

typedef struct spritetype_old
{
	int size_x, size_y;
	int p[ 97 ][ 65 ];
} spritetype_old;



int on_sprite;
int copied;			//Sprite selected as source for copying
int num_sprites;
spritetype sprite_new[ 150 + 1 ];
spritetype_old sprite_old[ 25 + 1 ];




void load_sprite_file_new( char *file )
{
	PACKFILE *f;

	if ( exists( file ) )
	{
		f = pack_fopen( file, "pr+b" );
		pack_fread( &sprite_new, sizeof( sprite_new ), f );
		pack_fclose( f );
	}

}

void load_sprite_file_old( char *file )
{
	PACKFILE *f;

	if ( exists( file ) )
	{
		f = pack_fopen( file, "pr+b" );
		pack_fread( &sprite_old, sizeof( sprite_old ), f );
		pack_fclose( f );
	}

}



void save_sprite_file_old( const char *file )
{
	gzFile *f;
	int x,y,i;

	//f = al_fopen( file, "wb" );
	f = gzopen( file, "wb" );
	if (!f) {
		//al_fclose( f );
		return;
	}

	for ( i = 0; i <= 150; i++ )
	{
		if (i <= 25) {
			gzputc (f, sprite_old[ i ].size_x);
			gzputc (f, sprite_old[ i ].size_y);
		} else {
			gzputc (f, 16);
			gzputc (f, 16);
		}
		for ( x = 0; x < 255; x++ )
			for ( y = 0; y < 255; y++ ) {
				if ((x < 97)&&(y < 65)&&(i <= 25)) {
					gzputc (f, sprite_old[ i ].p[ x ][ y ]);
				} else {
					gzputc (f, 0);
				}
			}
	}
	gzclose( f );
}

void save_sprite_file_new( const char *file )
{
	gzFile *f;
	int x,y,i;

	//f = al_fopen( file, "wb" );
	f = gzopen( file, "wb" );
	if (!f) {
		//al_fclose( f );
		return;
	}

	for ( i = 0; i <= 150; i++ )
	{
		gzputc (f, sprite_new[ i ].size_x);
		gzputc (f, sprite_new[ i ].size_y);
		for ( x = 0; x < 255; x++ )
			for ( y = 0; y < 255; y++ ) {
				gzputc (f, sprite_new[ i ].p[ x ][ y ]);
			}
	}
	gzclose( f );
}


//**************************************************************************
//                                     MAIN                                *
//**************************************************************************
int main( int argc, char *argv[] )
{
	char fileout[ 255 ];
	FILE *fpin;
	long len;

	if (argc != 2 ) {
		printf("Usage: %s [code file]\n",argv[0]);
		exit(1);
	}
	
    strcpy(fileout,argv[1]);
    strcat(fileout,".sgz");


	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't open input file\n");
		exit(1);
	}
	
	if  (getc(fpin)!='s') {
		printf("This isn't a sprite file\n");
		exit(1);
	}

	if  (getc(fpin)!='l') {
		printf("This isn't a sprite file\n");
		exit(1);
	}

	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);
	
	fclose(fpin);

	allegro_init();
	if (len < 100000) {
		printf("Pre-2007 file version detected.  ");
		load_sprite_file_old( argv[1] );
		save_sprite_file_old( fileout );
	} else {
		load_sprite_file_new( argv[1] );
		save_sprite_file_new( fileout );
	}
	
	printf("'%s' created, conversion done.\n",fileout);

	return 0;
	
} END_OF_MAIN();


