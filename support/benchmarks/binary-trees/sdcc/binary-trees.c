/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/

   contributed by Kevin Carson
   compilation:
       gcc -O3 -fomit-frame-pointer -funroll-loops -static binary-trees.c -lm
       icc -O3 -ip -unroll -static binary-trees.c -lm
*/

/*
 * COMMAND LINE DEFINES
 * 
 * -DSTATIC
 * Use static variables instead of locals.
 *
 * -DPRINTF
 * Enable printing of results.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points (Z88DK).
 *
 * -DCOMMAND
 * Enable reading of N from the command line.
 *
 * MALLOC and FREE
 * Can be defined to replace malloc() and free().
 *
 */

#ifdef STATIC
   #undef  STATIC
   #define STATIC            static
#else
   #define STATIC
#endif

#ifdef PRINTF
   #define PRINTF3(a,b,c)    printf(a,b,c)
   #define PRINTF4(a,b,c,d)  printf(a,b,c,d)
#else
   #define PRINTF3(a,b,c)    c
   #define PRINTF4(a,b,c,d)
#endif

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

#ifndef MALLOC
   #define MALLOC  malloc
#endif

#ifndef FREE
   #define FREE    free
#endif

#ifdef __Z88DK
   #include <intrinsic.h>
   #ifdef PRINTF
      // enable printf %u, %ld
      #pragma output CLIB_OPT_PRINTF = 0x1002
   #endif
#endif


#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define pow(a,b)  powf(a,b)


typedef struct tn {
    struct tn*    left;
    struct tn*    right;
    long          item;
} treeNode;


treeNode* NewTreeNode(treeNode* left, treeNode* right, long item)
{
    treeNode*    new;

    new = (treeNode*)MALLOC(sizeof(treeNode));

#ifdef PRINTF
    if (new == NULL)
    {
       printf
       (
          "Out of Memory, item %ld\n",
          item
       );
//       exit(1);
    }
#endif

    new->left = left;
    new->right = right;
    new->item = item;

    return new;
} /* NewTreeNode() */


long ItemCheck(treeNode* tree)
{
    if (tree->left == NULL)
        return tree->item;
    else
        return tree->item + ItemCheck(tree->left) - ItemCheck(tree->right);
} /* ItemCheck() */


treeNode* BottomUpTree(long item, unsigned depth)
{
    if (depth > 0)
        return NewTreeNode
        (
            BottomUpTree(2 * item - 1, depth - 1),
            BottomUpTree(2 * item, depth - 1),
            item
        );
    else
        return NewTreeNode(NULL, NULL, item);
} /* BottomUpTree() */


void DeleteTree(treeNode* tree)
{
    if (tree->left != NULL)
    {
        DeleteTree(tree->left);
        DeleteTree(tree->right);
    }

    FREE(tree);
} /* DeleteTree() */


int main(int argc, char* argv[])
{
    STATIC unsigned   N, depth, minDepth, maxDepth, stretchDepth;
    STATIC treeNode   *stretchTree, *longLivedTree, *tempTree;
    STATIC long       i, iterations, check;

#ifdef COMMAND
    N = atol(argv[1]);
#else
    N = 8;
#endif

TIMER_START();

    minDepth = 4;

    if ((minDepth + 2) > N)
        maxDepth = minDepth + 2;
    else
        maxDepth = N;

    stretchDepth = maxDepth + 1;

    stretchTree = BottomUpTree(0, stretchDepth);
    PRINTF3
    (
        "stretch tree of depth %u\t check: %ld\n",
        stretchDepth,
        ItemCheck(stretchTree)
    );

    DeleteTree(stretchTree);

    longLivedTree = BottomUpTree(0, maxDepth);

    for (depth = minDepth; depth <= maxDepth; depth += 2)
    {
        iterations = pow(2, maxDepth - depth + minDepth) + 0.5;

        check = 0;

        for (i = 1; i <= iterations; i++)
        {
            tempTree = BottomUpTree(i, depth);
            check += ItemCheck(tempTree);
            DeleteTree(tempTree);

            tempTree = BottomUpTree(-i, depth);
            check += ItemCheck(tempTree);
            DeleteTree(tempTree);
        } /* for(i = 1...) */

        PRINTF4
        (
            "%ld\t trees of depth %u\t check: %ld\n",
            iterations * 2,
            depth,
            check
        );
    } /* for(depth = minDepth...) */

    PRINTF3
    (
        "long lived tree of depth %u\t check: %ld\n",
        maxDepth,
        ItemCheck(longLivedTree)
    );

TIMER_STOP();

    return 0;
} /* main() */
