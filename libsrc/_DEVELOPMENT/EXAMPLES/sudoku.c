// SUDOKU PUZZLE SOLVER
// press enter after each row, use '0' for empty cell

// zcc +cpm -vn -O3 -clib=new sudoku.c -o sudoku -create-app
// zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 sudoku.c -o sudoku -create-app

// zcc +zx -vn -startup=1 -O3 -clib=new sudoku.c -o sudoku -create-app
// zcc +zx -vn -startup=1 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 sudoku.c -o sudoku -create-app

// use -DVERBOSE to print list of steps taken

#pragma output CLIB_OPT_PRINTF       = 0x00000102    // printf has %uB enabled only

#ifdef __SPECTRUM
#pragma output REGISTER_SP           = -1            // do not change stack pointer
#endif

#pragma output CLIB_EXIT_STACK_SIZE  = 0             // do not reserve space for registering atexit() functions
#pragma output CLIB_MALLOC_HEAP_SIZE = 0             // do not create malloc heap
#pragma output CLIB_STDIO_HEAP_SIZE  = 0             // do not create stdio heap (cannot open files)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <adt/p_list.h>
#include <obstack.h>
#include <stdint.h>

struct sudoku_cell
{
   void *next;                   // doubly linked list links
   void *prev;
   int16_t state;                // bits 15 = flag, 8:0 set indicates number possible
};

struct sudoku
{
   struct sudoku_cell grid[81];  // 9x9 board
   p_list_t remain[10];          // remain[N] holds list of cells with N possible numbers
};

struct sudoku puzzle;

uint16_t changes;

const uint8_t count[512] = { 
   0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, /*   0.. 31 */ 
   1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, /*  32.. 63 */ 
   1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, /*  64.. 95 */ 
   2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, /*  96..127 */ 
   1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, /* 128..159 */ 
   2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, /* 160..191 */ 
   2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, /* 192..224 */ 
   3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8, /* 225..255 */ 
   1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, /* 256..287 */ 
   2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, /* 288..319 */ 
   2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, /* 320..351 */ 
   3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8, /* 352..383 */ 
   2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, /* 384..415 */ 
   3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8, /* 416..447 */ 
   3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8, /* 448..479 */ 
   4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8, 5, 6, 6, 7, 6, 7, 7, 8, 6, 7, 7, 8, 7, 8, 8, 9, /* 480..511 */
};

char stack_space[30*sizeof(struct sudoku)+6];

struct obstack *stack;

void mark(struct sudoku_cell *sc, uint16_t pstate)
{   
   if ((sc->state < 0) || ((sc->state & pstate) == 0))
      return;

   p_list_remove(&puzzle.remain[count[sc->state]], sc);
   sc->state &= ~pstate;
   p_list_push_front(&puzzle.remain[count[sc->state]], sc);

   ++changes;
   
   return;
}

uint16_t place(struct sudoku_cell *sc, uint16_t pstate, uint8_t peers)
{
   uint8_t i;
   divu_t coord;
   struct sudoku_cell *end, *v;
   
   // COMPUTE ROW, COL
   
   _divu_(&coord, (uint16_t)(sc - puzzle.grid), 9);

   // coord.quot = row
   // coord.rem  = column
   
   // VISIT ROW
   
   if (peers & 0x4)
   {
      v = &puzzle.grid[coord.quot * 9];
      end = v + 9;
   
      while (v < end)
      {
         mark(v,pstate);
         ++v;
      }
   }
   
   // VISIT COLUMN

   if (peers & 0x2)
   {
      v = &puzzle.grid[coord.rem];
      end = v + 81;

      while (v < end)
      {
         mark(v,pstate);
         v += 9;
      }
   }
   
   // VISIT BLOCK

   if (peers & 0x1)
   {
      v = &puzzle.grid[(coord.quot/3)*27 + (coord.rem/3)*3];
      end = v + 21;

      i = 0;
      while (v < end)
      {
         mark(v,pstate);
      
         if (++i == 3)
         {
            i = 0;
            v += 7;
         }
         else ++v;
      }
   }

   return p_list_empty(&puzzle.remain[0]);
}

uint8_t buddy(struct sudoku_cell *sc1, struct sudoku_cell *sc2)
{
   divu_t coord1, coord2;
   uint8_t peers;
   
   _divu_(&coord1, (uint16_t)(sc1 - puzzle.grid), 9);
   _divu_(&coord2, (uint16_t)(sc2 - puzzle.grid), 9);

   // coord.quot = row
   // coord.rem  = column

   peers  = (coord1.quot/3 == coord2.quot/3) && (coord1.rem/3 == coord2.rem/3);
   peers += (coord1.rem == coord2.rem) * 2;
   peers += (coord1.quot == coord2.quot) * 4;
   
   return peers;
}

