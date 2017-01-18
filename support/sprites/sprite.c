/*
	$Id: sprite.c,v 1.16 2015-03-25 11:07:37 stefano Exp $

	A program to import / make sprites for use with z88dk
	by Daniel McKinnon
	slightly improved and ported to Allegro 5 by Stefano Bodrato

	Please send Daniel McKinnon your own updates to the code,
	it can be anything!  Comments, GUI elements, Bug-Fixes,
	Features, ports, etc.

	Send any updates, fixes, or support requests to:  stikmansoftware@yahoo.com
	...and signal changes to the z88dk_devel list, too.

*/


#include <allegro5/allegro.h>
#include <allegro5/drawing.h>
#include <allegro5/allegro_primitives.h>
#include <allegro5/allegro_native_dialog.h>
#include <allegro5/allegro_font.h>
#include <zlib.h>
#include "allegro5/allegro_image.h"


#include <stdio.h>


#define MAX_SIZE_X		255
#define MAX_SIZE_Y		255

#define MAX_SPRITE		150

#define DEFAULT_SIZE_X			16
#define DEFAULT_SIZE_Y			16


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
	al_draw_rectangle( x, y, x+w, y+h, border_c, 1.6 );			//Boder
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


void generate_codes( int i )
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
	sprintf( hexcode, "char sprite%i[] = { %i, %i", i, sprite[ i ].size_x, sprite[ i ].size_y );
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
	sprintf( hexcode, "%s };\n", hexcode );

}

// Resize the sprite view to best fit on the screen
void fit_sprite_on_screen()
{
	//Calculate size of best fit
	if ( (sprite[ on_sprite ].size_x/2) > sprite[ on_sprite ].size_y )
		bls = (int)(600 / (sprite[ on_sprite ].size_x + 10));
	else
		bls = (int)(440 / (sprite[ on_sprite ].size_y + 10));
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
	for ( x = 1; x < sprite[ on_sprite ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x + 1 ][ y ];
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
	for ( y = 1; y < sprite[ on_sprite ].size_y; y++ )
		for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
			sprite[ on_sprite ].p[ x ][ y ] = sprite[ on_sprite ].p[ x ][ y + 1 ];
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


//chop sprite in smaller items
void chop_sprite( int src )
{
	int x, y, x_offset, y_offset;
	int save_x, save_y;
	
	//save destination sprites' dims
	save_x = sprite[ on_sprite ].size_x;
	save_y = sprite[ on_sprite ].size_y;

	y_offset = 0;
	while ( sprite[ src ].size_y > y_offset) {
	    x_offset = 0;
	    while ( sprite[ src ].size_x > x_offset) {	
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


void import_from_bitmap( const char *file )
{
	ALLEGRO_BITMAP *temp = NULL;
	FILE *fpin = NULL;
	long len;
	int x, y, i, j;
	unsigned char r = 0;
	unsigned char g = 0;
	unsigned char b = 0;
	
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
				sprite[ on_sprite ].p[ x ][ y ] = ( (r+g+b) < 300 );
			}
	} else {
		fpin = fopen( file, "rb" );
		if (!fpin)
			return;
		if	(fseek(fpin,0,SEEK_END))
			return;
		len=ftell(fpin);
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
	fit_sprite_on_screen();
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

	fit_sprite_on_screen();
	update_screen();
}

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
void save_code_file( const char *file )
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
		generate_codes( i );
		al_fputs( f, hexcode );
	}

	al_fclose( f );

}



void save_sprite_file( const char *file )
{
	gzFile *f = NULL;
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
	gzFile *f = NULL;
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
			}
	}

	gzclose( f );

	fit_sprite_on_screen();
	update_screen();
}


void merge_sprite_file( const char *file )
{
	gzFile *f = NULL;
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

	fit_sprite_on_screen();
	update_screen();
}


