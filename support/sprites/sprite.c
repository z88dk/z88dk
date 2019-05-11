/*
	$Id: sprite.c,v 1.16+ (now on GIT) $

	A program to import / make sprites for use with z88dk
	by Daniel McKinnon
	slightly improved and ported to Allegro 5 by Stefano Bodrato
	
	Find the **HACK** markers to change the code at your convenience

	Please send Daniel McKinnon (and the z88dk team) your own updates to the code,
	it can be anything!  Comments, GUI elements, Bug-Fixes,
	Features, ports, etc.

	Original Author's contact:  stikmansoftware _a_t_ yahoo.com

*/


#include <allegro5/allegro.h>
#include <allegro5/drawing.h>
#include <allegro5/allegro_primitives.h>
#include <allegro5/allegro_native_dialog.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_image.h>

#include <zlib.h>

#include <stdio.h>

/* **HACK** (GIF file support)- add "-DGIF_SUPPORT" and -lgif in the Makefile*/
#ifdef GIF_SUPPORT
#include <gif_lib.h>
#include <malloc.h>
const char gifPatterns[] = "*.gif";
#endif

#define MAX_SIZE_X		255
#define MAX_SIZE_Y		255

#define MAX_SPRITE		150

#define DEFAULT_SIZE_X			16
#define DEFAULT_SIZE_Y			16

#ifndef FALSE
#define FALSE 0
#define TRUE 1
#endif


int bls;
ALLEGRO_DISPLAY *display=NULL;
ALLEGRO_BITMAP *screen=NULL;
ALLEGRO_FONT *font=NULL;
ALLEGRO_KEYBOARD_STATE pressed_keys;
ALLEGRO_MOUSE_STATE moustate;
ALLEGRO_EVENT e;
ALLEGRO_EVENT_QUEUE *eventQueue;
ALLEGRO_PATH *path;

ALLEGRO_FILECHOOSER *file_dialog_bmp = NULL;
ALLEGRO_FILECHOOSER *file_dialog_shp = NULL;
ALLEGRO_FILECHOOSER *file_dialog_sv = NULL;
ALLEGRO_FILECHOOSER *file_dialog_svsp = NULL;
ALLEGRO_FILECHOOSER *file_dialog_ldsp = NULL;
ALLEGRO_FILECHOOSER *file_dialog_ldsev = NULL;

const char sprPatterns[] = "*.sgz";
const char sprHeader[] =  "*.*;*.h";
const char bmpPatterns[] = "*.*";
const char shpPatterns[] = "*.shp";
const char geosPatterns[] = "*.cvt";

typedef struct spritetype
{
	int size_x, size_y;
	int p[ MAX_SIZE_X ][ MAX_SIZE_Y ];
} spritetype;

int exit_requested;

int on_sprite;
int copied;			//Sprite selected as source for copying
int num_sprites;
spritetype sprite[ MAX_SPRITE + 1 ];


char hexcode[ MAX_SIZE_X * MAX_SIZE_Y ];		//Generated C Code (called hexcode out of laziness)
char *hexc = "0123456789ABCDEF";					//For converting integers (0-15) to Hex


//Draws a button at (x, y) with width/height (w, h), displaying text *text, with colour
void draw_button( int x, int y, int w, int h, char *text, ALLEGRO_COLOR border_c, ALLEGRO_COLOR fill_c, ALLEGRO_COLOR text_c  )
{
	al_draw_filled_rectangle( x+1, y+1, x+w-1, y+h-1, fill_c );
	al_draw_rectangle( x, y, x+w, y+h, border_c, 1.6 );			//Border
	al_draw_text(font, text_c, x+(w/2), y+(h/2) - 4, ALLEGRO_ALIGN_CENTRE, text);
}

//Checks wheather mouse has been clicked within certain "button" boundries
int button_pressed( int x, int y, int w, int h )
{
	al_get_mouse_state(&moustate);
	
	if (  (moustate.x > x) && (moustate.x < (x+w) )
	   && (moustate.y > y) && (moustate.y < (y+w) )
	   && (moustate.buttons & 1) )
		return 1;
	else
		return 0;
}


//Updates all graphics on screen
void update_screen()
{
	int x, y;

	ALLEGRO_COLOR c1, c2, c3;
	char text[ 100 ];

	al_clear_to_color (al_map_rgb(220,240,220) );
	
	//Draw Big Sprite Block
	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
			if ( sprite[ on_sprite ].p[ x ][ y ] )
				al_draw_filled_rectangle( x * bls, y * bls, (x * bls) + bls, (y * bls) + bls,  al_map_rgb(0, 0, 0) );
	//Draw Border Around Sprite Block
	al_draw_rectangle( bls - 1, bls - 1, (sprite[ on_sprite ].size_x * bls) + bls + 1, (sprite[ on_sprite ].size_y * bls) + bls + 1, al_map_rgb(255,0,0), 1.6  );

	c1 = al_map_rgb(0,0,0);
	c2 = al_map_rgb( 230, 255, 230 );
	c3 = al_map_rgb(0,0,0);
	sprintf( text, "Sprite %i", on_sprite );
	draw_button( 10, 465, 90, 39, text, c1, c2, c3 );

	sprintf( text, "Width %i", sprite[ on_sprite ].size_x );
	draw_button( 210, 465, 90, 39, text, c1, c2, c3 );

	sprintf( text, "Height %i", sprite[ on_sprite ].size_y );
	draw_button( 410, 465, 90, 39, text, c1, c2, c3 );

	c1 = al_map_rgb( 255,255,0 );
	c2 = al_map_rgb( 200, 100, 75 );
	c3 = al_map_rgb( 255,255,255 );
	draw_button( 101, 465, 50, 39, "Last", c1, c2, c3 );
	draw_button( 151, 465, 50, 39, "Next", c1, c2, c3 );

	draw_button( 301, 465, 50, 39, "-1", c1, c2, c3 );
	draw_button( 351, 465, 50, 39, "+1", c1, c2, c3 );

	draw_button( 501, 465, 50, 39, "-1", c1, c2, c3 );
	draw_button( 551, 465, 50, 39, "+1", c1, c2, c3 );

	al_flip_display();

return;

}

//The block that the mouse is over top of
int mx, my;

//Calculate which block the mouse is over top of
void do_mouse_stuff()
{
	al_get_mouse_state(&moustate);
	mx = ( moustate.x / bls );
	my = ( moustate.y / bls );
	if ( mx > sprite[ on_sprite ].size_x )	mx = sprite[ on_sprite ].size_x;
	if ( my > sprite[ on_sprite ].size_y )	my = sprite[ on_sprite ].size_y;
	if ( mx < 1 )			mx = 1;
	if ( my < 1 )			my = 1;

}


void generate_codes( int i, int mode )
{
	int bstring[ MAX_SIZE_X * MAX_SIZE_Y ];	//Binary String
	int hstring[ MAX_SIZE_X * MAX_SIZE_Y ];	//Hex String

	int p, n, t, r;	//Some working variables

	int bin_size;
	int hex_size;

	int x, y;


	//Make the Binary String
	p = 0;
	for ( y = 1; y <= sprite[ i ].size_y; y++ )
		for ( x = 1; x <= (int)( ( (sprite[ i ].size_x - 1) / 8) + 1) * 8; x++ )
		{
			bstring[ p ] = sprite[ i ].p[ x ][ y ];
			p++;
		}
	bin_size = p;

	//Convert binary string to Hex String
	r = 0;
	for ( p = 0; p < bin_size; p += 4 )
	{
		//Turn every 4 into a binary number, Dan Style:
		//Take the first number, if the next number is 0 then multiply it by 2,
		//If it is 1 multiply it by two and then add one!
		//It's a clever way of converting binary numbers (the way I figured it out
		//when I was 10)

		n = bstring[ p ];
		for ( t = p + 1; t < p + 4; t++ )
		{
			if ( bstring[ t ] )
				n = (n * 2) + 1;
			else
				n = (n * 2);
		}


		hstring[ r ] = n;
		r++;
	}
	hex_size = r;

	//Make C Code
	n = 0;
	if (mode)
		sprintf( hexcode, "char sprite%i[] = { %i, %i", i, sprite[ i ].size_x, sprite[ i ].size_y );
	else
		hexcode[0]=0;

	for ( p = 0; p < hex_size; p += 2 )
	{
		sprintf( hexcode, "%s, 0x%c%c ", hexcode, hexc[ hstring[ p ] ], hexc[ hstring[ p + 1] ] );
		n++;
		if ( n > 10 )
		{
			sprintf( hexcode, "%s\n", hexcode );
			n = 0;
		}
	}
	if (mode)
		sprintf( hexcode, "%s };\n", hexcode );
	else
		sprintf( hexcode, "%s \n", hexcode );

}