uint16_t solve_sudoku(void)
{
#ifdef VERBOSE
   divu_t coord;
#endif
   uint16_t j;
   uint8_t i;
   struct sudoku_cell *sc2, *sc1;

process_solo:

   // PLAY CELLS WITH ONE REMAINING CHOICE

   while (sc1 = p_list_pop_front(&puzzle.remain[1]))
   {
#ifdef VERBOSE
      _divu_(&coord, (uint16_t)(sc1 - puzzle.grid), 9);
      printf("Placing %u at (%u,%u)\n", ffs(sc1->state), coord.quot+1, coord.rem+1);
#endif

      sc1->state |= 0x8000;
      if (!place(sc1, sc1->state & 0x01ff, 0x7)) return 0;
   }

   // INVESTIGATE TUPLES - PAIRS

#ifdef VERBOSE
   printf("Investigating Pairs...\n");
#endif

   do
   {
      changes = 0;
      
      for (sc2 = p_list_front(&puzzle.remain[2]); sc2; sc2 = p_list_next(sc2))
      {
         for (sc1 = p_list_next(sc2); sc1; sc1 = p_list_next(sc1))
         {
            if ((sc1->state == sc2->state) && (i = buddy(sc1,sc2)))
            {
#ifdef VERBOSE
               _divu_(&coord, (uint16_t)(sc1 - puzzle.grid), 9);
               printf("Pairs at (%u,%u) and ", coord.quot+1, coord.rem+1);
               
               _divu_(&coord, (uint16_t)(sc2 - puzzle.grid), 9);
               printf("(%u,%u)\n", coord.quot+1, coord.rem+1);
#endif

               sc1->state |= 0x8000;
               sc2->state |= 0x8000;
            
               if (!place(sc1, sc1->state & 0x01ff, i)) return 0;
            
               sc1->state &= 0x01ff;
               sc2->state &= 0x01ff;
           
               if (!p_list_empty(&puzzle.remain[1])) goto process_solo;
            }
         }
      }
      
   } while (changes);

   // TRIAL AND ERROR
   
   for (i=2; i<10; ++i)
      if (sc1 = p_list_front(&puzzle.remain[i])) break;

   if (sc1 == 0) return 1;
   
   j=1;
   do
   {
      if (sc1->state & j)
      {
         if ((sc2 = obstack_copy(stack, &puzzle, sizeof(struct sudoku))) == 0)
         {
#ifdef VERBOSE
            printf("Out of Memory!\n");
#endif
            return 0;
         }

#ifdef VERBOSE
         printf("Trial and Error... %09B\n  -> ", sc1->state);
#endif

         p_list_remove(&puzzle.remain[count[sc1->state]], sc1);
         sc1->state = j;
         p_list_push_front(&puzzle.remain[1], sc1);

         if (solve_sudoku()) return 1;
         
         memcpy(&puzzle, sc2, sizeof(struct sudoku));
         obstack_free(stack, sc2);

#ifdef VERBOSE
         printf("Backtrack... %09B\n", sc1->state);
#endif
      }

   } while ((j*=2) & 0x1ff);
   
   return 0;
}

main()
{
   uint8_t i, j;
   int16_t c;
   struct sudoku_cell *sc;
   
   stack = (struct obstack *)(stack_space);
   obstack_init(stack, sizeof(stack_space));

#ifdef __SPECTRUM
   printf("\x0cSUDOKU SOLVER\nby aralbrec @ z88dk.org\n");
#else
   printf("\nSUDOKU SOLVER\nby aralbrec @ z88dk.org\n");
#endif

   while (1)
   {
      memset(&puzzle, 0, sizeof(struct sudoku));
      obstack_free(stack, 0);

      printf("\n\nEnter Puzzle:\n\n");
      fflush(stdin);
      
      sc = &puzzle.grid[0];
      for (i=0; i<9; ++i)
      {
         for (j=0; j<9; ++j)
         {
            while ((c = getchar()) == '\n') ;
            if (c == EOF) return 0;
      
            if ((c>='1') && (c<='9'))
            {
               sc->state = 1 << (c-'1');
               p_list_push_front(&puzzle.remain[1], sc);
            }
            else
            {
               sc->state = 0x1ff;
               p_list_push_front(&puzzle.remain[9], sc);
            }
            
            ++sc;
         }
      }

      if (solve_sudoku())
      {
         printf("\n+-----+-----+-----+\n");
         
         sc = &puzzle.grid[0];
         for(i=0; i<9; ++i)
         {
            for(j=0; j<9; ++j)
            {
               printf("|%u", ffs(sc->state));
               ++sc;
            }
               
            printf("|\n");
            
            if ((i+1)%3 == 0) printf("+-----+-----+-----+\n");
         }
      }
      else printf("\n\nNO SOLUTION\n\n");
   }
}
