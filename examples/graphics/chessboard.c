/*
   Chessboard lib demo/test program
   By Stefano Bodrato - 13/08/2001
   
   $Id: chessboard.c $
   
*/

// zcc +zx chessboard.c -o chessboard -lndos -create-app
// zcc +c128 -create-app -lgfx128hr -DFANCY -DSARGON chessboard.c
//
// optional: -DMIDSIZE, -DFANCY
// yet another option : -DFANCY -DSARGON

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

void main()
{

  int     x;

  DrawBoard();

  //Black Rook
  PutPiece (0,0,P_ROOK,P_BLACK);
  PutPiece (7,0,P_ROOK,P_BLACK);

  //Black Knight
  PutPiece (1,0,P_KNIGHT,P_BLACK);
  PutPiece (6,0,P_KNIGHT,P_BLACK);

  //Black Bishop
  PutPiece (2,0,P_BISHOP,P_BLACK);
  PutPiece (5,0,P_BISHOP,P_BLACK);

  //Black Queen
  PutPiece (3,0,P_QUEEN,P_BLACK);

  //Black King
  PutPiece (4,0,P_KING,P_BLACK);

  //Black Pawn
  for (x=0 ; x!=8; x++)
  {
    PutPiece (x,1,P_PAWN,P_BLACK);
  }

  //White Pawn
  for (x=0 ; x!=8; x++)
  {
    PutPiece (x,6,P_PAWN,P_WHITE);
  }

  //White Rook
  PutPiece (0,7,P_ROOK,P_WHITE);
  PutPiece (7,7,P_ROOK,P_WHITE);

  //White Knight
  PutPiece (1,7,P_KNIGHT,P_WHITE);
  PutPiece (6,7,P_KNIGHT,P_WHITE);

  //White Bishop
  PutPiece (2,7,P_BISHOP,P_WHITE);
  PutPiece (5,7,P_BISHOP,P_WHITE);

  //White Queen
  PutPiece (3,7,P_QUEEN,P_WHITE);

  //White King
  PutPiece (4,7,P_KING,P_WHITE);

}
