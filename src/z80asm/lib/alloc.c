/*
Z88DK Z80 Macro Assembler

Alloc library.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "dbg.h"
#include "init.h"
#include "types.h"
#include "utlist.h"
#include <stddef.h>

/*-----------------------------------------------------------------------------
*   Memory Block - allocated before the actual buffer requested by the user
*   keeps linked list of all allocated blocks to be freed at exit
*----------------------------------------------------------------------------*/
#define FENCE_SIZE      MAX( sizeof(long), sizeof(void*) )
#define FENCE_SIGN      0xAA
#define MEMBLOCK_SIGN   0x5A5A5A5A

typedef struct MemBlock {
	struct MemBlock *next, *prev;	/* Double-linked list of blocks */

    int 		signature;			/* contains MEMBLOCK_SIGN to assure we found a block */
	destructor_t destructor;		/* desctructor function called by m_free_() to 
									   destroy children */
	struct {
		Bool in_collection   :1;	/* TRUE if part of collection, deleted last */
		Bool destroy_atextit :1;	/* TRUE to shut up memory leak warning */
	} flags;

    size_t		client_size;		/* size requested by client */
    char	   *file;				/* source where allocated */
    int			lineno;				/* line number where allocated */

    char		fence[FENCE_SIZE];	/* fence to detect underflow */

    /* client data starts here with client_size bytes + FENCE_SIZE fence */

} MemBlock;

/*-----------------------------------------------------------------------------
*   Global data
*----------------------------------------------------------------------------*/

/* list of all allocated memory */
static MemBlock *g_mem_blocks = NULL;

static char g_fence[ FENCE_SIZE ];	/* keep signature */

/*-----------------------------------------------------------------------------
*   Macros to convert addresses
*----------------------------------------------------------------------------*/

/* convert from MemBlock area to client area */
#define CLIENT_PTR(block)   ((block)->fence + FENCE_SIZE)
#define CLIENT_SIZE(block)  ((block)->client_size)

/* convert client block and size to MemBlock and total size */
#define BLOCK_PTR(ptr)      ((MemBlock *) (((char*) (ptr)) \
							 - offsetof(struct MemBlock, fence) - FENCE_SIZE))
#define BLOCK_SIZE(size)    ((size) + sizeof(MemBlock) + FENCE_SIZE)

/* address of both fences */
#define START_FENCE_PTR(block)  ((block)->fence)
#define END_FENCE_PTR(block)    (CLIENT_PTR(block) + (block)->client_size)

/*-----------------------------------------------------------------------------
*   Initialize and terminate functions
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
    memset( g_fence, FENCE_SIGN, FENCE_SIZE );
}

/* return next block to free; search backwards, first not in collection, 
   then in collection, return NULL at the end */
static MemBlock *next_to_free(void)
{
	MemBlock *block;
	int count;

	/* not in collection */
	DL_FOREACH(g_mem_blocks, block) {
		check_node(block);
		if (!block->flags.in_collection)
			return block;
	}

	/* all the others */
	DL_FOREACH(g_mem_blocks, block) {
		check_node(block);
		return block;
	}

	DL_COUNT(g_mem_blocks, block, count);
	check(count == 0, "%d blocks not freed", count);

error:
	return NULL;
}

DEFINE_dtor_module()
{
    MemBlock *block, *block_count;
	void *memptr;
	int count1, count2;

    /* delete all existing blocks in reverse order */
    while ( (block = next_to_free()) != NULL ) {
		DL_COUNT(g_mem_blocks, block_count, count1);

		/* skip memory leak warning if declared to destroy at exit */
		if ( ! block->flags.destroy_atextit )
			log_warn("memory leak (%u bytes) allocated at %s:%d",
					 (unsigned)block->client_size, block->file ? block->file : "(null)", block->lineno );

		/* delete from g_mem_blocks */
        memptr = CLIENT_PTR(block);
		m_free( memptr );

		/* assert that block was freed */
		DL_COUNT(g_mem_blocks, block_count, count2);
		check(count2 < count1, "block not freed");
    }
error: ;
}