// Resize the sprite view to best fit on the screen
void fit_sprite_on_screen()
{
	//Calculate size of best fit
	if ( (sprite[ on_sprite ].size_x/2) > sprite[ on_sprite ].size_y )
		bls = (600 / (sprite[ on_sprite ].size_x + 10));
	else
		bls = (440 / (sprite[ on_sprite ].size_y + 10));
}


// Resize the sprite set view to best fit on the screen
void fit_sprite_s_on_screen()
{
	int i;
	int x_sz, y_sz;
	
	x_sz=DEFAULT_SIZE_X, y_sz=DEFAULT_SIZE_Y;
	
	for (i=0; i<MAX_SPRITE; i++) {
		if (x_sz < sprite[ i ].size_x)
			x_sz = sprite[ i ].size_x;
		if (y_sz < sprite[ i ].size_y)
			y_sz = sprite[ i ].size_y;
	}
	
	//Calculate size of best fit
	if ( (x_sz/2) > y_sz )
		bls = (600 / ++x_sz);
	else
		bls = (440 / ++y_sz);
}


void invert_sprite()
{
	int x, y;
	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
			sprite[ on_sprite ].p[ x ][ y ] = !sprite[ on_sprite ].p[ x ][ y ];
	update_screen();
}


void double_sprite_h()
{
	int x, y;
	if ((sprite[ on_sprite ].size_x * 2) > MAX_SIZE_X)
		return;
	sprite[ on_sprite ].size_x = sprite[ on_sprite ].size_x * 2;

	for ( x = sprite[ on_sprite ].size_x; x>0; x-=2 )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ ) {
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x/2 ][ y ];
			sprite[ on_sprite ].p[ x-1 ][ y ] = sprite[ on_sprite ].p[ x/2 ][ y ];
		}
	update_screen();
}


void double_sprite_v()
{
	int x, y;
	if ((sprite[ on_sprite ].size_y * 2) > MAX_SIZE_Y)
		return;
	sprite[ on_sprite ].size_y = sprite[ on_sprite ].size_y * 2;

	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = sprite[ on_sprite ].size_y; y>0 ; y-=2 ) {
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x ][ y/2 ];
			sprite[ on_sprite ].p[ x ][ y-1 ] = sprite[ on_sprite ].p[ x ][ y/2 ];
		}
	update_screen();
}


void reduce_sprite()
{
	int x, y, b;

	for ( x = 1; x <= sprite[ on_sprite ].size_x; x+=2 )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y+=2 ) {
			b=0;
			if (sprite[ on_sprite ].p[ x ][ y ]) b++;
			sprite[ on_sprite ].p[ x ][ y ] = 0;
			if (sprite[ on_sprite ].p[ x+1 ][ y ]) b++;
			sprite[ on_sprite ].p[ x+1 ][ y ] = 0;
			if (sprite[ on_sprite ].p[ x ][ y+1 ]) b++;
			sprite[ on_sprite ].p[ x ][ y+1 ] = 0;
			if (sprite[ on_sprite ].p[ x+1 ][ y+1 ]) b++;
			sprite[ on_sprite ].p[ x+1 ][ y+1 ] = 0;
			sprite[ on_sprite ].p[ x/2+1 ][ y/2+1 ] = (b>1);
		}
	sprite[ on_sprite ].size_x = sprite[ on_sprite ].size_x / 2;
	sprite[ on_sprite ].size_y = sprite[ on_sprite ].size_y / 2;

	fit_sprite_on_screen();
	update_screen();
}


//flip sprite horizontally
void flip_sprite_h()
{
	int x, y, p;
	for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
		for ( x = 1; x <= sprite[ on_sprite ].size_x /2; x++ ) {
			p = sprite[ on_sprite ].p[ x ][ y ];
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ sprite[ on_sprite ].size_x - x + 1 ][ y ];
			sprite[ on_sprite ].p[ sprite[ on_sprite ].size_x - x +1 ][ y ] = p;
		}
	update_screen();
}


//flip sprite vertically
void flip_sprite_v()
{
	int x, y, p;
	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite ].size_y /2; y++ ) {
			p = sprite[ on_sprite ].p[ x ][ y ];
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x ][ sprite[ on_sprite ].size_y - y + 1 ];
			sprite[ on_sprite ].p[ x ][ sprite[ on_sprite ].size_y - y + 1 ] = p;
		}
	update_screen();
}


//flip sprite diagonally
void flip_sprite_d()
{
	int x, y, p;
	int save_x, save_y;
	
	//save sprite dims
	save_x = sprite[ on_sprite ].size_x;
	save_y = sprite[ on_sprite ].size_y;

	if (save_x > save_y)
		sprite[ on_sprite ].size_y = save_x;
	else
		sprite[ on_sprite ].size_x = save_y;
	
	for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
		for ( x = y; x <= sprite[ on_sprite ].size_x; x++ ) {
			p = sprite[ on_sprite ].p[ x ][ y ];
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ y ][ x ];
			sprite[ on_sprite ].p[ y ][ x ] = p;
		}

	sprite[ on_sprite ].size_x = save_y;
	sprite[ on_sprite ].size_y = save_x;
	
	update_screen();
}


void scroll_sprite_left()
{
	int x, y;
	for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ ) {
		for ( x = 1; x < sprite[ on_sprite ].size_x; x++ )
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x + 1 ][ y ];
		sprite[ on_sprite ].p[ x ][ y ] = 0;
	}
	update_screen();
}


void scroll_sprite_right()
{
	int x, y;
	for ( x = sprite[ on_sprite ].size_x; x > 0 ; x-- )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x - 1 ][ y ];
	update_screen();
}


void scroll_sprite_up()
{
	int x, y;
	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ ) {
		for ( y = 1; y < sprite[ on_sprite ].size_y; y++ )
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x ][ y + 1 ];
		sprite[ on_sprite ].p[ x ][ y ] = 0;
	}
	update_screen();
}


void scroll_sprite_down()
{
	int x, y;
	for ( y = sprite[ on_sprite ].size_y; y > 0 ; y-- )
		for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x ][ y - 1 ];
	update_screen();
}


int check_left_border()
{
	int y;
	
	for ( y = sprite[ on_sprite ].size_y; y > 0 ; y-- )
		if (sprite[ on_sprite ].p[ 1 ][ y ] != 0) return 1;
	return 0;
}


int check_top_border()
{
	int x;
	
	for ( x = sprite[ on_sprite ].size_x; x > 0 ; x-- )
		if (sprite[ on_sprite ].p[ x ][ 1 ] != 0) return 1;
	return 0;
}


int check_right_border()
{
	int y;
	
	for ( y = sprite[ on_sprite ].size_y; y > 0 ; y-- )
		if (sprite[ on_sprite ].p[ sprite[ on_sprite ].size_x ][ y ] != 0) return 1;
	return 0;
}


int check_bottom_border()
{
	int x;
	
	for ( x = sprite[ on_sprite ].size_x; x > 0 ; x-- )
		if (sprite[ on_sprite ].p[ x ][ sprite[ on_sprite ].size_y ] != 0) return 1;
	return 0;
}


void fit_sprite_borders()
{
	int x, y;
	for ( y = sprite[ on_sprite ].size_y; y > 0 ; y-- )
		if (!check_top_border()) scroll_sprite_up();
	
	for ( x = sprite[ on_sprite ].size_x; x > 0 ; x-- )
		if (!check_left_border()) scroll_sprite_left();
	
	for ( y = sprite[ on_sprite ].size_y; y > 0 ; y-- )
		if (!check_bottom_border()) sprite[ on_sprite ].size_y--;
	
	for ( x = sprite[ on_sprite ].size_x; x > 0 ; x-- )
		if (!check_right_border()) sprite[ on_sprite ].size_x--;
	
	//sprite[ on_sprite ].size_x++;
	//sprite[ on_sprite ].size_y++;

	update_screen();
}


//chop sprite in smaller items
void chop_sprite( int src )
{
	int x, y, x_offset, y_offset;
	int save_x, save_y;
	
	//save destination sprites' sz
	save_x = sprite[ on_sprite ].size_x;
	save_y = sprite[ on_sprite ].size_y;

	y_offset = 0;
	while ((sprite[ src ].size_y > y_offset) && (on_sprite < MAX_SPRITE)) {
	    x_offset = 0;
	    while ( (sprite[ src ].size_x > x_offset) && (on_sprite < MAX_SPRITE)) {
		sprite[ on_sprite ].size_x = save_x;
		sprite[ on_sprite ].size_y = save_y;
		for ( y = 1; y <= save_y; y++ )
		    for ( x = 1; x <= save_x; x++ )
		        sprite[ on_sprite ].p[ x ][ y ] = sprite[ src ].p[ x + x_offset ][ y + y_offset ];
		on_sprite++;
		x_offset = x_offset + save_x;
	    }
	    y_offset = y_offset + save_y;
	}
	update_screen();
}


