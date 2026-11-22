
/*

        Collider, a multi platform game skeleton written for Z88DK
        By Stefano Bodrato, 2019 - Robert Kacsich 2024
		
		
		This example uses the traditional way of comparing actual coordinates to detect collisions and walls.
		See the commented code and microman.c for a different approach.


        How to compile
        ==============
        
        zcc +<target> -lndos -create-app -ocollider -DSOUND -DJOYSTICK_DIALOG -DJOYSTICK_NUMBER=n -DSCREEN_MODE_GAME=n -DSCREEN_MODE_STANDARD=n collider.c
        
        Minimum graphics resolution required: 96x64
        Use -pragma-redirect=fputc_cons=putc4x6 if text and graphics aren't mixed natively
        
        
        (-DSOUND and -DJOYSTICK_DIALOG can be removed where not applicable)
		(same for -DJOYSTICK_NUMBER, -DSCREEN_MODE_GAME and -DSCREEN_MODE_STANDARD)
		-DJOYSTICK_NUMBER specifies the virtual joystick number to be used (if not specified and without -DJOYSTICK_DIALOG, virtual joystick number 1 is used)
		-DSCREEN_MODE_GAME specifies the screen mode that is to be used for gameplay (if not specified, no screen mode switching takes place)
		-DSCREEN_MODE_STANDARD same for the standard screen mode that is to be restored when the program terminates
*/



#include <graphics.h>
#include <games.h>
#include <stdio.h>
#include <sound.h>
#include <stdlib.h>


#if defined(__ALPHATRO__) || defined(__CPC__)
	// we need to include conio.h only for the colour constants
	#include <conio.h>
#endif

#if defined(SCREEN_MODE_GAME) || defined(SCREEN_MODE_STANDARD)
	#include <sys/ioctl.h>		// required for switching the screen mode
#endif

#define VERTICAL   1
#define HORIZONTAL 0


// Enum all the dot coordinates.
// The third parameter is a flag, reset when 'taken' by the player.

char dots[] = {
	5,5,0, 5,59,0, 54,5,0, 54,59,0, 11,5,0, 11,59,0, 60,5,0, 60,59,0,
	17,5,0, 17,59,0, 66,5,0, 66,59,1 ,23,5,0, 23,59,0, 72,5,0, 72,59,0, 29,5,0, 29,59,0,
	78,5,0, 78,59,0, 35,5,0, 35,59,0, 84,5,0, 84,59,0, 41,5,0, 41,59,0,
	90,5,0, 90,59,0, 14,14,0, 14,50,0, 57,14,0, 57,50,0, 20,14,0, 20,50,0,
	63,14,0, 63,50,0, 26,14,0, 26,50,0, 69,14,0, 69,50,0, 32,14,0, 32,50,0,
	75,14,0, 75,50,0, 38,50,0, 81,14,0, 81,50,0,
	60,23,0, 60,41,0, 23,23,0, 23,41,0, 29,23,0, 29,41,0, 66,23,0, 66,41,0, 35,23,0, 35,41,0,
	72,23,0, 72,41,0, 5,11,0, 90,11,0, 5,17,0, 90,17,0, 5,23,0, 90,23,0,
	5,29,0, 90,29,0, 5,35,0, 90,35,0, 5,41,0, 90,41,0, 5,47,0, 90,47,0,
	5,53,0, 90,53,0, 14,20,0, 81,20,0, 14,38,0, 81,38,0, 14,26,0, 81,26,0, 14,44,0, 81,44,0,  0
	};
	
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