//The file selector for saving code files
void do_save_code()
{
	const char *file = NULL;

	path=NULL;
	file_dialog_sv = al_create_native_file_dialog("./", "Generate C header for sprites", sprHeader, ALLEGRO_FILECHOOSER_SAVE);
	al_show_native_file_dialog(display, file_dialog_sv);
	path = al_create_path(al_get_native_file_dialog_path(file_dialog_sv, 0));
	al_set_path_extension(path, ".h");
	al_destroy_native_file_dialog(file_dialog_sv);
	file = al_path_cstr(path, ALLEGRO_NATIVE_PATH_SEP);

	save_code_file( file );
	al_destroy_path(path);

	wkey_release(ALLEGRO_KEY_F5);
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
	al_draw_text(font, al_map_rgb(0,5,10), 8, 30, ALLEGRO_ALIGN_LEFT, "Up / Down.............Zoom In / Out");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 50, ALLEGRO_ALIGN_LEFT, "SHIFT + arrow keys....Scroll Sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 70, ALLEGRO_ALIGN_LEFT, "H/V/D..................Flip sprite horizontally/vertically/diagonally");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 90, ALLEGRO_ALIGN_LEFT, "SHIFT + DEL............Remove sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 110, ALLEGRO_ALIGN_LEFT, "INS / DEL..............Insert/Clear a sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 130, ALLEGRO_ALIGN_LEFT, "I......................Invert Sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 150, ALLEGRO_ALIGN_LEFT, "SHIFT + H/V............Double Width/Height");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 170, ALLEGRO_ALIGN_LEFT, "C/P....................Copy/Paste sprite");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 190, ALLEGRO_ALIGN_LEFT, "5......................Reduce sprite size at 50%");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 210, ALLEGRO_ALIGN_LEFT, "F......................Fit the zoom settings for the current sprite size");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 230, ALLEGRO_ALIGN_LEFT, "SHIFP + P.......Split the copied sprite into pieces as big as the current ");
	al_draw_text(font, al_map_rgb(0,5,10), 140, 250, ALLEGRO_ALIGN_LEFT, "sprite and paste them starting from the current sprite position.");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 270, ALLEGRO_ALIGN_LEFT, "M......................Compute mask for copied sprite and paste to current sprite");
	al_draw_text(font, al_map_rgb(20,5,10), 8, 300, ALLEGRO_ALIGN_LEFT, "Saving / Loading");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 325, ALLEGRO_ALIGN_LEFT, "F2.....................Saves all sprites (editor specific format)");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 345, ALLEGRO_ALIGN_LEFT, "F3/F6..................Load/Merge sprites (editor format), merge over current pos.");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 365, ALLEGRO_ALIGN_LEFT, "F4.....................Load SevenuP sprite at current position");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 385, ALLEGRO_ALIGN_LEFT, "L......................Import picture (BMP,GIF,JPG,LBM,PCX,PNG,SCR,SNA,TGA...)");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 405, ALLEGRO_ALIGN_LEFT, "N......................Import pictures from a Printmaster/Newsmaster (MSDOS) lib.");
	al_draw_text(font, al_map_rgb(0,5,10), 8, 425, ALLEGRO_ALIGN_LEFT, "F5.....................Generate a C language header definition for");
	al_draw_text(font, al_map_rgb(0,5,10), 190, 445, ALLEGRO_ALIGN_LEFT, "all the sprites up to the current one");

	al_flip_display();

	do {
	al_get_keyboard_state(&pressed_keys);
	}	while (al_key_down(&pressed_keys, ALLEGRO_KEY_F1 ));

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

	if ( keycode ==  ALLEGRO_KEY_F )
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
		do_save_code();
	else if ( keycode ==  ALLEGRO_KEY_F6 )
		do_merge_sprites();
	else if ( keycode ==  ALLEGRO_KEY_L )
		do_import_bitmap();
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
	al_show_native_message_box(display, "Welcome", "Welcome to the z88dk Sprite Editor", "Keep 'F1' pressed to see the help page", NULL, 0);
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