void wkey_release(int keycode)
{
	al_flush_event_queue(eventQueue);
	while ( !al_key_down(&pressed_keys, keycode )) {al_get_keyboard_state(&pressed_keys);}
	al_flush_event_queue(eventQueue);
}


#ifdef GIF_SUPPORT
void import_from_gif( const char *FileName )
{
	int x,y;
    int	i, j, Size, Row, Col, Width, Height, ExtCode;
    GifRecordType RecordType;
    GifByteType *Extension;
    GifRowType *ScreenBuffer;
    GifFileType *GifFile;
    GifRowType GifRow;
    GifColorType *ColorMapEntry;

    int
	InterlacedOffset[] = { 0, 4, 2, 1 }, /* The way Interlaced image should. */
	InterlacedJumps[] = { 8, 8, 4, 2 };    /* be read - offsets and jumps... */
    ColorMapObject *ColorMap;
    int Error;

	if ((GifFile = DGifOpenFileName(FileName, &Error)) == NULL)
		return;

    if (GifFile->SHeight == 0 || GifFile->SWidth == 0)
		return;

    /* 
     * Allocate the screen as vector of column of rows. Note this
     * screen is device independent - it's the screen defined by the
     * GIF file parameters.
     */
    if ((ScreenBuffer = (GifRowType *)
	malloc(GifFile->SHeight * sizeof(GifRowType))) == NULL)
		return;

    Size = GifFile->SWidth * sizeof(GifPixelType);/* Size in bytes one row.*/
    if ((ScreenBuffer[0] = (GifRowType) malloc(Size)) == NULL) /* First row. */
		return;

    for (i = 0; i < GifFile->SWidth; i++)  /* Set its color to BackGround. */
	ScreenBuffer[0][i] = GifFile->SBackGroundColor;
    for (i = 1; i < GifFile->SHeight; i++) {
	/* Allocate the other rows, and set their color to background too: */
	if ((ScreenBuffer[i] = (GifRowType) malloc(Size)) == NULL)
		return;

	memcpy(ScreenBuffer[i], ScreenBuffer[0], Size);
    }

    /* Scan the content of the GIF file and load the image(s) in: */
    do {
		DGifGetRecordType(GifFile, &RecordType);
	
	switch (RecordType) {
	    case IMAGE_DESC_RECORD_TYPE:
		if (DGifGetImageDesc(GifFile) == GIF_ERROR)
			return;
			
		Row = GifFile->Image.Top; /* Image Position relative to Screen. */
		Col = GifFile->Image.Left;
		Width = GifFile->Image.Width;
		Height = GifFile->Image.Height;
		if (GifFile->Image.Left + GifFile->Image.Width > GifFile->SWidth ||
		   GifFile->Image.Top + GifFile->Image.Height > GifFile->SHeight)
			   return;
		if (GifFile->Image.Interlace) {
		    /* Need to perform 4 passes on the images: */
		    for (i = 0; i < 4; i++)
			for (j = Row + InterlacedOffset[i]; j < Row + Height;
						 j += InterlacedJumps[i]) {
				DGifGetLine(GifFile, &ScreenBuffer[j][Col], Width);
			}
		}
		else {
		    for (i = 0; i < Height; i++)
				DGifGetLine(GifFile, &ScreenBuffer[Row++][Col], Width);
		}
		break;
	    case EXTENSION_RECORD_TYPE:
		/* Skip any extension blocks in file: */
		DGifGetExtension(GifFile, &ExtCode, &Extension);

		while (Extension != NULL)
		    DGifGetExtensionNext(GifFile, &Extension);
		
		break;
	    case TERMINATE_RECORD_TYPE:
		break;
	    default:		    /* Should be trapped by DGifGetRecordType. */
		break;
	}
    } while (RecordType != TERMINATE_RECORD_TYPE);

    /* Lets dump it - set the global variables required and do it: */
    ColorMap = (GifFile->Image.ColorMap
		? GifFile->Image.ColorMap
		: GifFile->SColorMap);
    if (ColorMap == NULL)
		return;

	sprite[ on_sprite ].size_x = GifFile->SWidth;
	sprite[ on_sprite ].size_y = GifFile->SHeight;
	if ( sprite[ on_sprite ].size_x >= MAX_SIZE_X )
		sprite[ on_sprite ].size_x = MAX_SIZE_X;
	if ( sprite[ on_sprite ].size_y >= MAX_SIZE_Y )
		sprite[ on_sprite ].size_y = MAX_SIZE_Y;
	
	for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ ) {
		GifRow = ScreenBuffer[y-1];
		for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ ) {
			ColorMapEntry = &ColorMap->Colors[GifRow[x-1]];
			/* **HACK** (GIF) - use 500 for darker pictures, 300 for a reduced sensivity */
			sprite[ on_sprite ].p[ x ][ y ] = ( (ColorMapEntry->Red+ColorMapEntry->Blue+ColorMapEntry->Green) < 400 );
		}
	}



    (void)free(ScreenBuffer);

	fit_sprite_s_on_screen();
	update_screen();
	
    DGifCloseFile(GifFile, &Error);
}
#endif


int getword (FILE *fpin) {
	int b;
	b=getc(fpin);
	return (b+256*getc(fpin));
}

/* Hint: extract from Commodore disk images with DirMaster */

void import_from_geos( const char *file )
{
	FILE *fpin = NULL;
	int x, y, i;
	unsigned char b,id;
	int rowbytes, y_sz;
	int spcount, exitflag, bflag;
	int index, pindex;
	long ipos;

	spcount = exitflag = 0;
	
	fpin = fopen( file, "rb" );
	if (!fpin)
		return;
	
	
	id=getc(fpin);
	/* Shift file pointers if the extracted file includes the C64 header */
	if (id==0x83) fseek(fpin,0x2fb,SEEK_SET);
	rowbytes = getword(fpin);
	y_sz = getc(fpin);
	
	
	if ((ipos = getword(fpin))==8) {
	/* 1st bit pos is always 0 */
	ipos +=2;
	pindex=0;
	
	// Naked VLIR record found, no header block
	
		while (!exitflag) {
			sprite[ on_sprite + spcount ].size_y = y_sz;
			/* **HACK** - Extra row on top of GEOS font */
			//sprite[ on_sprite + spcount ].size_y = y_sz+1;
			if (id==0x83)
				fseek(fpin,ipos+0x2fa,SEEK_SET);
			else
				fseek(fpin,ipos,SEEK_SET);
			
			index=getword(fpin);

			sprite[ on_sprite + spcount ].size_x = index-pindex;

			if ( sprite[ on_sprite + spcount ].size_x >= MAX_SIZE_X )
				sprite[ on_sprite + spcount ].size_x = MAX_SIZE_X;
			if ( sprite[ on_sprite + spcount ].size_y >= MAX_SIZE_Y )
				sprite[ on_sprite + spcount ].size_y = MAX_SIZE_Y;
			
			for ( y = 0; y < y_sz; y++ ) {
				i=pindex;
				for ( x = 0; x < sprite[ on_sprite + spcount ].size_x; x++ ) {
					if (id==0x83)
						fseek(fpin,(long)(0x2fa+0xca+(y*rowbytes)+(i/8)),SEEK_SET);
					else
						fseek(fpin,(long)(0xca+(y*rowbytes)+(i/8)),SEEK_SET);
					b=getc(fpin);

					b=b>>(7-(i%8));
					sprite[ on_sprite + spcount ].p[ x+1 ][ y+1 ] = ((b&1) != 0);
					/* **HACK** - Extra row on top of GEOS font */
					//sprite[ on_sprite + spcount ].p[ x+1 ][ y+2 ] = ((b&1) != 0);
					i++;
				}
			}
			
			/* Adjust font height */
			bflag=0;
			sprite[ on_sprite  + spcount ].size_y++;
			while (bflag == 0) {
				sprite[ on_sprite  + spcount ].size_y--;
				for ( x = sprite[ on_sprite + spcount ].size_x; x > 0 ; x-- )
					if (sprite[ on_sprite + spcount ].p[ x ][ sprite[ on_sprite + spcount ].size_y ] != 0) bflag=1;
				if (sprite[ on_sprite + spcount ].size_y <= 1) bflag=1;
			}

			pindex=index;
			
			ipos+=2;
			
			spcount++;
			if (spcount >= 95) exitflag++;
			if ((on_sprite + spcount)>=MAX_SPRITE) exitflag++;
		}
			
	}
	fseek(fpin,0L,SEEK_SET);
		 
	fclose(fpin);

	fit_sprite_s_on_screen();
	update_screen();
}


