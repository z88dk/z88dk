/*
	$Id: csp2sgz.c,v 1.1 2015-02-18 20:56:16 stefano Exp $
	
	Support tool for the sprite editor by Daniel McKinnon
	Convert the old ".csp" files to the new ".sgz" format

*/

#include <allegro.h>
#include <winalleg.h>
//#include <allegro/allegro.h>

#include <stdio.h>
#include <string.h>
#include <zlib.h>


#define MAX_SIZE_X		255
#define MAX_SIZE_Y		255

#define MAX_SPRITE		150



typedef struct spritetype
{
	int size_x, size_y;
	int p[ MAX_SIZE_X ][ MAX_SIZE_Y ];
} spritetype;

int on_sprite;
int copied;			//Sprite selected as source for copying
int num_sprites;
spritetype sprite[ MAX_SPRITE + 1 ];




void load_sprite_file( char *file )
{
	PACKFILE *f;

	if ( exists( file ) )
	{
		f = pack_fopen( file, "pr+b" );
		pack_fread( &sprite, sizeof( sprite ), f );
		pack_fclose( f );
	}

}




void save_sprite_file( const char *file )
{
	gzFile *f;
	int x,y,i;

	//f = al_fopen( file, "wb" );
	f = gzopen( file, "wb" );
	if (!f) {
		//al_fclose( f );
		return;
	}

	for ( i = 0; i <= MAX_SPRITE; i++ )
	{
		gzputc (f, sprite[ i ].size_x);
		gzputc (f, sprite[ i ].size_y);
		for ( x = 0; x < MAX_SIZE_X; x++ )
			for ( y = 0; y < MAX_SIZE_Y; y++ ) {
				gzputc (f, sprite[ i ].p[ x ][ y ]);
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

	if (argc != 2 ) {
		printf("Usage: %s [code file]\n",argv[0]);
		exit(1);
	}
	
    strcpy(fileout,argv[1]);
    strcat(fileout,".sgz");

	allegro_init();
	load_sprite_file( argv[1] );
 	save_sprite_file( fileout );
	
	printf("'%s' created, conversion done.\n",fileout);

	return 0;
	
} END_OF_MAIN();