void m_alloc_init( void )
{
    init_module();
}

/*-----------------------------------------------------------------------------
*   Create a new MemBlock, return NULL on out of memory
*----------------------------------------------------------------------------*/
static MemBlock *new_block( size_t client_size, char *file, int lineno )
{
    MemBlock *block;
    size_t    block_size;

    /* create memory to hold MemBlock + client area + fence */
    block_size = BLOCK_SIZE( client_size );

    block = malloc( block_size );
	check( block, 
		   "memory alloc (%u bytes) failed at %s:%d", (unsigned)client_size, file, lineno );

    /* init block */
    block->signature   = MEMBLOCK_SIGN;
	block->destructor  = NULL;
	block->flags.in_collection	 = FALSE;
	block->flags.destroy_atextit = FALSE;
    block->client_size = client_size;
    block->file        = file;
    block->lineno      = lineno;

    /* fill fences */
    memset( START_FENCE_PTR( block ), FENCE_SIGN, FENCE_SIZE );
    memset( END_FENCE_PTR( block ),   FENCE_SIGN, FENCE_SIZE );

    /* add to list of blocks in reverse order, so that cleanup is reversed */
	DL_PREPEND(g_mem_blocks, block);

    return block;
	
error:
	return NULL;
}

/*-----------------------------------------------------------------------------
*   Find a block via client ptr, return NULL if not found
*----------------------------------------------------------------------------*/
static MemBlock *find_block_no_warn( void *memptr )
{
    MemBlock *block = BLOCK_PTR( memptr );
	if ( block->signature == MEMBLOCK_SIGN )
		return block;
	else
		return NULL;
}

static MemBlock *find_block( void *memptr, char *file, int lineno )
{
    MemBlock *block = find_block_no_warn( memptr );
	check( block, "memory block not found at %s:%d", file, lineno );
    return block;
	
error:
	return NULL;
}

Bool m_is_managed( void *memptr )
{
	return find_block_no_warn( memptr ) ? TRUE : FALSE;
}

/*-----------------------------------------------------------------------------
*   Check block fence, return FALSE on error
*----------------------------------------------------------------------------*/
static Bool check_fences( MemBlock *block )
{
    /* check fences */
	check( memcmp( g_fence, START_FENCE_PTR( block ), FENCE_SIZE ) == 0,
		   "buffer underflow, memory allocated at %s:%d", block->file, block->lineno );

	check( memcmp( g_fence, END_FENCE_PTR( block ), FENCE_SIZE ) == 0,
		   "buffer overflow, memory allocated at %s:%d", block->file, block->lineno );
	return TRUE;
	
error:
	return FALSE;
}

/*-----------------------------------------------------------------------------
*   malloc, calloc, strdup
*----------------------------------------------------------------------------*/
static void *m_alloc( size_t size, int fill, char *source, char *file, int lineno )
{
    MemBlock *block;
    void     *memptr;

    init_module();

    block = new_block( size, file, lineno );
	check_mem( block );

    memptr = CLIENT_PTR( block );

	if ( fill >= 0 ) {		/* calloc */
		memset( memptr, fill, size );
	}
	else if ( source ) {	/* strdup */
		strcpy( (char *)memptr, source );
	}
	else {					/* malloc */
	}
		
    return memptr;
	
error:
	return NULL;
}

void *m_malloc_compat( size_t size ) 
{ 
	return m_malloc_(size, __FILE__, __LINE__); 
}

void *m_malloc_( size_t size, char *file, int lineno )
{
	return m_alloc( size, -1, NULL, file, lineno );
}

void *m_calloc_compat( size_t num, size_t size )
{
	return m_calloc_( num, size, __FILE__, __LINE__ );
}

void *m_calloc_( size_t num, size_t size, char *file, int lineno )
{
	return m_alloc( num * size, 0, NULL, file, lineno );
}