void import_from_bitmap( const char *file )
{
	ALLEGRO_BITMAP *temp = NULL;
	FILE *fpin = NULL;
	long len;
	int x, y, i, j;
	unsigned char r = 0;
	unsigned char g = 0;
	unsigned char b = 0;
	char c;
	char xsz[10];
	char ysz[10];
	char pos[10];
	int maxy;
	int pixel;
	char row[1000];
	char foo[10];
	int exitflag;
	
	int spcount = 0;

	//char message[200];
	
	al_set_new_bitmap_flags(ALLEGRO_MEMORY_BITMAP);
	temp = al_load_bitmap( file );
	al_set_new_bitmap_flags(ALLEGRO_VIDEO_BITMAP);
	if (temp) {
		sprite[ on_sprite ].size_x = al_get_bitmap_width(temp);
		sprite[ on_sprite ].size_y = al_get_bitmap_height(temp);
		if ( sprite[ on_sprite ].size_x >= MAX_SIZE_X )
			sprite[ on_sprite ].size_x = MAX_SIZE_X;
		if ( sprite[ on_sprite ].size_y >= MAX_SIZE_Y )
			sprite[ on_sprite ].size_y = MAX_SIZE_Y;
		for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
			for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ ) {
				al_unmap_rgb(al_get_pixel( temp, x - 1, y - 1 ),&r ,&g ,&b);
				/* **HACK**, use 500 for darker pictures, 300 for a reduced sensivity */
				sprite[ on_sprite ].p[ x ][ y ] = ( (r+g+b) < 400 );
			}
	} else {
		fpin = fopen( file, "rb" );
		if (!fpin)
			return;
		if	(fseek(fpin,0,SEEK_END))
			return;
		len=ftell(fpin);
		fseek(fpin,0L,SEEK_SET);
		

		// Import as generic 8x8 character dump, this will be overwritten if better solutions are found
		/* **HACK** - change character height at your convenience for binary capture */
		#define CHAR_H		8
		
		// remove some byte hoping to cut away headers
		/* **HACK** - remove or adjust the following line to change the loader starting point */
		for (x=0;x<(len%16);x++) getc(fpin); 
		sprite[ on_sprite ].size_x = 128;
		sprite[ on_sprite ].size_y = CHAR_H*len/128;
		if ( sprite[ on_sprite ].size_y >= MAX_SIZE_Y )
			sprite[ on_sprite ].size_y = MAX_SIZE_Y;
		
		for ( y = 0; y < len/(16*CHAR_H); y++ )
			for ( x = 0; x < 16; x++ )
				for ( i = 1; i <= CHAR_H; i++ ) {
					b=getc(fpin);
					for ( j = 1; j <= 8; j++ ) {
						// sprite[ on_sprite ].p[ x*8+9-j ]  <- invert horiz.
						sprite[ on_sprite ].p[ x*8+j ][ y*CHAR_H+i ] = ((b&128) != 0);
						b<<=1;
					}
				}
		
		fseek(fpin,0L,SEEK_SET);

		// PBM format
		while (!feof(fpin) && fgetc(fpin)=='P' && fgetc(fpin)=='1' && fgetc(fpin)=='\n') {
			// rip comments
			while ((c=fgetc(fpin))=='#') 
				while ((c=fgetc(fpin))!='\n') {}
			ungetc(c, fpin);
			// current pic size
			fscanf(fpin,"%s %s",xsz,ysz);
				//sprintf(message, "Load start: %s %s",xsz,ysz);
				//al_show_native_message_box(display, "MSG", "Message", message, NULL, 0);
			sprite[ on_sprite + spcount ].size_x = atoi(xsz);
			sprite[ on_sprite + spcount ].size_y = atoi(ysz);
			if ( sprite[ on_sprite + spcount ].size_x >= MAX_SIZE_X )
				sprite[ on_sprite + spcount ].size_x = MAX_SIZE_X;
			if ( sprite[ on_sprite + spcount ].size_y >= MAX_SIZE_Y )
				sprite[ on_sprite + spcount ].size_y = MAX_SIZE_Y;
			
			for ( y = 1; y <= atoi(ysz); y++ )
				for ( x = 1; x <= atoi(xsz); x++ ) {
					fscanf(fpin,"%1i",&pixel);
					sprite[ on_sprite + spcount ].p[ x ][ y ] = (pixel==1?1:0);
				}
			spcount++;
		}
		
		fseek(fpin,0L,SEEK_SET);
		maxy=0;
		
		fscanf(fpin,"%s",row);
		if ((!strcmp(row,"STARTFONT"))||(!strncmp(row,"COMMENT",8))) {
			spcount=0;
			
			exitflag=0;
			while (exitflag==0) {

				sprite[ on_sprite + spcount ].size_x=0;
				sprite[ on_sprite + spcount ].size_y=0;
				
				while (((sprite[ on_sprite + spcount ].size_x==0)||(sprite[ on_sprite + spcount ].size_y==0)) && !exitflag) {
					sprintf (row,"ABC");
					while (strncmp(row, "BBX",3)&&(!feof(fpin)) && !exitflag) {
						fgets(row,sizeof(row),fpin);
						if (!strncmp(row, "ENDFONT",7)) exitflag=1;
					}
					sscanf(row,"%s %s %s %s %s",foo,xsz,ysz,foo,pos);
					sprite[ on_sprite + spcount ].size_x = g = atoi(xsz);
					sprite[ on_sprite + spcount ].size_y = atoi(ysz);
					if (g%8) {g=g/8+1;}
					else g=g/8;
				}
				
				if (maxy < sprite[ on_sprite + spcount ].size_y)  maxy = sprite[ on_sprite + spcount ].size_y;
				
				if (!exitflag) {
					while (strncmp(row, "BITMAP",3) && (!feof(fpin)))
						fgets(row,sizeof(row),fpin);
					
					for ( y = 1; y <= sprite[ on_sprite + spcount ].size_y; y++ ) {
						for ( x = 0; x < g; x++ ) {
							fscanf(fpin,"%2X",&pixel);

							for ( i = 1; i <= 8; i++ ) {
							sprite[ on_sprite + spcount ].p[ x*8+i ][ y ] = ((pixel&128) != 0);
							pixel<<=1;
							}
						}
					}
				}
				
				/* **HACK** (BDF font import), remove this code to exclude vertical shifting */
				for (b=sprite[ on_sprite + spcount ].size_y; b<(maxy-atoi(pos)); b++) {
					sprite[ on_sprite + spcount ].size_y++;
					for ( y = sprite[ on_sprite + spcount ].size_y; y > 0 ; y-- )
						for ( x = 1; x <= sprite[ on_sprite + spcount ].size_x; x++ )
							sprite[ on_sprite + spcount ].p[ x ][ y ] = sprite[ on_sprite + spcount ].p[ x ][ y - 1 ];
				}

				/* **HACK** (BDF font import), remove this code for fixed height font */
				/* Adjust font height */
				b=0;
				sprite[ on_sprite + spcount ].size_y++;
				while (b == 0) {
					sprite[ on_sprite + spcount ].size_y--;
					for ( x = sprite[ on_sprite + spcount ].size_x; x > 0 ; x-- )
						if (sprite[ on_sprite + spcount ].p[ x ][ sprite[ on_sprite + spcount ].size_y ] != 0) b=1;
					if (sprite[ on_sprite + spcount ].size_y <= 1) b=1;
				}
				//sprite[ on_sprite  + spcount ].size_y++;

				/* **HACK** (BDF font import), right margin adj. */
				sprite[ on_sprite + spcount ].size_x++;
				spcount++;
				if ((on_sprite + spcount)>=MAX_SPRITE) exitflag=1;
			}
		}
		
		fseek(fpin,0L,SEEK_SET);
		
		// **HACK** PrintShop clipart libraries
		/*
		if (((len%572)==0)||(((len-10)%572)==0)) {
			spcount=0;
			if (((len-10)%572)==0)
				for ( x = 1; x <= 10; x++ ) fgetc(fpin);
			while (!feof(fpin)) {
			//for ( x = 1; x <= 10; x++ ) fgetc(fpin);
			sprite[ on_sprite+spcount ].size_x = 88;
			sprite[ on_sprite+spcount ].size_y = 52;
			for ( y = 1; y <= sprite[ on_sprite+spcount ].size_y; y++ )
				for ( x = 1; x <= sprite[ on_sprite+spcount ].size_x; x+=8 ) {
					b=getc(fpin);
					for ( i = 0; i < 8; i++ ) {
					sprite[ on_sprite+spcount ].p[ x+i ][y] = ((b&128) != 0);
					b<<=1;
					}
				}
			spcount++;
			}
		}
		fseek(fpin,0L,SEEK_SET);
		*/

		// Psion PIC files
		while (!feof(fpin) && fgetc(fpin)=='P' && fgetc(fpin)=='I' && fgetc(fpin)=='C' && fgetc(fpin)==0xdc) {
			getc(fpin); getc(fpin); 	// skip version
			c = getc(fpin)+256*getc(fpin);
			for (spcount=0; spcount<=c; spcount++) {
				getc(fpin); getc(fpin); 	// skip crc
				sprite[ on_sprite+spcount ].size_x = getc(fpin)+256*getc(fpin);
				sprite[ on_sprite+spcount ].size_y = getc(fpin)+256*getc(fpin);
				for ( b = 0; b<18; b++ ) getc(fpin); // skip extra pic related stuff
				for ( y = 1; y <= sprite[ on_sprite+spcount ].size_y; y++ )
					for ( x = 1; x <= sprite[ on_sprite+spcount ].size_x; x+=8 ) {
						b=getc(fpin);
						for ( i = 0; i < 8; i++ ) {
						sprite[ on_sprite+spcount ].p[ x+i ][y] = ((b&1) != 0);
						b>>=1;
						}
					}
				/* mask */
				spcount++;
				sprite[ on_sprite+spcount ].size_x = sprite[ on_sprite+spcount-1 ].size_x;
				sprite[ on_sprite+spcount ].size_y = sprite[ on_sprite+spcount-1 ].size_y;
				for ( y = 1; y <= sprite[ on_sprite+spcount ].size_y; y++ )
					for ( x = 1; x <= sprite[ on_sprite+spcount ].size_x; x+=8 ) {
						b=getc(fpin);
						for ( i = 0; i < 8; i++ ) {
						sprite[ on_sprite+spcount ].p[ x+i ][y] = ((b&1) != 0);
						b>>=1;
						}
					}
			}
		}

		fseek(fpin,0L,SEEK_SET);
		
		// ZX Spectrum Screen dump
		if ((len==6144)||(len==6912)) {
			sprite[ on_sprite ].size_x = 255;
			sprite[ on_sprite ].size_y = 191;
			for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
				for ( x = 1; x <= sprite[ on_sprite ].size_x; x+=8 ) {
					b=getc(fpin);
					for ( i = 0; i < 8; i++ ) {
					sprite[ on_sprite ].p[ x+i ][ (64*(y/64)+8*(y&7)+((y&63)>>3)) ] = ((b&128) != 0);
					b<<=1;
					}
				}
		}
		
		// Import font from ZX Spectrum Snapshot (a 27 bytes header with register values followed by the memory dump)
		if ((len==49179)||(len==131103)) {
			fseek(fpin,7249L,SEEK_SET);
			i=256+getc(fpin)+256*getc(fpin)-16384+27;
			if (i>0) { //&&(i<32700)) {
				fseek(fpin,(long)i,SEEK_SET);
				sprite[ on_sprite ].size_x = 96;
				sprite[ on_sprite ].size_y = 80;
				for ( y = 0; y < 8; y++ )
					for ( x = 0; x < 12; x++ )
						for ( i = 1; i <= 8; i++ ) {
							b=getc(fpin);
							for ( j = 1; j <= 8; j++ ) {
								sprite[ on_sprite ].p[ x*8+j ][ y*8+i ] = ((b&128) != 0);
								b<<=1;
							}
						}
			}
			fseek(fpin,7318L,SEEK_SET);
			i=getc(fpin)+256*getc(fpin)-16384+27;
			if (i>0) { //&&(i<32750)) {
				fseek(fpin,(long)i,SEEK_SET);
				sprite[ on_sprite ].size_x = 96;
				sprite[ on_sprite ].size_y = 80;
				for ( y = 8; y < 10; y++ )
					for ( x = 0; x < 12; x++ )
						for ( i = 1; i <= 8; i++ ) {
							b=getc(fpin);
							for ( j = 1; j <= 8; j++ ) {
								sprite[ on_sprite ].p[ x*8+j ][ y*8+i ] = ((b&128) != 0);
								b<<=1;
							}
						}
			}

		}
		
		fclose(fpin);
	}
	fit_sprite_s_on_screen();
	update_screen();
	
}

