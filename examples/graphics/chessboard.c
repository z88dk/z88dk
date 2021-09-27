/*
   Chessboard lib demo/test program
   By Stefano Bodrato - 13/08/2001
   Chess game engine by Stefano Maragò
   
   Sept. 2021:  integrated the game engine by Stefano Maragò
   https://sourceforge.net/p/smmax/blog/2014/08/playing-full-fide-in-766-bytes-/
   
   Black moves first.  If you wish to do otherwise, enter an invalid move.
   Corner A1 is at top-left, H8 at bottom-right.
   Insert the current player's move, e.g. "e2e4", or a blank line to let the computer play.
   Beware that the computer's move is, in the 8bit world, extremely slow !
   (cheating on the CPU speed with an emulator won't be enough to get prompt replies!!!)
   
   $Id: chessboard.c $
   
*/

// zcc +zx chessboard.c -o chessboard -lndos -create-app
// zcc +c128 -create-app -lgfx128hr -DFANCY -DSARGON chessboard.c
//
// optional: -DMIDSIZE, -DFANCY
// yet another option : -DFANCY -DSARGON


#include <stdio.h>
//#define CR 10


#ifdef MIDSIZE
   #include "chessb16.h"
#else
   #ifdef FANCY
      #include "fancychess.h"
   #else
      #if defined __G800__ || defined __TI85__ || defined __TI86__ || defined __Z88__ || defined __VZ200__
         #include "ti_chessboard.h"
      #else
         #if defined __RX78__
           #include "chessb16.h"
         #else
           #include "chessboard.h"
         #endif
      #endif
   #endif
#endif



    int M=136,C=799,K=8,X,Y;
    char c[9],b[128]="VSUWTUSV";
    int D(int k, int x, int n)
    {   int i=0,j,t,p,u,r,y,m=-C,v;
        do
        {   if((u=b[i])&k)
            {   j=".H?LFICF"[p=r=u&7]-64;
                while(r=p>2&r<0?-r:64-"01/@AP@ABPOQ@NR_a@"[++j])
                {   y=i;
                    do
                    {   t=b[y+=r];
                        if((p==7|!x)&&j==8||!(r&7)-!t&p<3|t&k||y&M)break;
                        v=t&k?1:" !!#~#%)"[t&7]-32;
                        if(n&&v<64)
                        {   b[i]=0,b[y]=u;
                            if(p<3&&y+r+1&128)b[y]=(*c&&c[4]?c[4]:55)-48|k,v+=9;
                            v-=D(24-k,2,n-1);
                            if(x&1&&v>-64&&i==X&y==Y)
                            {   if(j==8)b[y+(r>>2^1)]=0,b[y-r/2]=6|k;
                                return 0; }
                            b[i]=u,b[y]=t; };
                        if(v>m)
                        {   m=v;
                            if(n>3)X=i,Y=y; }
                        t+=p<5;
                        if(x&1&&(y&112)+6*k==128&p<3)t--; }
                    while(!t); } } }
        while(i=i+9&~M);
        return m; }



	int v_pieces[]={P_PAWN, P_PAWN, P_PAWN, P_KNIGHT, P_KING, P_BISHOP, P_ROOK, P_QUEEN};


	void update_board()
	{

	  int     x,y;

	  fputc_cons(12);
	  DrawBoard();

	  X=128;
	  x=0; y=0;
	  
	  while(X--) {
		  if (X&8) {
			  X-=7;
			  x=0; y++;
			  //printf ("\n");
		  } else {
			  if ((b[X]&15)!=0) {
				  //printf ("%00x ",b[X]&7);
				PutPiece (7-x,y-1,v_pieces[b[X]&7],(b[X]&15)>>3);
			  }
			  x++;
		  }
	  }
	}



    main()
    {   X=8;
        while(X--)b[X+112]=(b[X]-=64)-8,b[X+16]=18,b[X+96]=9;
        while(1)
        {   //X=128;
            //while(X--)fputc_cons (X&8&&(X-=7) ?CR : ".?+nkbrq?*?NKBRQ"[b[X]&15]);
			update_board();
			//fputc_cons(CR);

            gets(c);
            X=*c-16*c[1]+C,Y=c[2]-16*c[3]+C;
            if(!*c)D(K,0,4);
            if(!D(K,1,1))K^=24;
		}
	}