char *m_strdup_compat( char *source )
{
	return m_strdup_( source, __FILE__, __LINE__ );
}

char *m_strdup_( char *source, char *file, int lineno )
{
	return (char *)m_alloc( strlen(source) + 1, -1, source, file, lineno );
}

/*-----------------------------------------------------------------------------
*   realloc
*----------------------------------------------------------------------------*/
void *m_realloc_( void *memptr, size_t size, char *file, int lineno )
{
    MemBlock *block, *next_block;
	Bool 	  result;

    init_module();

    /* if input is NULL, behave as malloc */
    if ( memptr == NULL )
        return m_malloc_( size, file, lineno );

    /* find the block */
    block = find_block( memptr, file, lineno );
	check( block, "memory realloc (%u bytes) failed at %s:%d", (unsigned)size, file, lineno );

    /* delete from list as realloc may move block */
	next_block = block->next;		/* remember position */
	DL_DELETE(g_mem_blocks, block);

    /* check fences */
    result = check_fences( block );
	check( result, "memory realloc (%u bytes) failed at %s:%d", (unsigned)size, file, lineno );

    /* reallocate and create new end fence */
    block = realloc( block, BLOCK_SIZE( size ) );
	check( block, "memory realloc (%u bytes) failed at %s:%d", (unsigned)size, file, lineno );
	
    /* update block */
    block->client_size = size;
    block->file        = file;
    block->lineno      = lineno;

    /* fill end fence */
    memset( END_FENCE_PTR( block ), FENCE_SIGN, FENCE_SIZE );

    /* add to list at the same location as before */
	if (next_block == NULL)
		DL_APPEND(g_mem_blocks, block);
	else
		DL_PREPEND_ELEM(g_mem_blocks, next_block, block);

    return CLIENT_PTR( block );

error:
	return NULL;
}

void *m_realloc_compat( void *memptr, size_t size )
{
	return m_realloc_( memptr, size, __FILE__, __LINE__ );
}

/*-----------------------------------------------------------------------------
*   free
*----------------------------------------------------------------------------*/
void m_free_( void *memptr, char *file, int lineno )
{
    MemBlock *block = NULL;
	Bool result;
	
    init_module();

    /* if input is NULL, do nothing */
    if ( memptr == NULL )
        return;

    block = find_block( memptr, file, lineno );
	check( block, "memory free at %s:%d failed", file, lineno );
	
    /* delete from list to avoid recursion atexit() if overflow */
	DL_DELETE(g_mem_blocks, block );

    /* check fences */
    result = check_fences( block );
	check( result, "memory free at %s:%d failed", file, lineno );

error:
    /* delete memory blocks */
	if ( block ) {
		if ( block->destructor )			/* destroy children */
			block->destructor( memptr );	/* user destructor */

		free( block );						/* destroy itself */
	}
}

void m_free_compat( void *memptr )
{
	m_free_( memptr, __FILE__, __LINE__ );
}

/*-----------------------------------------------------------------------------
*   Destructors
*----------------------------------------------------------------------------*/
void *m_set_destructor_( void *memptr, destructor_t destructor, char *file, int lineno )
{
    MemBlock *block;

    block = find_block( memptr, file, lineno );
	check( block, "m_set_destructor at %s:%d failed", file, lineno );

	block->destructor = destructor;

error: 
	return memptr;
}

void *m_set_in_collection_( void *memptr, Bool in_collection, char *file, int lineno )
{
    MemBlock *block;

    block = find_block( memptr, file, lineno );
	check( block, "m_%s_in_collection at %s:%d failed", in_collection ? "set" : "clear", file, lineno );

	block->flags.in_collection = in_collection;

error: 
	return memptr;
}

void *m_destroy_atexit_( void *memptr, char *file, int lineno )
{
    MemBlock *block;

    block = find_block( memptr, file, lineno );
	check( block, "m_destroy_atexit at %s:%d failed", file, lineno );

	block->flags.destroy_atextit = TRUE;

error: 
	return memptr;
}
