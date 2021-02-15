
/*

        Collider, a multi platform game skeleton written for Z88DK
        By Stefano Bodrato, 2019
		
		This example uses the traditional way of comparing actual coordinates to detect collisions and walls.
		See the commented code and microman.c for a different approach.


        How to compile
        ==============
        
        zcc +<target> -lndos -create-app -ocollider -DSOUND -DJOYSTICK_DIALOG collider.c
		
		(-DSOUND and -DJOYSTICK_DIALOG can be removed where not applicable)

*/



#include <graphics.h>
#include <games.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef SOUND
#include <sound.h>
#endif

#define VERTICAL   1
#define HORIZONTAL 0

char corners[] = {
	MOVE_UP,    20, 20, MOVE_RIGHT, 20, 20,
	MOVE_UP,    11, 11, MOVE_RIGHT, 11, 11,
	MOVE_UP,     2,  2, MOVE_RIGHT,  2,  2,
	MOVE_UP,    70, 20, MOVE_LEFT,  68, 20,
	MOVE_UP,    79, 11, MOVE_LEFT,  77, 11,
	MOVE_UP,    88,  2, MOVE_LEFT,  86,  2,
	MOVE_DOWN,  20, 36, MOVE_RIGHT, 20, 38,
	MOVE_DOWN,  11, 45, MOVE_RIGHT, 11, 47,
	MOVE_DOWN,   2, 54, MOVE_RIGHT,  2, 56,
	MOVE_DOWN,  70, 36, MOVE_LEFT,  68, 38,
	MOVE_DOWN,  79, 45, MOVE_LEFT,  77, 47,
	MOVE_DOWN,  88, 54, MOVE_LEFT,  86, 56,
	MOVE_LEFT,   2,  2, MOVE_DOWN,   2,  2,
	MOVE_LEFT,  11, 11, MOVE_DOWN,  11, 11,
	MOVE_LEFT,  20, 20, MOVE_DOWN,  20, 20,
	MOVE_LEFT,  20, 38, MOVE_UP,    20, 36,
	MOVE_LEFT,  11, 47, MOVE_UP,    11, 45,
	MOVE_LEFT,   2, 56, MOVE_UP,     2, 54,
	MOVE_RIGHT, 86,  2, MOVE_DOWN,  88,  2,
	MOVE_RIGHT, 77, 11, MOVE_DOWN,  79, 11,
	MOVE_RIGHT, 68, 20, MOVE_DOWN,  70, 20,
	MOVE_RIGHT, 68, 38, MOVE_UP,    70, 36,
	MOVE_RIGHT, 77, 47, MOVE_UP,    79, 45,
	MOVE_RIGHT, 86, 56, MOVE_UP,    88, 54
};


char deviations[] = {
	MOVE_DOWN, 38,2, 0,9,
	MOVE_DOWN, 51,2, 0,9,
	MOVE_DOWN, 38,11, 0,9,
	MOVE_DOWN, 51,11, 0,9,

	MOVE_UP, 38,20, 0,-9,
	MOVE_UP, 51,20, 0,-9,
	MOVE_UP, 38,11, 0,-9,
	MOVE_UP, 51,11, 0,-9,

	MOVE_DOWN, 38,38, 0,9,
	MOVE_DOWN, 51,38, 0,9,
	MOVE_DOWN, 38,47, 0,9,
	MOVE_DOWN, 51,47, 0,9,

	MOVE_UP, 38,47, 0,-9,
	MOVE_UP, 51,47, 0,-9,
	MOVE_UP, 38,56, 0,-9,
	MOVE_UP, 51,56, 0,-9,

	MOVE_RIGHT, 2,22, 9,0,
	MOVE_RIGHT, 2,35, 9,0,
	MOVE_RIGHT, 11,22, 9,0,
	MOVE_RIGHT, 11,35, 9,0,

	MOVE_LEFT, 20,22, -9,0,
	MOVE_LEFT, 20,35, -9,0,
	MOVE_LEFT, 11,22, -9,0,
	MOVE_LEFT, 11,35, -9,0,

	MOVE_RIGHT, 70,22, 9,0,
	MOVE_RIGHT, 70,35, 9,0,
	MOVE_RIGHT, 79,22, 9,0,
	MOVE_RIGHT, 79,35, 9,0,

	MOVE_LEFT, 79,22, -9,0,
	MOVE_LEFT, 79,35, -9,0,
	MOVE_LEFT, 88,22, -9,0,
	MOVE_LEFT, 88,35, -9,0,
};


