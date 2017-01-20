#ifndef _ALGORITHM_H
#define _ALGORITHM_H

//////////////////////////////////////////////////////////////////
//                                                              //
//                         ALGORITHMS                           //
//                                                              //
// A home for interesting and useful algorithm implementations. //
// Link to -lalgorithm when using functions from this library.  //
//                                                              //
// Contents:                                                    //
//                                                              //
//  1. A* Search Algorithm, 01.2007 aralbrec                    //
//                                                              //
//////////////////////////////////////////////////////////////////

#include <sys/compiler.h>
#include <sys/types.h>

/*****************************************************************/
// 1. A* Search Algorithm, 01.2007 aralbrec
// See http://en.wikipedia.org/wiki/A%2A_search_algorithm
// Program must also be linked with -ladt to access priority queue
/*****************************************************************/
//
// The A* Search Algorithm finds the shortest path between any
// two nodes.  It is a best-search-first algorithm, meaning it
// pursues paths of lowest cost first.  This implementation of A*
// uses the heap implementation from the Abstract Data Types
// library as a priority queue.  Each path is stored as an 8-byte
// block, which is dynamically allocated by A* functions through
// the usual u_malloc() and u_free() functions (see the wiki topic
// on memory allocation for details if you are unfamiliar with
// how z88dk libraries implicitly allocate dynamic memory).
//
// To use A*, you must provide functions with the following
// signatures:
//
// a. void [[]] astar_TestAndClose(uint node);
//
//    Mark the node as 'closed' and return carry flag set
//    if the node was already closed previously.  C functions
//    should make use of the special z88dk keywords return_c()
//    and return_nc() to exit with known carry flag state.
//
// b. void astar_Successor(uint *node, uint *cost);
//
//    This function enumerates all the neighbours of node, one
//    after the other on successive calls.  With node not -1, a
//    new start node is indicated.  If node is -1, the next
//    neighbour of the last valid node supplied should be returned.
//    This function indicates to the algorithm the connectivity
//    of the map.
//
//    If node is not -1, write into node its first neighbour
//    and the cost of moving from that node to this neighbour
//    into cost.
//
//    If node is -1, write the next neighbour into node and the
//    cost of moving from the last valid node to this neighbour
//    into cost.
//
//    Return with carry flag set when there are no more neighbours
//    and reset if the neighbour returned is valid.  C functions
//    should use the z88dk keywords return_c() and return_c()
//    to exit with known carry flag state.
//
// c. uint [[]] astar_DestCost(uint node)
//
//    (optional) Estimate the cost from the node indicated to
//    the destination node.  These nodes may be widely separated
//    so a cartesian distance metric is probably simplest.
//
//    This function is only called by astar_EstimateBestPath().
//    If astar_EstimateBestPath() is not used, this function need
//    not be defined.
//
// Prior to calling the A* search algorithm, function pointers
// must be declared globally and assigned to point at the above
// function implementations:
//
// void *astar_TestAndClose, *astar_Successor, *astar_DestCost;
//
// Additionally a number of variables A* uses must be declared
// globally and initialized:
//
// uint astar_startNode;   /* init to starting node              */
// uint astar_destNode;    /* init to finish node                */
//
// void **astar_queue;     /* address of array of 2-byte entries */
// uint astar_queueSize;   /* max num entries available in array */
// uint astar_queueN;      /* no init necessary                  */
//
// A* uses the Abstract Data Type library's heap data type to
// implement the priority queue.  The latter three variables
// indicate the location of a static array to use for the heap,
// the max size of the heap, and the current number of entries
// in the heap.  See the ADT library documentation for more
// details.
//

struct astar_path {                //  7 bytes

   uint               node;        // +0 last node of this path
   uchar              ref_count;   // +2 reference count for this path
   struct astar_path *prefix;      // +3 path leading to this node
   uint               cost;        // +5 cost of this path 0-65535

};

extern struct astar_path __LIB__              *astar_Search(void);
extern struct astar_path __LIB__  *astar_SearchResume(struct astar_path *p) __z88dk_fastcall;
extern struct astar_path __LIB__  *astar_EstimateBestPath(struct astar_path *p) __z88dk_fastcall;
extern uint              __LIB__   astar_PathLength(struct astar_path *p) __z88dk_fastcall;
extern uint              __LIB__              *astar_WalkPath(struct astar_path *p, uint *node_arr, uint n) __smallc;
extern uint              __LIB__    *astar_WalkPath_callee(struct astar_path *p, uint *node_arr, uint n) __smallc __z88dk_callee;
extern void              __LIB__   astar_DeletePath(struct astar_path *p) __z88dk_fastcall;
extern void              __LIB__   astar_CleanUp(struct astar_path *p) __z88dk_fastcall;

#define astar_WalkPath(a,b,c) astar_WalkPath_callee(a,b,c)

#endif
