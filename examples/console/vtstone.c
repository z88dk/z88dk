/*
 * Converted to VT-ANSI By Stefano Bodrato
 * Note that the original game had a better looking layout,
 * this version is just more portable but it still needs 80 columns.
 * 
 * You need to have a VT-ANSI compatible driver.
 * It can be part of your system, (do you rembember ANSI.SYS ?)
 * or in the compiler libraries (as in most of the gcc Windows ports).
 * 
 * 
 * TS2068:
 * ---------------------------
 * zcc +ts2068ansi -startup=2 -create-app -lndos -O3 -ostone vtstone.c
 * ---------------------------
 * 
 * 
 * Spectrum (first the ANSI lib needs to be rebuilt):
 * ---------------------------
 * cd {z88dk}/libsrc
 * set ZXCOLS=80   <- do this in the right way for your OS
 * make zxan_clib.lib
 * mv *.lib ../lib/clibs
 * 
 * zcc +zxansi -create-app -lndos -O3 -ostone vtstone.c
 * ---------------------------
 * 
 * 
 * ZX81 (32K +  WRX mod)
 * ---------------------------
 * cd {z88dk}/libsrc
 * set ZXCOLS=80   <- do this in the right way for your OS
 * make zxan_clib.lib
 * mv *.lib ../lib/clibs
 * 
 * zcc +zx81ansi -startup=3 -create-app -lndos -O3 -ostone vtstone.c
 * ---------------------------
 * 
 * 
 * $Id: vtstone.c,v 1.1 2012-05-29 07:27:44 stefano Exp $
 * 
 * Original comment follows
 * ___________________________________________________________
 * 
		    ===
	"STONE" --- H19  Version (for H19/Z19/H89/Z89 ONLY)
		    ===

	(otherwise known as "Awari")

	This version written by:

	Terry Hayes & Clark Baker
	Real-Time Systems Group
	MIT Lab for Computer Science

	Hacked up a little by Leor Zolman and Steve Ward
	(Steve did all the neat H19 display hackery!)

	The algorithm used for STONE is a common one
	to Artificial Intelligence people: the "Alpha-
	Beta" pruning heuristic. By searching up and down 
	a tree of possible moves and keeping record of
	the minimum and maximum scores from the
	terminal static evaluations, it becomes possible
	to pinpoint move variations which can in no way
	affect the outcome of the search. Thus, those
	variations can be simply discarded, saving 
	expensive static evaluation time.

	THIS is the kind of program that lets C show its
	stuff; Powerful expression operators and recursion
	combine to let a powerful algorithm be implemented
	painlessly.

	And it's fun to play!


	Rules of the game:

	Each player has six pits in front of him and a
	"home" pit on one side (the computer's home pit
	is on the left; your home pit is on the right.)

	At the start of the game, all pits except the home
	pits are filled with n stones, where n can be anything
	from 1 to 6.

	To make a move, a player picks one of the six pits
	on his side of the board that has stones in it, and
	redistributes the stones one-by-one going counter-
	clockwise around the board, starting with the pit
	following the one picked. The opponent's HOME pit is
	never deposited into.

	If the LAST stone happens to fall in that player's
	home pit, he moves again.

	If the LAST stone falls into an empty pit on the
	moving player's side of  board, then any stones in the
	pit OPPOSITE to that go into the moving
	player's home pit.

	When either player clears the six pits on his
	side of the board, the game is over. The other player
	takes all stones in his six pits and places them in
	his home pit. Then, the player with the most stones
	in his home pit is the winner.

	The six pits on the human side are numbered one
	to six from left to right; the six pits on the	
	computer's side are numbered one to six right-to-
	left.

	The standard game seems to be with three stones;
	Less stones make it somewhat easier (for both you
	AND the computer), while more stones complicate
	the game. As far as difficulty goes, well...it
	USED to be on a scale of 1 to 50, but I couldn't
	win it at level 1. So I changed it to 1-300, and
	couldn't win at level 1. So I changed it to 1-1000,
	and if I STILL can't win it at level 1, I think
	I'm gonna commit suicide.

	Good Luck!!!
*/


#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/* Declare GFX bitmap location for the expanded ZX81 */
#pragma output hrgpage = 36096

unsigned int total;
char string[80];

unsigned int COUNT;
unsigned int  Seed;
int NUM;

int holex[]={7,10,10,10,10,10,10,8,4,4,4,4,4,4};
int holey[]={7,16,24,32,40,48,56,66,56,48,40,32,24,16};
int stonex[]={0,0,0,-1,1,1,1,-1,-1,1,1,0,0,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-1,0,-2,1,-3,2,2,2,2,3,3,-4,-4,-4,-4,3,2,3,2,3,3,-4,-4};
int stoney[]={0,1,-1,0,0,-1,1,-1,1,-2,2,-2,2,-2,2,0,-1,1,-2,2,0,-1,1,-2,2,-3,-3,-3,-3,-3,0,-1,-2,1,0,-1,-1,0,-2,1,1,2,-2,-3,2,-3,2,-3};


