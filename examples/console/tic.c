/*   TIC TAC TOE  (TRIS)  Game
     By Stefano Bodrato
     ... a broken algorithm so you can win some time   */

#include <stdio.h>

char x;

char board[] = {
	'1','2','3',
	'4','5','6',
	'7','8','9'
};


char threes[] = {
	0,1,2,
	3,4,5,
	6,7,8,
	0,4,8,
	6,4,2,
	0,3,6,
	1,4,7,
	2,5,8
};


void printboard()
{

	printf("\n     *     *");
	printf("\n  %c  *  %c  *  %c", board[0], board[1], board[2]);
	printf("\n*****************");
	printf("\n  %c  *  %c  *  %c", board[3], board[4], board[5]);
	printf("\n*****************");
	printf("\n  %c  *  %c  *  %c     ", board[6], board[7], board[8]);
	printf("\n     *     *");
	printf("\n\n");
/*
	printf("\n          *          *          ");
	printf("\n    %c     *    %c     *    %c     ", board[0], board[1], board[2]);
	printf("\n          *          *          ");
	printf("\n********************************");
	printf("\n          *          *          ");
	printf("\n    %c     *    %c     *    %c     ", board[3], board[4], board[5]);
	printf("\n          *          *          ");
	printf("\n********************************");
	printf("\n          *          *          ");
	printf("\n    %c     *    %c     *    %c     ", board[6], board[7], board[8]);
	printf("\n          *          *          ");
	printf("\n\n");
*/
} 


int domove(char player,char opponent)
{
	
	// Is the center of board free ?
	if ( board[4] != player &&  board[4] != opponent )
	{
		board[4] = player;
		return (0);
	}
	
	
	// Can I win ?
	for (x=0 ; x!=8; x++)
	{
	   if ((board[threes[x*3]]==player && board[threes[x*3+1]]==player) &&
		(board[threes[x*3+2]] != player && board[threes[x*3+2]] != opponent))
	   {
		board[threes[x*3+2]] = player;
		return (1);
	   }
	   else if ((board[threes[x*3+1]]==player && board[threes[x*3+2]]==player) && 
	   	(board[threes[x*3]] != player && board[threes[x*3]] != opponent))
	   {
		board[threes[x*3]] = player;
		return (1);
	   }
	}
	
	
	// Is the opponent going to win ?
	for (x=0 ; x!=8; x++)
	{
	   if ((board[threes[x*3]]==opponent && board[threes[x*3+1]]==opponent) &&
		(board[threes[x*3+2]] != player && board[threes[x*3+2]] != opponent))
	   {
		board[threes[x*3+2]] = player;
		return (0);
	   }
	   else if ((board[threes[x*3+1]]==opponent && board[threes[x*3+2]]==opponent) && 
	   	(board[threes[x*3]] != player && board[threes[x*3]] != opponent))
	   {
		board[threes[x*3]] = player;
		return (0);
	   }
	}
	
	
	// Put in the first free place
	for (x=0 ; x!=9; x++)
	{
		if ( board[x] != player &&  board[x] != opponent )
		{
			board[x] = player;
			return (0);
		}
	}

	return(2);
}


int human(char player,char opponent)
{

	signed char c;
	while (1)
	{
		c=10;
		
		while (c<0 || c>9)
			//c=(getch()-49);
			c=(getk()-49);
		
		if ( board[c] != player &&  board[c] != opponent )
		{
			board[c]=player;
			return (1);
		}
	}
}


int ckwin(char player)
{
	for (x=0 ; x!=8; x++)
	{
	   if ( board[threes[x*3]]==player && 
	   	board[threes[x*3+1]]==player &&
	   	board[threes[x*3+2]]==player) return (1);
	}
	return(0);
}


int ckfree (char player1 , char player2)
{
	for (x=0 ; x!=9; x++)
	{
		if ( board[x] != player1 &&  board[x] != player2 )
		{
			return (1);
		}
	}

	return(0);
}


int ckgame (char player1 , char player2)
{

		if (ckwin (player1))
			{
			  printf ("%c is the winner\n\n",player1);
			  return (1);
			}
		if (ckwin (player2))
			{
			  printf ("%c is the winner\n\n",player2);
			  return (2);
			}
		if (!ckfree (player1,player2))
			{
			  printf ("No winners\n\n");
			  return (3);
			}
		return (0);
}


int main()
{

	//for (x=0 ; x!=9; x++) board[x] = x;
	
	printboard();

	while (ckgame ('X','O') == 0)
	{
		human ('X','O');

		printboard();
		
		if (ckgame ('X','O') != 0)
			return (0);
		
		domove ('O','X');

		printboard();
	}
	return 0;
}


