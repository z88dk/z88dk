/*
	$Id: sprite.c,v 1.2 2007-02-17 16:41:45 stefano Exp $
	
	A program to import / make sprites for use with z88dk
	by Daniel McKinnon
	slightly improved by Stefano Bodrato

	Please send Daniel McKinnon your own updates to the code,
	it can be anything!  Comments, GUI elements, Bug-Fixes,
	Features, ports, etc.

	Send any updates, fixes, or support requests to:  stikmansoftware@yahoo.com
	...and signal changes to the z88dk_devel list, too.

	P.S. Some of the comments are a little dodgy and could use some fixing up
*/

//#include <allegro.h>
//#include <winalleg.h>
#include "allegro.h"

#include <stdio.h>

#define MAX_SIZE_X		255
#define MAX_SIZE_Y		255

#define MAX_SPRITE		150

#define DEFAULT_BLOCK_SIZE		32
#define DEFAULT_SIZE_X			8
#define DEFAULT_SIZE_Y			8



BITMAP *buffer;
int bls;

typedef struct spritetype
{
	int size_x, size_y;
	int p[ MAX_SIZE_X ][ MAX_SIZE_Y ];
} spritetype;

int on_sprite;
int copied;			//Sprite selected as source for copying
int num_sprites;
spritetype sprite[ MAX_SPRITE + 1 ];

char hexcode[ MAX_SIZE_X * MAX_SIZE_Y ];		//Generated C Code (called hexcode out of laziness)
char *hexc = "0123456789ABCDEF";					//For converting integers (0-15) to Hex

//Draws a button at (x, y) with width/height (w, h), displaying text *text, with colour
void draw_button( int x, int y, int w, int h, char *text, int border_c, int fill_c, int text_c  )
{
	rect( buffer, x, y, x+w, y+h, border_c );			//Boder
	rectfill( buffer, x+1, y+1, x+w-1, y+h-1,  fill_c );		//Fill
	textout_centre( buffer, font, text, x+(w/2), y+(h/2) - 4, text_c ); //Text
}

//Checks wheather mouse has been clicked within certain "button" boundries
int button_pressed( int x, int y, int w, int h )
{
	if (  (mouse_x > x) && (mouse_x < (x+w) )
	   && (mouse_y > y) && (mouse_y < (y+w) )
	   && (mouse_b & 1) )
		return 1;
	else
		return 0;
}


//Updates all graphics on screen
void update_screen()
{
	int x, y;

	int c1, c2, c3;
	char text[ 100 ];

		show_mouse( buffer );
	clear_to_color( buffer, makecol(210,240,210) );


	//Draw Big Sprite Block
	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
			if ( sprite[ on_sprite ].p[ x ][ y ] )
				rectfill( buffer, x * bls, y * bls, (x * bls) + bls, (y * bls) + bls, 0 );
	//Draw Border Around Sprite Block
	rect( buffer, bls - 1, bls - 1, (sprite[ on_sprite ].size_x * bls) + bls + 1, (sprite[ on_sprite ].size_y * bls) + bls + 1, makecol(255,0,0)  );


	c1 = 0;
	c2 = makecol( 200, 255, 200 );
	c3 = 0;
	sprintf( text, "Sprite %i", on_sprite );
	draw_button( 20, 435, 80, 23, text, c1, c2, c3 );

	sprintf( text, "Width :%i", sprite[ on_sprite ].size_x );
	draw_button( 220, 435, 80, 23, text, c1, c2, c3 );

	sprintf( text, "Height: %i", sprite[ on_sprite ].size_y );
	draw_button( 420, 435, 80, 23, text, c1, c2, c3 );

	c1 = makecol( 255,255,0 );
	c2 = makecol( 200, 100, 75 );
	c3 = makecol( 255,255,255 );
	draw_button( 101, 435, 50, 23, "Last", c1, c2, c3 );
	draw_button( 151, 435, 50, 23, "Next", c1, c2, c3 );

	draw_button( 301, 435, 50, 23, "-1", c1, c2, c3 );
	draw_button( 351, 435, 50, 23, "+1", c1, c2, c3 );

	draw_button( 501, 435, 50, 23, "-1", c1, c2, c3 );
	draw_button( 551, 435, 50, 23, "+1", c1, c2, c3 );


	blit( buffer, screen, 0, 0, 0, 0, 640, 480 );


	show_mouse( screen );

}

//The block that the mouse is over top of
int mx, my;