void import_from_printmaster( const char *file )
{
	FILE *fpin = NULL;
	int x, y, i, spcount;
	unsigned char b;
	
	fpin = fopen( file, "rb" );
	if (!fpin)
		return;

	/* **HACK** - Eat leading bytes to import Newsmaster/Printmaster fonts */
	/*
	for ( y = 1; y < 0xb7; y++ )
		fgetc(fpin);
	*/

	spcount = 0;	
	while ((fgetc(fpin) != 0x1a) && !feof(fpin) && ((on_sprite+spcount)<150)) {

//	x=fgetc(fpin);
	/*
	if ((x>200) || (x<8)) {
		fclose(fpin);
		return;
	} */
	y=fgetc(fpin); 
	x=fgetc(fpin); /*
	if ((y>200) || (y<8)) {
		fclose(fpin);
		return;
	}
	*/
	fgetc(fpin);

	sprite[ on_sprite+spcount ].size_x = x;
	sprite[ on_sprite+spcount ].size_y = y;
	for ( y = 1; y <= sprite[ on_sprite+spcount ].size_y; y++ )
		for ( x = 1; x <= sprite[ on_sprite+spcount ].size_x; x+=8 ) {
			b=getc(fpin);
			for ( i = 0; i < 8; i++ ) {
			sprite[ on_sprite+spcount ].p[ x+i ][ y ] = ((b&128) != 0);
			b<<=1;
			}
		}
	fgetc(fpin);
	spcount++;
	}

	fclose(fpin);

	fit_sprite_s_on_screen();
	update_screen();
}

void do_import_raw()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_bmp = al_create_native_file_dialog("./", "Load bitmap", bmpPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_bmp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_bmp, 0));
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);
	al_destroy_native_file_dialog(file_dialog_bmp);

	import_from_bitmap( file );
	al_destroy_path(path);
	
	wkey_release(ALLEGRO_KEY_L);
}

void do_import_geos()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_bmp = al_create_native_file_dialog("./", "Load GEOS font", geosPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_bmp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_bmp, 0));
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);
	al_destroy_native_file_dialog(file_dialog_bmp);

	import_from_geos( file );
	al_destroy_path(path);
	
	wkey_release(ALLEGRO_KEY_O);
}

#ifdef GIF_SUPPORT
void do_import_gif()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_bmp = al_create_native_file_dialog("./", "Load GIF picture", gifPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_bmp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_bmp, 0));
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);
	al_destroy_native_file_dialog(file_dialog_bmp);

	import_from_gif( file );
	al_destroy_path(path);
	
	wkey_release(ALLEGRO_KEY_G);
}
#endif

void do_import_bitmap()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_bmp = al_create_native_file_dialog("./", "Load bitmap", bmpPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_bmp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_bmp, 0));
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);
	al_destroy_native_file_dialog(file_dialog_bmp);

	import_from_bitmap( file );
	al_destroy_path(path);
	
	wkey_release(ALLEGRO_KEY_L);
}

void do_import_printmaster()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_shp = al_create_native_file_dialog("./", "Import Newsmaster/Printmaster pictures", shpPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_shp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_shp, 0));
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);
	al_destroy_native_file_dialog(file_dialog_shp);

	import_from_printmaster( file );
	al_destroy_path(path);
	
	wkey_release(ALLEGRO_KEY_N);
}

//Saves a header file with sprites 0-on_sprite for use with z88dk
void save_code_file( const char *file, int mode )
{
	ALLEGRO_FILE *f = NULL;
	int i;

	f = al_fopen( file, "w" );
	if (!f) {
		al_fclose( f );
		return;
	}
	al_fputs( f, "// Generated by Daniel McKinnon's z88dk Sprite Editor\n" );

	for ( i = 0; i <= on_sprite; i++ )
	{
		generate_codes( i, mode );
		al_fputs( f, hexcode );
	}

	al_fclose( f );

}