int mod(int i,int j)
{
	++i;
        if (i == 7) return( j ? 7 : 8);
        if (i > 13) return ( j ? 1 : 0);
        return(i);
}

void display(int x, int y)
{
	printf ("\033[%u;%uH",x+1,y+1);
}

void incpit(char *board, int pit)
{
	display(1+holex[pit]+stonex[board[pit]],
		3+holey[pit] +stoney[board[pit]]);
	printf("O");
	board[pit]++;
}

void initb(char *board)
{
         int i,j;
        for (i= 0; i <14; ++i)
	 { board[i]=0;
	   if (i != 0 && i != 7) for (j = 0; j < NUM; j++) incpit(board,i); }
        return;
}

int countnodes(char *board, int start)
{
        int i;
        int num;
        num = 0;
	for (i = start; i< start + 6; ++i)
		num += (board[i] ? 1 : 0);
        return(num);
}

int mmove(char *old, char *_new, int move)
{
         int i; 
        int who;
        total++;

        for (i = 0; i < 14; ++i) _new[i] = old[i];
        if ((move < 1) || (move > 13) || (move == 7) || !_new[move])
                printf("Bad arg to mmove: %u",move);
        who = (move < 7 ? 1 : 0);
        i = old[move];
        _new[move] = 0;
        while (i--) {
                move = mod(move,who);
		++_new[move];
        }
        if (_new[move] == 1 && who == (move < 7 ? 1 : 0) && move && move != 7)
        { 
                _new[who*7] += _new[14-move];
                _new[14-move] = 0;
        }
        if (move == 0 || move == 7) return(0); 
        else return(1);
}

int _max(int i, int j)
{
        return(i > j ? i : j);
}

int _min(int i,int j)
{
        return(i < j ? i : j);
}

int notdone(char *board)
{
	return (board[1] || board[2] || board[3] || board[4]
		|| board[5] || board[6]) &&
	       (board[8] || board[9] || board[10] || board[11]
		|| board[12] || board[13]);
}

int comp1(char *board, int who, unsigned int count, int alpha, int beta)
{
        int i;
        int turn;
        int _new;
        char temp[14];
        unsigned int nodes;
        if (count < 1) {
                _new = board[0]-board[7];
                for (i = 1; i < 7; ++i) { turn = _min(7-i,board[i]);
                                          _new -= 2*turn - board[i]; }
                for (i = 8; i < 14; ++i) { turn = _min(14-i,board[i]);
                                           _new += 2*turn - board[i]; }
                if (board[0] > 6*NUM) _new += 1000;
                if (board[7] > 6*NUM) _new -= 1000;
                return(_new);
        }
        if (!notdone(board)) {
                _new = board[0]+board[8]+board[9]+board[10]
                    +board[11]+board[12]+board[13]-board[1]-board[2]
                    -board[3]-board[4]-board[5]-board[6]-board[7];
                if ( _new < 0) return (_new - 1000);
                if ( _new > 0) return (_new + 1000);
                return(0);
        }
        nodes = count/countnodes(board,8-who*7);
        for (i = 7*(1-who)+6; i > 7*(1-who); --i)
                if (board[i]) {
                        turn = mmove(board,temp,i);
                        _new = comp1(temp,(turn? 1-who: who),nodes,alpha,beta);
                        if (who) {
                           beta = _min(_new,beta);
                           if (beta <= alpha) return(beta); }
                        else { 
                            alpha = _max(_new,alpha);
                            if (alpha >= beta) return(alpha); }
                }
        return(who ? beta : alpha);
}


int comp(char *board)
{
         int score;
        int bestscore,best;
        char temp[14];
         int i;
        unsigned int nodes;
        total = 0;

        if ((i = countnodes(board,8)) == 1)
                for (best = 8; best < 14; ++best)
                        if (board[best]) return(best);
        nodes = COUNT/i;
        bestscore = -10000;
        for (i = 13; i > 7; --i) if (board[i]) {
                score = mmove(board,temp,i);
		score = comp1( temp, score, nodes, bestscore, 10000);
                if (score > bestscore) {
                        bestscore = score;
                        best = i;
                }
        }
	display(19,10);
        if (bestscore > 1000)
		puts("\033[7m I'VE GOT YOU! \033[27m\n");
        if (bestscore < -1000)
                printf("\033[7m YOU'VE GOT ME! \033[27m\n");
        return(best);
}

void decpit(char *board, int pit)
{
	board[pit]--;
	display(1+holex[pit]+stonex[board[pit]],
		3+holey[pit] +stoney[board[pit]]);
	putchar(' ');
}


void rpt(char *cc, int n)
 {	while (n--) printf(cc); }