//unsigned char car_logo[] = { 54, 14, 
//  0x00 , 0x00 , 0x00 , 0x00 , 0x70 , 0x00 , 0x00 , 
//  0x00 , 0x00 , 0x00 , 0x00 , 0x8C , 0x00 , 0x00 ,
//  0x00 , 0x00 , 0x00 , 0x00 , 0x83 , 0x00 , 0xF8 ,
//  0x00 , 0x00 , 0x00 , 0x07 , 0x80 , 0xC1 , 0x04 ,
//  0x00 , 0x00 , 0x00 , 0x08 , 0x80 , 0x30 , 0x84 ,
//  0x00 , 0x01 , 0xFF , 0x91 , 0xC0 , 0x0C , 0x84 ,
//  0x07 , 0xDE , 0x00 , 0x66 , 0x38 , 0x03 , 0xC4 ,
//  0x78 , 0x3F , 0x20 , 0x38 , 0x07 , 0x87 , 0xE4 ,
//  0x80 , 0x73 , 0x98 , 0x15 , 0x54 , 0x7E , 0x74 ,
//  0xFE , 0x6D , 0x86 , 0x20 , 0x00 , 0x0D , 0xB8 ,
//  0x15 , 0xED , 0x81 , 0x20 , 0x00 , 0x0D , 0xB0 ,
//  0x3F , 0x73 , 0x80 , 0xA0 , 0x00 , 0x0E , 0x70 ,
//  0x40 , 0xBF , 0x7F , 0x5F , 0xFF , 0xF7 , 0xE0 ,
//  0x7F , 0x9E , 0x00 , 0x00 , 0x00 , 0x03 , 0xC0  };


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

struct player player1;
struct player player2;

char scoretxt[7];
int x,y,z;
int stick;
int score;
int dotCount;

show_score (int sc)
{
    sprintf (scoretxt,"%06u",sc);
    //clga (34,29,30,5);
    for (z=0; z<6; z++) {
      putsprite (SPR_AND, 34+5*z, 29, blank);
      putsprite (SPR_OR, 34+5*z, 29, &numbers[(scoretxt[z]-48)*7]);
    }
}


draw_board ()
{

	clg();
	
	dotCount=0;
	
	for (x=0; dots[x]; x+=3) {
		plot(dots[x],dots[x+1]);
		dots[x+2]=1;
		dotCount++;
	}

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

}