void save_sprite_file( const char *file )
{
	gzFile f = NULL;
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

void load_sprite_file( const char *file )
{
	gzFile f = NULL;
	int x,y,i;

	f = gzopen( file, "rb" );
	if (!f) {
		return;
	}
	
	on_sprite=0;

	for ( i = 0; i <= MAX_SPRITE; i++ )
	{
		sprite[ i ].size_x = gzgetc (f);
		sprite[ i ].size_y = gzgetc (f);
		for ( x = 0; x < MAX_SIZE_X; x++ )
			for ( y = 0; y < MAX_SIZE_Y; y++ ) {
				sprite[ i ].p[ x ][ y ] = gzgetc (f);
				/* **HACK** - Force the font size on open */
				//sprite[ i ].size_x=4;
				//sprite[ i ].size_y=7;
			}
			
		/* **HACK** - auto-adjust height on open */
		/*
		b=0;
		sprite[ i ].size_y++;
		while (b == 0) {
			sprite[ i ].size_y--;
			for ( x = sprite[ i ].size_x; x > 0 ; x-- )
				if (sprite[ i ].p[ x ][ sprite[ i ].size_y ] != 0) b=1;
			if (sprite[ i ].size_y <= 1) b=1;
		}*/

	}

	gzclose( f );

	fit_sprite_s_on_screen();
	update_screen();
}


void merge_sprite_file( const char *file )
{
	gzFile f = NULL;
	int x,y,i;

	f = gzopen( file, "rb" );
	if (!f) {
		return;
	}

	for ( i = on_sprite; i <= MAX_SPRITE; i++ )
	{
		sprite[ i ].size_x = gzgetc (f);
		sprite[ i ].size_y = gzgetc (f);
		for ( x = 0; x < MAX_SIZE_X; x++ )
			for ( y = 0; y < MAX_SIZE_Y; y++ ) {
				sprite[ i ].p[ x ][ y ] = gzgetc (f);
			}
	}

	gzclose( f );

	update_screen();
}


void load_sevenup_file( const char *file )
{
	FILE *f = NULL;
	int x,y,i,j,c;

	f = fopen( file, "rb" );
	if (!f) {
		return;
	}
	
	if (getc(f) != 'S') {
		fclose( f );
		return;
	}
	if (getc(f) != 'e') {
		fclose( f );
		return;
	}
	if (getc(f) != 'v') {
		fclose( f );
		return;
	}
	
	for (i=0; i<7; i++) getc(f);
	
	sprite[ on_sprite ].size_x = getc(f);
	getc(f);
	sprite[ on_sprite ].size_y = getc(f);
	getc(f);
	
	
	for ( x = 0; x < (1 + (sprite[ on_sprite ].size_y-1) / 8); x++ )
		for ( y = 0; y < (1 + (sprite[ on_sprite ].size_x-1) / 8); y++ ) {
 			for ( j = 0; j <= 8; j++ ) {
				c = getc(f);
				for ( i = 0; i <= 8; i++ ) {
					sprite[ on_sprite ].p[ y*8+i+1 ][ x*8+j+1 ] = ((c & 128)!=0);
					c <<= 1;
				}
			}
		}

	fclose( f );

	fit_sprite_s_on_screen();
	update_screen();
}


//The file selector for saving code files
void do_save_code(int mode)
{
	const char *file = NULL;

	path=NULL;
	file_dialog_sv = al_create_native_file_dialog("./", "Generate C header for sprites", sprHeader, ALLEGRO_FILECHOOSER_SAVE);
	al_show_native_file_dialog(display, file_dialog_sv);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_sv, 0));
	al_set_path_extension(path, ".h");
	al_destroy_native_file_dialog(file_dialog_sv);
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);

	save_code_file( file, mode );
	al_destroy_path(path);

	if (mode)
		wkey_release(ALLEGRO_KEY_F5);
	else
		wkey_release(ALLEGRO_KEY_F7);
}

//The file selector for saving sprite files
void do_save_sprites()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_svsp = al_create_native_file_dialog("./", "Save all editor memory", sprPatterns, ALLEGRO_FILECHOOSER_SAVE);
	al_show_native_file_dialog(display, file_dialog_svsp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_svsp, 0));
	al_set_path_extension(path, ".sgz");
	al_destroy_native_file_dialog(file_dialog_svsp);
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);

	save_sprite_file( file );
	al_destroy_path(path);

	wkey_release(ALLEGRO_KEY_F2);
}

//The file selector for loading sprite files
void do_load_sprites()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_ldsp = al_create_native_file_dialog("./", "Load sprites", sprPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_ldsp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_ldsp, 0));
	al_set_path_extension(path, ".sgz");
	al_destroy_native_file_dialog(file_dialog_ldsp);
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);

	load_sprite_file( file );
	al_destroy_path(path);

	wkey_release(ALLEGRO_KEY_F3);
}

//The file selector for mergining sprite files
void do_merge_sprites()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_ldsp = al_create_native_file_dialog("./", "Merge sprites", sprPatterns, ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_ldsp);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_ldsp, 0));
	al_set_path_extension(path, ".sgz");
	al_destroy_native_file_dialog(file_dialog_ldsp);
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);

	merge_sprite_file( file );
	al_destroy_path(path);

	wkey_release(ALLEGRO_KEY_F6);
}

//The file selector for loading SevenuP files
void do_load_sevenup()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_ldsev = al_create_native_file_dialog("./", "Load SevenuP sprite", "*.sev", ALLEGRO_FILECHOOSER_FILE_MUST_EXIST);
	al_show_native_file_dialog(display, file_dialog_ldsev);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_ldsev, 0));
	al_set_path_extension(path, ".sev");
	al_destroy_native_file_dialog(file_dialog_ldsev);
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);

	load_sevenup_file( file );
	al_destroy_path(path);

	wkey_release(ALLEGRO_KEY_F4);
}


//Resets all sprites to default size
void reset_sprites()
{
	int i;
	for ( i = 0; i <= MAX_SPRITE; i++ )
	{
		sprite[ i ].size_x = DEFAULT_SIZE_X;
		sprite[ i ].size_y = DEFAULT_SIZE_Y;
	}
	
	/*
	// **HACK** Use this loader to recover sprites from pre-generated binary data (e.g. "thefont[]")
	
	int i,x,y,j,b,p,x0,y0;
	
	i=0;
	p=0;
	x0 = thefont[p];
	p++;
	while (x0 != 0) {
		y0 = thefont[p];
		p++;
		sprite[ i ].size_x = x0;
		sprite[ i ].size_y = y0;
		for ( y = 0; y < y0; y++ )
			for ( x = 1; x <= x0; x+=8 ) {
				b=thefont[p];
				p++;
				for ( j = 0; j < 8; j++ ) {
					sprite[ i ].p[ x+j ][ y+1 ] = ((b&128) != 0);
					b<<=1;
				}
			}
		x0 = thefont[p];
		p++;  i++;
	}
	*/

/*
	// **HACK** Use this code to load fonts created for the GLCD format
	// set FONTX and FONTY properly and include the font data as follows:
	// char thefont[] ={0x04, 0x00, 0x00...   };
	
	int i,x,y,j,b,p;
	
	#define FONTX  7
	#define FONTY  11
	
	i=0;
	p=0;
	for (i=0; i<=64; i++) {
		sprite[ i ].size_x = thefont[p]+1;
		p++;
		sprite[ i ].size_y = FONTY;
		for ( x = 0; x < FONTX; x++ ) {
			for ( y = 0; y <FONTY; y+=8 ) {
				b=thefont[p];
				p++;
				for ( j = 1; j <= 8; j++ ) {
					sprite[ i ].p[ 1+x ][ y+j ] = ((b&1) != 0);
					b>>=1;
				}
			}
		}
	}
*/
}

//Copies sprite[ src ].p[][] to sprite[ dest ].p[][]
void copy_sprite( int src, int dest )
{
	int x, y;

	//Copy sizes
	sprite[ dest ].size_x = sprite[ src ].size_x;
	sprite[ dest ].size_y = sprite[ src ].size_y;

	//Copy Sprite data
	for ( x = 1; x <= sprite[ src ].size_x; x++ )
		for ( y = 1; y <= sprite[ src ].size_y; y++ )
			sprite[ dest ].p[ x ][ y ] = sprite[ src ].p[ x ][ y ];

	update_screen();
}


void clear_sprite()
{
	int x, y;
	//clear Sprite data
	for ( x = 0; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = 0; y <= sprite[ on_sprite ].size_y; y++ )
			sprite[ on_sprite ].p[ x ][ y ] = 0;
	update_screen();
}


void clean_sprites()
{
	int x, y, i;
	//Clean out of bounds Sprite areas
	for (i=0; i<MAX_SPRITE; i++)
		for ( x = 1; x < MAX_SIZE_X; x++ )
			for ( y = 1; y < MAX_SIZE_Y; y++ )
				if (((x > sprite[ i ].size_x) || (y > sprite[ i ].size_y)) || (x==0) || (y==0))
					sprite[ i ].p[ x ][ y ] = 0;
}


void insert_sprite()
{
int i;
	for (i=MAX_SPRITE-1; i >= on_sprite; i--)
		copy_sprite( i, i+1 );
	clear_sprite();
	wkey_release(ALLEGRO_KEY_INSERT);
}

void remove_sprite()
{
int i;
	for (i=on_sprite; i < MAX_SPRITE; i++)
		copy_sprite( i+1, i );
	update_screen();
	wkey_release(ALLEGRO_KEY_DELETE);
}