//Calculate which block the mouse is over top of
void do_mouse_stuff()
{
	mx = ( mouse_x / bls );
	my = ( mouse_y / bls );
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

	sprintf( hexcode, "" );

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

//Fits a sprite to best fit on the screen
void fit_sprite_on_screen()
{
	//Calculate size of best fit
	if ( sprite[ on_sprite ].size_x > sprite[ on_sprite ].size_y )
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
		//update_screen();
	    }
	    y_offset = y_offset + save_y;
	}
	update_screen();
}


void import_from_bitmap( char *file )
{
	BITMAP *temp;
	int x, y;

	temp = load_bitmap( file, 0 );

	sprite[ on_sprite ].size_x = temp->w;
	sprite[ on_sprite ].size_y = temp->h;
	if ( sprite[ on_sprite ].size_x > MAX_SIZE_X )
		sprite[ on_sprite ].size_x = MAX_SIZE_X;
	if ( sprite[ on_sprite ].size_y > MAX_SIZE_Y )
		sprite[ on_sprite ].size_y = MAX_SIZE_Y;

	fit_sprite_on_screen();
	for ( x = 1; x <= sprite[ on_sprite ].size_x; x++ )
		for ( y = 1; y <= sprite[ on_sprite ].size_y; y++ )
			sprite[ on_sprite ].p[ x ][ y ] = !(getpixel( temp, x - 1, y - 1 ) >= 1 );

	update_screen();
}

void do_import_bitmap()
{
	char file[ 255 ];

	sprintf( file, "./" );
	if ( file_select_ex( "Import From Bitmap", file, "BMP;PCX", 255, 640, 480 ) )
		import_from_bitmap( file );
}



//Saves a header file with sprites 0-on_sprite for use with z88dk
void save_code_file( char *file )
{
	FILE *f;
	int i;

	f = fopen( file, "w" );

	fputs( "// Generated by Daniel McKinnon's z88dk Sprite Editor\n", f );
	for ( i = 0; i <= on_sprite; i++ )
	{
		generate_codes( i );
		fputs( hexcode, f );
	}

	fclose( f );

}



void save_sprite_file( char *file )
{
	PACKFILE *f;

	f = pack_fopen( file, "pw+b" );
	pack_fwrite( sprite, sizeof( sprite ), f );
	pack_fclose( f );
}

void load_sprite_file( char *file )
{
	PACKFILE *f;

	if ( exists( file ) )
	{
		f = pack_fopen( file, "pr+b" );
		pack_fread( &sprite, sizeof( sprite ), f );
		pack_fclose( f );
	}

	update_screen();
}



//The file selector for saving code files
void do_save_code()
{
	char file[ 255 ];
	if ( file_select_ex( "Save To...", file, "h", 255, 640, 480 ) )
		save_code_file( file );

}

//The file selector for saving sprite files
void do_save_sprites()
{
	char file[ 255 ];

	if ( file_select_ex( "Save To...", file, "csp", 255, 640, 480 ) )
		save_sprite_file( file );
}