char car_up[] = 
	{ 6,8,
	  '\x30','\xb4','\xfc','\xb4',
	  '\x30','\xb4','\xfc','\xb4' };
	  
char car_down[] = 
	{ 6,8,
	  '\xb4','\xfc','\xb4','\x30',
	  '\xb4','\xfc','\xb4','\x30' };

char car_left[] = 
	{ 8,6,
	  '\x77','\x22','\xff',
	  '\xff','\x22','\x77' };

char car_right[] = 
	{ 8,6,
	  '\xee','\x44','\xff',
	  '\xff','\x44','\xee' };

char explosion[] = { 
		7, 7, 0x00 , 0x00 , 0x00 , 0x30 , 0x20 , 0x00 , 0x00,
		7, 7, 0x00 , 0x00 , 0x48 , 0x20 , 0x50 , 0x00 , 0x00,
		7, 7, 0x00 , 0x48 , 0x5C , 0xB8 , 0x58 , 0x20 , 0x00,
		7, 7, 0x08 , 0x12 , 0xA8 , 0x52 , 0xE8 , 0x5A , 0x2C,};

char blank[] = {4,5,0xf0,0xf0,0xf0,0xf0,0xf0};

char numbers[] = { 
        4,5,
        0x70,0x90,0,0x90,0xE0,
        4,5,
        0x20,0x20,0,0x40,0x40,
        4,5,
        0x70,0x10,0x60,0x80,0xE0,
        4,5,
        0x70,0x10,0x60,0x10,0xE0,
        4,5,
        0x90,0x90,0x60,0x10,0x10,
        4,5,
        0x70,0x80,0x60,0x10,0xE0,
        4,5,
        0x70,0x80,0x60,0x90,0xE0,
        4,5,
        0x70,0x90,0,0x20,0x20,
        4,5,
        0x70,0x90,0x60,0x90,0xE0,
        4,5,
        0x70,0x90,0x60,0x10,0xE0
};

char logo[] = { 54, 14, 
  0x00 , 0x00 , 0x00 , 0x00 , 0x70 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 
, 0x8C , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x83 , 0x00 , 0xF8 , 0x00 
, 0x00 , 0x00 , 0x07 , 0x80 , 0xC1 , 0x04 , 0x00 , 0x00 , 0x00 , 0x08 , 0x80 
, 0x30 , 0x84 , 0x00 , 0x01 , 0xFF , 0x91 , 0xC0 , 0x0C , 0x84 , 0x07 , 0xDE 
, 0x00 , 0x66 , 0x38 , 0x03 , 0xC4 , 0x78 , 0x3F , 0x20 , 0x38 , 0x07 , 0x87 
, 0xE4 , 0x80 , 0x73 , 0x98 , 0x15 , 0x54 , 0x7E , 0x74 , 0xFE , 0x6D , 0x86 
, 0x20 , 0x00 , 0x0D , 0xB8 , 0x15 , 0xED , 0x81 , 0x20 , 0x00 , 0x0D , 0xB0 
, 0x3F , 0x73 , 0x80 , 0xA0 , 0x00 , 0x0E , 0x70 , 0x40 , 0xBF , 0x7F , 0x5F 
, 0xFF , 0xF7 , 0xE0 , 0x7F , 0x9E , 0x00 , 0x00 , 0x00 , 0x03 , 0xC0  };


struct player {
        char    x;
        char    y;
        char    oldx;
        char    oldy;
        char    direction;
        int     score;
        void	*sprite;
        void	*oldsprite;
};