//Compute the copied sprite's mask and paste it in a new one
void copy_sprite_mask( int src, int dest )
{
	int x1, x2, y;
	int fx1, fx2;

	int y1, y2, x;
	int fy1, fy2;
	
	//Copy sizes
	sprite[ dest ].size_x = sprite[ src ].size_x;
	sprite[ dest ].size_y = sprite[ src ].size_y;

	//look for bytes to mask horizontally
	for ( y = 1; y <= sprite[ src ].size_y; y++ ) {
		x1 = 1; x2 = sprite[ src ].size_x;
		fx1 = fx2 = FALSE;
		while ( (( fx1 == FALSE ) || ( fx2 == FALSE )) && (x2 >= x1) )  {
			if ( sprite[ src ].p[ x1 ][ y ] || sprite[ src ].p[ x1 + 1 ][ y ] )  {
				fx1 = TRUE;
				sprite[ dest ].p[ x1 ][ y ] = 2;
			}
			if ( sprite[ src ].p[ x2 ][ y ] || sprite[ src ].p[ x2 - 1 ][ y ] )  {
				fx2 = TRUE;
				sprite[ dest ].p[ x2 ][ y ] = 2;
			}
			
			if ( fx1 != TRUE ) {
				if ( sprite[ dest ].p[ x1 ][ y ] != 2 )
					sprite[ dest ].p[ x1 ][ y ] = 3;
				x1++;
			}
			if ( fx2 != TRUE ) {
				if ( sprite[ dest ].p[ x2 ][ y ] != 2 )
					sprite[ dest ].p[ x2 ][ y ] = 3;
				x2--;
			}
		}
	}

	//look for bytes to mask vertically
	for ( x = 1; x <= sprite[ src ].size_x; x++ ) {
		y1 = 1; y2 = sprite[ src ].size_y;
		fy1 = fy2 = FALSE;
		while ( (( fy1 == FALSE ) || ( fy2 == FALSE )) && (y2 >= y1) )  {
			if ( sprite[ src ].p[ x ][ y1 ] || sprite[ src ].p[ x ][ y1 + 1 ] )  {
				fy1 = TRUE;
				sprite[ dest ].p[ x ][ y1 ] = 2;
			}
			if ( sprite[ src ].p[ x ][ y2 ] || sprite[ src ].p[ x ][ y2 - 1 ] )  {
				fy2 = TRUE;
				sprite[ dest ].p[ x ][ y2 ] = 2;
			}
			
			if ( fy1 != TRUE ) {
				if ( sprite[ dest ].p[ x ][ y1 ] != 2 )
					sprite[ dest ].p[ x ][ y1 ] = 3;
				y1++;
			}
			if ( fy2 != TRUE ) {
				if ( sprite[ dest ].p[ x ][ y2 ] != 2 )
					sprite[ dest ].p[ x ][ y2 ] = 3;
				y2--;
			}
		}
	}

	//now pixels marked with '3' or '2' are the mask bits, convert to white:
	//everything else is black
	for ( x = 1; x <= sprite[ src ].size_x; x++ )
		for ( y = 1; y <= sprite[ src ].size_y; y++ )
			sprite[ dest ].p[ x ][ y ] = ( sprite[ dest ].p[ x ][ y ] < 3 );

	update_screen();
}


void do_help_page() {
	al_clear_to_color (al_map_rgb(240,230,250) );
	
	al_draw_text(font, al_map_rgb(20,5,10), 8, 5, ALLEGRO_ALIGN_LEFT, "Image Editing");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 30, ALLEGRO_ALIGN_LEFT, "Up / Down..............Zoom In / Out");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 50, ALLEGRO_ALIGN_LEFT, "SHIFT + arrow keys.....Scroll Sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 70, ALLEGRO_ALIGN_LEFT, "H/V/D..................Flip sprite horizontally/vertically/diagonally");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 90, ALLEGRO_ALIGN_LEFT, "SHIFT + DEL............Remove sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 110, ALLEGRO_ALIGN_LEFT, "INS / DEL..............Insert/Clear a sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 130, ALLEGRO_ALIGN_LEFT, "I......................Invert Sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 150, ALLEGRO_ALIGN_LEFT, "SHIFT + H/V............Double Width/Height");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 170, ALLEGRO_ALIGN_LEFT, "5......................Reduce sprite size at 50%");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 190, ALLEGRO_ALIGN_LEFT, "F/SHIFT + F............Fit: auto zoom or use SHIFT to adjust margins");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 210, ALLEGRO_ALIGN_LEFT, "C/P....................Copy/Paste sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 230, ALLEGRO_ALIGN_LEFT, "SHIFP + P.......Split the copied sprite into pieces as big as the current ");
	al_draw_text(font, al_map_rgb(0,5,10), 140, 250, ALLEGRO_ALIGN_LEFT, "sprite and paste them starting from the current sprite position.");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 270, ALLEGRO_ALIGN_LEFT, "M......................Compute mask for copied sprite and paste to current sprite");
	al_draw_text(font, al_map_rgb(20,5,10), 8, 300, ALLEGRO_ALIGN_LEFT, "Saving / Loading");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 325, ALLEGRO_ALIGN_LEFT, "F2.....................Saves all sprites (editor specific format)");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 345, ALLEGRO_ALIGN_LEFT, "F3/F6..................Load/Merge sprites (editor format), merge over current pos.");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 365, ALLEGRO_ALIGN_LEFT, "F4.....................Load SevenuP sprite at current position");
	#ifdef GIF_SUPPORT
	al_draw_text(font, al_map_rgb(0,5,10), 8, 385, ALLEGRO_ALIGN_LEFT, "G/L....................Import GIF / BMP,LBM,PCX,TGA,PNG,PBM,BDF,SNA,SCR,RAWdata");
	#else
	al_draw_text(font, al_map_rgb(0,5,10), 8, 385, ALLEGRO_ALIGN_LEFT, "L......................Import BMP,LBM,PCX,TGA,PNG,PBM,BDF,SNA,SCR,RAWdata");
	#endif
	al_draw_text(font, al_map_rgb(0,5,10), 8, 405, ALLEGRO_ALIGN_LEFT, "N......................Import pictures from a Printmaster/Newsmaster (MSDOS) lib");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 425, ALLEGRO_ALIGN_LEFT, "O......................Import a GEOS font (.CVT)");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 445, ALLEGRO_ALIGN_LEFT, "F5.....................Generate a C language header definition for");
	al_draw_text(font, al_map_rgb(0,5,10), 190, 465, ALLEGRO_ALIGN_LEFT, "all the sprites up to the current one");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 485, ALLEGRO_ALIGN_LEFT, "F7.....................As above, RAW data only (no size/headers)");

	al_flip_display();

	do {
	al_get_keyboard_state(&pressed_keys);
	}	while (al_key_down(&pressed_keys, ALLEGRO_KEY_F1 ));

}


void do_preview_page() {
	int x,y,spcount, xmargin, ymargin;
	char text[100];
	int cksum;
	cksum=0;
	
	al_clear_to_color (al_map_rgb(230,240,250) );
	spcount=0;
	xmargin=0;
	ymargin=0;
	
	while ((ymargin<520) && ((on_sprite + spcount)<=MAX_SPRITE)) {
	//Draw Big Sprite Block
	for ( x = 1; x <= sprite[ on_sprite + spcount ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite + spcount ].size_y; y++ )
			if ( sprite[ on_sprite + spcount ].p[ x ][ y ] )
				if ((xmargin+x+1<720)&&(ymargin+y+1<520)) {
					al_draw_filled_rectangle( xmargin+x , ymargin+y , xmargin+x+1 , ymargin+y+1 , al_map_rgb(0, 0, 0) );
					cksum++;
				}
	xmargin+= sprite[ on_sprite + spcount ].size_x;
	if (xmargin >=720){
		ymargin+=sprite[ on_sprite + spcount ].size_y;;
		xmargin=0;
	}
	spcount++;
	}

	sprintf( text, "Cksum: %i", cksum );
	al_draw_text(font, al_map_rgb(0,5,10), 8, 485, ALLEGRO_ALIGN_LEFT, text);

	al_flip_display();

	do {
	al_get_keyboard_state(&pressed_keys);
	}	while (al_key_down(&pressed_keys, ALLEGRO_KEY_F12 ));

}

void do_gui_buttons()
{
	al_get_mouse_state(&moustate);
	//Last Sprite
	if ( button_pressed( 101, 465, 50, 39 ) )
		if ( on_sprite > 0 )
		{
			on_sprite--;
			update_screen();
		}

	//Next Sprite
	if ( button_pressed( 151, 465, 50, 39 ) )
		if ( on_sprite < MAX_SPRITE )
		{
			on_sprite++;
			update_screen();
		}

	//Width -1
	if ( button_pressed( 301, 465, 50, 39 ) )
		if ( sprite[ on_sprite ].size_x > 1 )
		{
			sprite[ on_sprite ].size_x--;
			update_screen();
		}

	//Width +1
	if ( button_pressed( 351, 465, 50, 39 ) )
		if ( sprite[ on_sprite ].size_x < MAX_SIZE_X )
		{
			sprite[ on_sprite ].size_x++;
			update_screen();
		}


	//Height -1
	if ( button_pressed( 501, 465, 50, 39 ) )
		if ( sprite[ on_sprite ].size_y > 1 )
		{
			sprite[ on_sprite ].size_y--;
			update_screen();
		}

	//Height +1
	if ( button_pressed( 551, 465, 50, 39 ) )
		if ( sprite[ on_sprite ].size_y < MAX_SIZE_Y )
		{
			sprite[ on_sprite ].size_y++;
			update_screen();
		}

}