//The file selector for loading sprite files
void do_load_sprites()
{
	char file[ 255 ];

	if ( file_select_ex( "Load File", file, "csp", 255, 640, 480 ) )
		load_sprite_file( file );
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

	/*  
	//dst initialization shouldn't be necessary 
	for ( x = 1; x <= sprite[ dest ].size_x; x++ )
		for ( y = 1; y <= sprite[ dest ].size_y; y++ )
			sprite[ dest ].p[ x ][ y ] = FALSE;
	*/

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


void do_gui_buttons()
{
	//Last Sprite
	if ( button_pressed( 101, 435, 50, 23 ) )
		if ( on_sprite > 0 )
		{
			on_sprite--;
			update_screen();
			while (mouse_b & 1);
		}

	//Next Sprite
	if ( button_pressed( 151, 435, 50, 23 ) )
		if ( on_sprite < MAX_SPRITE )
		{
			on_sprite++;
			update_screen();
			while (mouse_b & 1);
		}

	//Width -1
	if ( button_pressed( 301, 435, 50, 23 ) )
		if ( sprite[ on_sprite ].size_x > 1 )
		{
			sprite[ on_sprite ].size_x--;
			update_screen();
			while (mouse_b & 1);
		}

	//Width +1
	if ( button_pressed( 351, 435, 50, 23 ) )
		if ( sprite[ on_sprite ].size_x < MAX_SIZE_X )
		{
			sprite[ on_sprite ].size_x++;
			update_screen();
			while (mouse_b & 1);
		}


	//Height -1
	if ( button_pressed( 501, 435, 50, 23 ) )
		if ( sprite[ on_sprite ].size_y > 1 )
		{
			sprite[ on_sprite ].size_y--;
			update_screen();
			while (mouse_b & 1);
		}

	//Height +1
	if ( button_pressed( 551, 435, 50, 23 ) )
		if ( sprite[ on_sprite ].size_y < MAX_SIZE_Y )
		{
			sprite[ on_sprite ].size_y++;
			update_screen();
			while (mouse_b & 1);
		}

}


void do_keyboard_input()
{
	//Keyboard Input
	if ( key[ KEY_L ] )
		do_import_bitmap();

	if ( key[ KEY_I ] ) {
		invert_sprite();
		while ( key[ KEY_I ] );
	}

	if ( key[ KEY_H ] ) {
		flip_sprite_h();
		while ( key[ KEY_H ] );
	}

	if ( key[ KEY_V ] ) {
		flip_sprite_v();
		while ( key[ KEY_V ] );
	}

	if ( key[ KEY_D ] ) {
		flip_sprite_d();
		while ( key[ KEY_D ] );
	}

	if ( key[ KEY_LSHIFT ] && key[ KEY_LEFT ] ) {
		scroll_sprite_left();
		while ( key[ KEY_LEFT ] );
	}

	if ( key[ KEY_LSHIFT ] && key[ KEY_RIGHT ] ) {
		scroll_sprite_right();
		while ( key[ KEY_RIGHT ] );
	}

	if ( key[ KEY_LSHIFT ] && key[ KEY_UP ] ) {
		scroll_sprite_up();
		while ( key[ KEY_UP ] );
	}

	if ( key[ KEY_LSHIFT ] && key[ KEY_DOWN ] ) {
		scroll_sprite_down();
		while ( key[ KEY_DOWN ] );
	}

	if ( key[ KEY_UP ] && (bls < 64 ) )
	{
		bls++;
		update_screen();
		while ( key[ KEY_UP ] );
	}

	if ( key[ KEY_DOWN ] && (bls > 1) )
	{
		bls--;
		update_screen();
		while ( key[ KEY_DOWN ] );
	}

	//Copy/Paste
	if ( key[ KEY_C ] )
		copied = on_sprite;
	if ( key[ KEY_LSHIFT ] ) {
	    if ( key[ KEY_P ] )
	        if (copied < on_sprite) {
	        	chop_sprite( copied );
	        	while ( key[ KEY_P ] );
	        }
	}
	else {
	    if ( key[ KEY_P ] )
	        if (copied != on_sprite) copy_sprite( copied, on_sprite );
	}
	//Paste copied sprite's mask
	if ( key[ KEY_M ] )
		if (copied != on_sprite) copy_sprite_mask( copied, on_sprite );
		while ( key[ KEY_M ] );


	// Save / Load / Generate Code
	if ( key[ KEY_F2 ] )
		do_save_sprites();
	if ( key[ KEY_F3 ] )
		do_load_sprites();
	if ( key[ KEY_F5 ] )
		do_save_code();


	if ( key[ KEY_F ] )
	{
		fit_sprite_on_screen();
		update_screen();
	}
}

void do_sprite_drawing()
{
	int d;
	//Get the mouse's position over top of sprite
	do_mouse_stuff();

	//Draw on sprite if mouse is over the sprite feild
	if ( ( mouse_b & 1 ) && (mouse_x > bls ) && (mouse_y > bls ) && (mouse_x < (sprite[ on_sprite ].size_x * bls) + bls) && (mouse_y < (sprite[ on_sprite ].size_y * bls) + bls) )
	{
		//If the player has clicked then select oposing colour of pixel that mouse is over
		d = !sprite[ on_sprite ].p[ mx ][ my ];
		//Continuousely draw pixel of previousely determined colour under mouse until mouse is unlclicked
		while ( mouse_b & 1 )
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
int main( int argc, char *argv[] )
{

	//Init system
	allegro_init();
	install_keyboard();
	install_timer();
	install_mouse();

	//Setup graphics
	set_color_depth( 16 );
	//if ( set_gfx_mode(GFX_XWINDOWS, 640, 480, 0, 0 ) < 0 )
	if ( set_gfx_mode(GFX_AUTODETECT_WINDOWED, 640, 480, 0, 0 ) < 0 )
		exit( -1 );

	//Setup double buffer
	buffer = create_bitmap( 640, 480 );
	if ( buffer == NULL )
		exit( -1 );

	//Transparent background for text
	text_mode( -1 );

	//Reset all sprite sizes
	reset_sprites();
	on_sprite = 0;				//Choose Sprite 0
	copied = 0;
	fit_sprite_on_screen();



	//------Main Program Loop----------
	update_screen();

	while ( !key[ KEY_ESC ] )
	{

		do_gui_buttons();
		do_sprite_drawing();
		do_keyboard_input();

	}


	return 0;
} END_OF_MAIN();