draw_sprite(struct player *the_player)
{
	  putsprite(SPR_XOR,the_player->oldx,the_player->oldy,the_player->oldsprite);
          putsprite(SPR_XOR,the_player->x,the_player->y,the_player->sprite);
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


eat_dot() {
	#ifdef SOUND
	  bit_click();
	#endif
	show_score(score++);
	#ifdef SOUND
	  bit_click();
	#endif
	  xorplot (dots[x],dots[x+1]);
	dots[x+2]=0;
	#ifdef SOUND
	  bit_click();
	#endif
	dotCount--;
}


main()
{
	int gamePlayActive;
	int playerAlive = 1;
	int highScore = 0;
	int level = 1;
	int mode;
	int joyStatus; // for virtual joystick input
	#if defined(SCREEN_MODE_GAME)
		// switch to hires mode
		mode = SCREEN_MODE_GAME;
		console_ioctl(IOCTL_GENCON_SET_MODE, &mode);
	#endif	
	// Disable visible cursor on the VZ 
	#if defined(__VZ200__)
	#asm
	di
	#endasm
	#endif
	#if defined(__CPC__)
		textcolor(WHITE);
		textbackground(BLACK);		
	#elif defined(__ALPHATRO__)
		// The Alphatronic PC has foreground and background colour setting swapped (a bug?)
		textcolor(BLACK);
		textbackground(WHITE);	
	#endif	

	clg();
	
#ifdef SOUND
	bit_open();
#endif


/****  JOYSTICK CHOICE  ****/

#ifdef JOYSTICK_DIALOG
	//printf("%c",12);
	printf("\n\n\n");

	//putsprite(SPR_XOR,1,1,car_logo);

	for (x=0 ; x!=GAME_DEVICES; x++)
      	printf("%u - %s\n",x+1,joystick_type[x]);
        
	stick = 0;
	while ((stick < 1) || (stick > GAME_DEVICES))
		stick = getk() - 48;
#else
	stick=JOYSTICK_NUMBER;
#endif

	clg();

	while(1)
	{
		gamePlayActive = 1;
		if (playerAlive<1) level = 1;
		
		draw_board ();
		
		player1.x=46;
		player1.oldx=46;
		player1.y=56;
		player1.oldy=46;
		player1.direction=MOVE_RIGHT;
		if (playerAlive<1) player1.score=0;
		player1.sprite=car_right;
		player1.oldsprite=car_right;

		player2.x=46;
		player2.oldx=46;
		player2.y=20;
		player2.oldy=20;
		player2.direction=MOVE_RIGHT;
		if (playerAlive<1) player2.score=0;
		player2.sprite=car_right;
		player2.oldsprite=car_right;

		playerAlive = 1;

		putsprite(SPR_XOR,player1.x,player1.y,player1.oldsprite);
		putsprite(SPR_XOR,player2.x,player2.y,player2.oldsprite);

		if (level==1 && highScore>0)
		{
				// Briefly show high score before the game starts
				show_score(highScore);
				csleep(100);
				show_score(0);
		}

		while (gamePlayActive>0)
		{

		  player_save(player1);
		  player_save(player2);

		  player_step(player1);

		  if (player1.direction == MOVE_RIGHT) {
				for (x=0; dots[x]; x+=3) {
					if (dots[x+2]&&(dots[x]==(player1.x+5))&&(dots[x+1]==(player1.y+3)))
						eat_dot();
				}
		  }

		  if (player1.direction == MOVE_LEFT) {
				for (x=0; dots[x]; x+=3) {
					if (dots[x+2]&&(dots[x]==(player1.x))&&(dots[x+1]==(player1.y+3)))
						eat_dot();
				}
		  }

		  if (player1.direction == MOVE_DOWN) {
				for (x=0; dots[x]; x+=3) {
					if (dots[x+2]&&(dots[x+1]==(player1.y+6))&&(dots[x]==(player1.x+3)))
						eat_dot();
				}
		  }

		  if (player1.direction == MOVE_UP) {
				for (x=0; dots[x]; x+=3) {
					if (dots[x+2]&&(dots[x+1]==(player1.y))&&(dots[x]==(player1.x+2)))
						eat_dot();
				}
		  }
		  
		  if (dotCount<1) // All dots eaten -> end of level
		  {	
			gamePlayActive=0;  
			csleep(100);
			#ifdef SOUND
				bit_fx4(1);
			#endif
			csleep(100);
			score--; // Score value is always 1 point ahead at this time
			score = score + 10*level;
			show_score(score);
			score++; // Score value will be decreased by 1 further below
			csleep(100);
			level++;			
		  }

		  player_step(player2);

		  // Collision
		  if (((player1.x >> 3) == (player2.x >> 3)) && ((player1.y >> 3) == (player2.y >> 3))) {
			for (x=0 ; x<36; x+=9) {
				putsprite (SPR_XOR, player1.x, player1.y, explosion+x);
		#ifdef SOUND
			if (x<20) bit_fx3(7);
				bit_fx3(2);
		#else
			csleep(30);
		#endif
			}
			for (x=0 ; x<27; x+=9) {
				putsprite (SPR_XOR, player1.x, player1.y, explosion+x);
		#ifdef SOUND
				bit_fx3(2);			
		#else
			csleep(30);
		#endif
			}
			  // exit(score);
			  gamePlayActive=0;
			  playerAlive=0;
			  csleep(100);
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
		  // RobertK: poll virtual joystick only once within the game loop
		  // if ((joystick(stick) & deviations[x]) &&
		  joyStatus = joystick(stick);
		  if ((joyStatus & deviations[x]) &&
			  (player1.x == deviations[x+1]) &&
			  (player1.y == deviations[x+2]))
			{
				player1.x+=deviations[x+3];
				player1.y+=deviations[x+4];
				break;
			}		
		  }
		  
		  // Double speed when FIRE is pressed
		  // if (joystick(stick) & MOVE_FIRE)
		  if (joyStatus & MOVE_FIRE)
		  {
			   player_step(player1);
		#ifdef SOUND
			   bit_click();
		#endif
		  }

		  draw_sprite(player1);
		  draw_sprite(player2);
		  

		#ifdef SOUND
		  bit_click();
		#endif
		  

		}

		score--; // Score value is always 1 point ahead at this time
		if (playerAlive<1)
		{
			if (score>highScore) highScore=score;
			score = 0;
		}
	} 
	
	
	#ifdef SOUND
	bit_close();
	#endif

	// Switch back to the default text mode
	#if defined(SCREEN_MODE_STANDARD)
		mode = SCREEN_MODE_STANDARD;
		console_ioctl(IOCTL_GENCON_SET_MODE, &mode);		
	#endif

}