void rptc(int cc, int n)
 {	while (n--) putchar(cc); }

void nb1(int n)
 {	rpt("##    \033[27m        \033[7m  \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m  \033[27m        \033[7m  ##\n", n); }

void NewBD()
 {	
	printf("\033[H\033[2J\033[7m");
	rptc('#', 77);
	printf("\n##"); rptc(' ',73);
	printf("##\n##");
	printf("       ME        6       5       4       3");
	printf("       2       1               ##\n##     \033[27m      \033[7m  ");
	rpt("  \033[27m     \033[7m ", 6); printf("            ##\n");
	printf("##    \033[27m        \033[7m  \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m   \033[27m      \033[7m   ##\n");
	nb1(2);
	printf("##    \033[27m        \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m        \033[7m  ##\n");
	printf("##    \033[27m        \033[7m                                                   \033[27m        \033[7m  ##\n");

	printf("##    \033[27m        \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m        \033[7m  ##\n");
	nb1(2);
	printf("##     \033[27m      \033[7m   \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m \033[27m       \033[7m  \033[27m        \033[7m  ##\n");
	printf("##               \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m   \033[27m     \033[7m    \033[27m      \033[7m   ##\n");
	printf("##                 1       2       3       4       5       6        YOU    ##\n");
	printf("##                                                                         ##\n");
	rptc('#', 77);
	printf("\033[27m");
 }


/*int sleep(n)
 {	int i;
	while (n--) for (i=12000; i--;); }
*/

int dmove(char *_new, int move)
{	int i;
	int j; 
	int who;
	if ((move < 1) || (move > 13) || (move == 7) || !_new[move])
		printf("Bad arg to mmove: %u",move);
	who = (move < 7 ? 1 : 0);
	i = _new[move];
	for (j = 0; j < i; j++) decpit(_new,move);
	sleep(2);
	while (i--) {
		move = mod(move,who);
		incpit(_new,move);
		putchar(7);
		/*sleep(1);*/
	}
	if (_new[move] == 1 && who == (move < 7 ? 1 : 0) && move && move != 7)
		while(_new[14-move]) { 
			decpit(_new,14-move);
			incpit(_new,who*7);
		}
	if (move == 0 || move == 7) return(0); 
	else return(1);
}



int main(int argc, char *argv[])
{
        int  hum,com,y,inp;
        char board[14];
	for (y=0; y<1000; y++) Seed += stonex[y];
	srand(Seed);

lnew:
	printf("\033[2J");
	printf("New Game:\nDifficulty (1-1000, or q to quit): ");
	inp = atoi(gets(string));
	if (inp < 1) { printf("\033[2J"); return(0); }
	if (inp>1000) goto lnew;
	printf("Number of stones (1-6): ");
	NUM = atoi(gets(string));
	COUNT = inp * 65;
	NewBD();
	initb(board);
	display(21,50); printf("\033[7m Difficulty: %u \033[27m", inp);
	display(19,0);
	printf("Do you want to go first (y or n)? ");
	inp = toupper(getchar());
        display(19,0);
        printf("\033[2K\n\n");
        if (inp ==  'N') goto first;
        y = 0;
        while(notdone(board)) {
again:		display(20,10);
                printf("\033[7m Your move:   \b\b");
                for (;;) {
			puts("\033[7m"); display(20,22);
                        inp = getchar() - '0';
			if (toupper(inp+'0')=='Q')goto lnew;
                        if (inp < 1 || inp > 6 || !board[inp])
			 { putchar(7); goto again; }
                        y++;
                        break;
                }
		puts("\033[27m");
                if (!dmove(board,inp)) continue;
first:		display(20,10); rptc(' ', 30);
                y = 0;
                while (notdone(board)) {
			display(21, 10);
	                printf("\033[7m I'm thinking \033[27m");
                        inp = comp(board);
			display(21,10); rptc(' ', 30);
			display(22,10);
                        printf("\033[7m Computer moves: ");
                        printf("%u \033[27m",inp-7);
                        y++;
                        if (dmove(board,inp)) break;
			display(22,10); rptc(' ', 30);
                }
                y = 0;
        }
        com = board[0]; 
        hum = board[7];
        for (inp = 1; inp < 7; inp++) { 
                hum += board[inp]; 
                com += board[inp+7]; 
        }
	display(23,10);
        printf("\033[7m Score:   me %u  you %u . . . ",com,hum);
	sleep(2);
	if (com>hum) switch (rand() % 4) {
		case 0: printf("Gotcha!!");
			break;
		case 1:	printf("Chalk one up for the good guys!");
			break;
		case 2: printf("Automation does it again!");
			break;
		case 3: printf("I LOVE to WIN!");
		}
	else if (hum==com) printf("How frustrating!!");
	else printf("Big Deal! Try a REAL difficulty!");
	printf(" \033[27m");
	sleep(3);

}