char scoretxt[7];
  int x,y,b,c;
  int stick;
  int score;

show_score (int sc)
{
    sprintf (scoretxt,"%06u",sc);
    for (x=0; x<6; x++) {
      putsprite (spr_and, 34+5*x, 29, blank);
      putsprite (spr_or, 34+5*x, 29, &numbers[(scoretxt[x]-48)*7]);
    }
}


draw_board ()
{

	clg();
	
	// Screen border

	draw(0,0,95,0);
	draw(0,0,0,63);
	draw(95,0,95,63);
	draw(0,63,95,63);

	// Central box

	draw(27,27,68,27);
	draw(27,27,27,36);
	draw(27,36,68,36);
	draw(68,27,68,36);

	// Horz. mid borders

	draw(9,9,38,9);
	draw(58,9,86,9);
	
	draw(18,18,38,18);
	draw(58,18,77,18);

	draw(18,45,38,45);
	draw(58,45,77,45);

	draw(9,54,38,54);
	draw(58,54,86,54);

	// Vert. mid borders

	draw(9,9,9,22);
	draw(9,42,9,54);

	draw(18,18,18,22);
	draw(18,42,18,45);
	
	draw(77,18,77,22);
	draw(77,42,77,45);

	draw(86,9,86,22);
	draw(86,42,86,54);

/*
	for (x=0 ; x!=4; x++)
	{
	   for (y=0 ; y!=3; y++)
	   {
	     plot (5+x*9,5+y*9);
	     plot (90-x*9,5+y*9);
	     plot (5+x*9,59-y*9);
	     plot (90-x*9,59-y*9);
	   }
	}
*/

}


draw_sprite(struct player *the_player)
{
	  putsprite(SPR_AND,the_player->oldx,the_player->oldy,the_player->oldsprite);
          putsprite(SPR_OR,the_player->x,the_player->y,the_player->sprite);
}


player_save(struct player *the_player)
{
	  the_player->oldx=the_player->x;
	  the_player->oldy=the_player->y;
	  the_player->oldsprite=the_player->sprite;
}


player_step(struct player *the_player)
{
	
	  switch(the_player->direction)
	  {
		case MOVE_RIGHT:
		  the_player->x++;
		  break;
		case MOVE_UP:
		  the_player->y--;
		  break;
		case MOVE_LEFT:
		  the_player->x--;
		  break;
		case MOVE_DOWN:
		  the_player->y++;
		  break;
	  }
	  
	for (x=0 ; x<=144; x+=6)
	{
	     if ( corners[x]==the_player->direction && 
	          corners[x+1]==the_player->x &&
	          corners[x+2]==the_player->y )
    	     {
		the_player->direction=corners[x+3];
		the_player->x=corners[x+4];
		the_player->y=corners[x+5];
    	     }
	}
	
	switch(the_player->direction)
	{
		case MOVE_RIGHT:
		  the_player->sprite=car_right;
		  break;
		case MOVE_UP:
		  the_player->sprite=car_up;
		  break;
		case MOVE_LEFT:
		  the_player->sprite=car_left;
		  break;
		case MOVE_DOWN:
		  the_player->sprite=car_down;
		  break;
	}
}