void do_keyboard_input(int keycode)
{
	//Keyboard Input
	if ( keycode == ALLEGRO_KEY_ESCAPE ) {
		exit_requested=1;
		wkey_release(ALLEGRO_KEY_ESCAPE);
		update_screen();
	}

	if ( keycode == ALLEGRO_KEY_F1 ) {
		do_help_page();
		update_screen();
	}

	if ( keycode == ALLEGRO_KEY_F12 ) {
		do_preview_page();
		update_screen();
	}

	if ( keycode == ALLEGRO_KEY_I ) {
		invert_sprite();
	}

	if ( keycode ==  ALLEGRO_KEY_D ) {
		flip_sprite_d();
	}

	if ( keycode ==  ALLEGRO_KEY_5 ) {
		reduce_sprite();
	}

	if ( keycode == ALLEGRO_KEY_INSERT ) {
		insert_sprite();
	}

	if ( al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT) && (keycode ==  ALLEGRO_KEY_LEFT ) ) {
		scroll_sprite_left();
	}

	if ( al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT ) && (keycode ==  ALLEGRO_KEY_RIGHT ) ) {
		scroll_sprite_right();
	}

	if ( al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT ) && (keycode ==  ALLEGRO_KEY_UP ) ) {
		scroll_sprite_up();
	}

	if ( al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT ) && (keycode ==  ALLEGRO_KEY_DOWN ) ) {
		scroll_sprite_down();
	}

	if ( !al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT) && (keycode ==  ALLEGRO_KEY_UP ) && (bls < 64 ) )
	{
		bls++;
		update_screen();
	}

	if ( !al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT) && (keycode ==  ALLEGRO_KEY_DOWN ) && (bls > 1) )
	{
		bls--;
		update_screen();
	}

	//Copy/Paste
	if ( keycode ==  ALLEGRO_KEY_C )
		copied = on_sprite;
	if ( al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT ) ) {
	    if ( keycode ==  ALLEGRO_KEY_P ) {
	        if (copied < on_sprite) {
	        	chop_sprite( copied );
	        }
		}
		if ( keycode ==  ALLEGRO_KEY_DELETE )
			remove_sprite();
		if ( keycode == ALLEGRO_KEY_H )
			double_sprite_h();
		if ( keycode ==  ALLEGRO_KEY_V )
			double_sprite_v();
	} else {
		if ( keycode ==  ALLEGRO_KEY_DELETE )
	        clear_sprite();
		if ( keycode ==  ALLEGRO_KEY_P )
	        if (copied != on_sprite) copy_sprite( copied, on_sprite );
		if ( keycode == ALLEGRO_KEY_H )
			flip_sprite_h();
		if ( keycode ==  ALLEGRO_KEY_V )
			flip_sprite_v();
	}


	//Paste copied sprite's mask
	if ( keycode ==  ALLEGRO_KEY_M )
		if (copied != on_sprite) copy_sprite_mask( copied, on_sprite );

	if ( al_key_down(&pressed_keys, ALLEGRO_KEY_LSHIFT) && (keycode ==  ALLEGRO_KEY_F ) ) {
		fit_sprite_borders();
	} else if ( keycode ==  ALLEGRO_KEY_F )
	{
		fit_sprite_on_screen();
		update_screen();
	}

	// Save / Load / Generate Code
	if ( keycode ==  ALLEGRO_KEY_F2 ) {
		clean_sprites();
		do_save_sprites();
	}
	else if ( keycode ==  ALLEGRO_KEY_F3 )
		do_load_sprites();
	else if ( keycode ==  ALLEGRO_KEY_F4 )
		do_load_sevenup();
	else if ( keycode ==  ALLEGRO_KEY_F5 )
		do_save_code(1);
	else if ( keycode ==  ALLEGRO_KEY_F7 )
		do_save_code(0);
	else if ( keycode ==  ALLEGRO_KEY_F6 )
		do_merge_sprites();
	else if ( keycode ==  ALLEGRO_KEY_L )
		do_import_bitmap();
#ifdef GIF_SUPPORT
	else if ( keycode ==  ALLEGRO_KEY_G )
		do_import_gif();
#endif
	else if ( keycode ==  ALLEGRO_KEY_O )
		do_import_geos();
	else if ( keycode ==  ALLEGRO_KEY_N )
		do_import_printmaster();

}

void do_sprite_drawing()
{
	int d;
	//Get the mouse's position over top of sprite
	do_mouse_stuff();

	//Draw on sprite if mouse is over the sprite feild
	al_get_mouse_state(&moustate);
	if ( ( moustate.buttons & 1 ) && (moustate.x > bls ) && (moustate.y > bls ) && (moustate.x < (sprite[ on_sprite ].size_x * bls) + bls) && (moustate.y < (sprite[ on_sprite ].size_y * bls) + bls) )
	{
		//If the player has clicked then select oposing colour of pixel that mouse is over
		d = !sprite[ on_sprite ].p[ mx ][ my ];
		//Continuousely draw pixel of previousely determined colour under mouse until mouse is unlclicked
		while ( moustate.buttons & 1 )
		{
			do_mouse_stuff();
			sprite[ on_sprite ].p[ mx ][ my ] = d;
			update_screen();
		}
	}
}


//**************************************************************************
//                                     MAIN                                *
//**************************************************************************
//public int main(int argc, char** argv)

//int main( int argc, char *argv[] )
int main()
{
	//Init system
	al_init();
	al_init_primitives_addon();
	al_init_font_addon();

	al_init_image_addon();
	al_init_native_dialog_addon();
	al_install_keyboard();
	al_install_mouse();

	font = al_load_font("fixed_font.tga", 0, 0);
	exit_requested=0;

	//Setup graphics

	al_set_new_display_flags(ALLEGRO_WINDOWED);
	al_set_new_window_position(50, 50);
	display = al_create_display(720, 520);
	if ( display == NULL )
		exit( -1 );

	al_set_window_title(display, "z88dk Sprite Editor");

	//Setup double buffer
	screen = al_create_bitmap( 720, 520 );
	al_set_target_bitmap(screen);
	al_set_target_backbuffer(display);
	//screen = al_get_target_bitmap();


	eventQueue = al_create_event_queue();
	al_register_event_source(eventQueue, al_get_display_event_source(display));
	al_register_event_source(eventQueue, al_get_keyboard_event_source());
	al_register_event_source(eventQueue, al_get_mouse_event_source());

	//Transparent background for text
//	text_mode( -1 );

	//Reset all sprite sizes
	reset_sprites();
	on_sprite = 0;				//Choose Sprite 0
	copied = 0;
	fit_sprite_on_screen();


	//------Main Program Loop----------
	update_screen();
	al_show_native_message_box(display, "Welcome", "Welcome to the z88dk Sprite Editor", "Keep 'F1' pressed to see the help page, 'F12' for a quick preview.", NULL, 0);
	al_flush_event_queue(eventQueue);
	
	while (!exit_requested) {

		al_flip_display();
		al_wait_for_event(eventQueue, &e);
		al_get_keyboard_state(&pressed_keys);
		
		if (e.type == ALLEGRO_EVENT_DISPLAY_CLOSE)
			exit_requested=1;

		// Repaint window if the display was suspended or locked
		if (e.type == ALLEGRO_EVENT_DISPLAY_FOUND)
			update_screen();

		if ((e.type == ALLEGRO_EVENT_MOUSE_AXES)||(e.type == ALLEGRO_EVENT_MOUSE_BUTTON_DOWN)) {
			do_gui_buttons();
			do_sprite_drawing();
		}

		if (e.type == ALLEGRO_EVENT_KEY_DOWN)
			do_keyboard_input(e.keyboard.keycode);

		al_flush_event_queue(eventQueue);
		//al_wait_for_event(eventQueue, &e);
		
		if (exit_requested)
			if (al_show_native_message_box(display, "Goodbye", "Exiting..", "Are you sure ?", NULL, ALLEGRO_MESSAGEBOX_YES_NO)!=1)
				exit_requested=0;
	}

	al_unregister_event_source(eventQueue, al_get_mouse_event_source());
	al_unregister_event_source(eventQueue, al_get_keyboard_event_source());
	al_unregister_event_source(eventQueue, al_get_display_event_source(display));
	al_destroy_event_queue(eventQueue);

	al_uninstall_keyboard();
	al_uninstall_mouse();
	al_destroy_bitmap(screen);
	al_destroy_display(display);
	return (0);
	
}