main()
{
	struct player player1;
	struct player player2;

	clg();
	
#ifdef SOUND
	bit_open();
#endif
	
 /****  JOYSTICK CHOICE  ****/
#ifdef JOYSTICK_DIALOG

	putsprite(SPR_OR,0,0, logo);
	printf("\n\n");
	
	for (x=0 ; x!=GAME_DEVICES; x++)
	{
		printf("%u - %s\n",x+1,joystick_type[x]);
	}
	
	stick=0;
	while ((stick<1) || (stick>GAME_DEVICES))
		stick=getk()-48;
	
#else
	
	stick=1;
	
#endif


	draw_board ();
	
	player1.x=46;
	player1.oldx=46;
	player1.y=56;
	player1.oldy=46;
	player1.direction=MOVE_RIGHT;
	player1.score=0;
	player1.sprite=car_right;
	player1.oldsprite=car_right;

	player2.x=46;
	player2.oldx=46;
	player2.y=20;
	player2.oldy=20;
	player2.direction=MOVE_RIGHT;
	player2.score=0;
	player2.sprite=car_right;
	player2.oldsprite=car_right;

	while (1) 
	{

	  player_save(player1);
	  player_save(player2);

/*
// Unfinished steering control variant, example on how to use multipoint()

	  b = multipoint(HORIZONTAL, 8, player1.x, player1.y+7);
	  c = multipoint(HORIZONTAL, 8, player1.x, player1.y+8);   // Extra check to avoid confusion with side borders
	  if ((joystick(stick) & MOVE_DOWN) && (player1.direction & (MOVE_LEFT | MOVE_RIGHT)) && ((b ==1)||((b==128)&&(c==0))))
	      player1.y+=9;
	  
	  b = multipoint(HORIZONTAL, 8, player1.x, player1.y-2);
	  c = multipoint(HORIZONTAL, 8, player1.x, player1.y-3);   // Extra check to avoid confusion with side borders
	  if ((joystick(stick) & MOVE_UP) && (player1.direction & (MOVE_LEFT)) && ((b ==1)||((b==128)&&(c==0))))
	      player1.y-=9;
	  if ((joystick(stick) & MOVE_UP) && (player1.direction & (MOVE_RIGHT)) && ((b ==128)||((b==1)&&(c==0))))
	      player1.y-=9;
	  
	  b = multipoint(VERTICAL, 8, player1.x+7, player1.y);
	  c = multipoint(VERTICAL, 8, player1.x+8, player1.y);   // Extra check to avoid confusion with horizontal borders
	  if ((joystick(stick) & MOVE_RIGHT) && (player1.direction == MOVE_DOWN) && ((b ==1)||((b==128)&&(c==0))))
	      player1.x+=9;
	  if ((joystick(stick) & MOVE_RIGHT) && (player1.direction == MOVE_UP) && ((b==1)||((b==128)&&(c==0))))
	      player1.x+=9;
*/
	  
	  player_step(player1);
	  player_step(player2);

	  // Collision
	  if (((player1.x >> 3) == (player2.x >> 3)) && ((player1.y >> 3) == (player2.y >> 3))) {
		for (x=0 ; x<36; x+=9) {
			putsprite (SPR_XOR, player1.x, player1.y, explosion+x);
	#ifdef SOUND
		if (x<20) bit_fx3(7);
			bit_fx3(2);
	#else
		for (x=0 ; x<800; x++) {}
	#endif
		}
		for (x=0 ; x<27; x+=9) {
			putsprite (SPR_XOR, player1.x, player1.y, explosion+x);
	#ifdef SOUND
			bit_fx3(2);			
	#else
		for (x=0 ; x<800; x++) {}
	#endif
		}
		  exit(score);
	  }
	  
	#ifdef SOUND
	  bit_click();
	#endif
	  
	  // Steering (only on specific positions)
	  for (x=0 ; x<160; x+=5) {
	  // Opponent
	      if ((player2.x == deviations[x+1]) &&
	      (player2.y == deviations[x+2]) &&
		  ((rand()&3) == 0)) {
			player2.x+=deviations[x+3];
			player2.y+=deviations[x+4];
		  }
				
	  
	  // Player
	  if ((joystick(stick) & deviations[x]) &&
	      (player1.x == deviations[x+1]) &&
	      (player1.y == deviations[x+2]))
	    {
			player1.x+=deviations[x+3];
			player1.y+=deviations[x+4];
			break;
	    }		
	  }
	  
	  // Double speed when FIRE is pressed
	  if (joystick(stick) & MOVE_FIRE)
	  {
	  	   player_step(player1);
	#ifdef SOUND
	  	   bit_click();
	#endif
	  }

	  draw_sprite(player1);
	  draw_sprite(player2);
	  
	  
	  show_score(score++);
	#ifdef SOUND
	  bit_click();
	#endif
	  

	}
	
	#ifdef SOUND
	bit_close();
	#endif

}

