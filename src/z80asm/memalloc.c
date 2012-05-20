/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2012

Memory allocation routines with automatic garbage collection on exit,
Simple fence mechanism and exception thrown on out of memory.
Only works for memory allocated by xmalloc and freed by xfree.
Use MS Visual Studio malloc debug for any allocation not using xmalloc/xfree
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/memalloc.c,v 1.5 2012-05-20 06:39:27 pauloscustodio Exp $ */
/* $Log: memalloc.c,v $
/* Revision 1.5  2012-05-20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.4  2012/05/20 06:02:09  pauloscustodio
/* Garbage collector
/* Added automatic garbage collection on exit and simple fence mechanism
/* to detect buffer underflow and overflow, to memalloc functions.
/* No longer needed to call init_malloc().
/* No longer need to try/catch during creation of memory structures to
/* free partially created data - all not freed data is freed atexit().
/* Renamed xfree0() to xfree().
/*
/* Revision 1.3  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.2  2011/08/05 19:49:13  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* New memory allocation functions xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated.
/* New xfree0() macro which only frees if the pointer in non-null, and
/* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
/*
/* Revision 1.1  2011/07/18 00:43:35  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include "types.h"
#include "die.h"
#include "queue.h"

#include <stdlib.h>
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Memory Block - allocated before the actual buffer requested by the user
*   keeps linked list of all allocated blocks to be freed at exit
*----------------------------------------------------------------------------*/
#define FENCE_SIZE      sizeof(void*)
#define FENCE_SIGN      0xAA
#define MEMBLOCK_SIGN   0x5A5A5A5A

typedef struct MemBlock
{
    int signature;                  /* contains MEMBLOCK_SIGN to make sure we found
                                       a block */
    size_t  client_size;            /* size requested by client */
    char    *file;                  /* source where allocated */
    int     lineno;                 /* line number where allocated */

    LIST_ENTRY( MemBlock ) entries; /* Double-linked list of blocks */

    char    fence[FENCE_SIZE];      /* fence to detect underflow */

    /* client data starts here with client_size bytes + FENCE_SIZE fence */

} MemBlock;

/* list of all allocated memory */
static LIST_HEAD( MemBlockList, MemBlock ) mem_blocks = LIST_HEAD_INITIALIZER( mem_blocks );

/* convert from MemBlock area to client area */
#define CLIENT_PTR(block)   ((block)->fence + FENCE_SIZE)
#define CLIENT_SIZE(block)  ((block)->client_size)

/* convert client block and size to MemBlock and total size */
#define BLOCK_PTR(ptr)      ((MemBlock *) (((char*) (ptr)) - sizeof(MemBlock)))
#define BLOCK_SIZE(size)    ((size) + sizeof(MemBlock) + FENCE_SIZE)

/* address of both fences */
#define START_FENCE_PTR(block)  ((block)->fence)
#define END_FENCE_PTR(block)    (CLIENT_PTR(block) + (block)->client_size)

/*-----------------------------------------------------------------------------
*   error messages
*----------------------------------------------------------------------------*/
static char msg_init[] =            "memalloc: init\n";
static char msg_cleanup[] =         "memalloc: cleanup\n";
static char msg_alloc_failed[] =    "memalloc %s(%d): alloc %u bytes failed\n";
static char msg_unmatched_block[] = "memalloc %s(%d): block not found\n";
static char msg_buffer_underflow[] = "memalloc %s(%d): buffer underflow, "
                                     "memory allocated at %s(%d)\n";
static char msg_buffer_overflow[] = "memalloc %s(%d): buffer overflow, "
                                    "memory allocated at %s(%d)\n";
static char msg_new_alloc[] =       "memalloc %s(%d): alloc %u bytes at 0x%p\n";
static char msg_delete_alloc[] =    "memalloc %s(%d): free %u bytes at 0x%p "
                                    "allocated at %s(%d)\n";

/*-----------------------------------------------------------------------------
*   cleanup atexit()
*----------------------------------------------------------------------------*/
static void cleanup( void )
{
    MemBlock *block;

#ifdef MEMALLOC_DEBUG
    warn( msg_cleanup );
#endif

    /* delete all existing blocks */
    while ( ! LIST_EMPTY( &mem_blocks ) )
    {
        block = LIST_FIRST( &mem_blocks );
        _xfree( CLIENT_PTR( block ), __FILE__, __LINE__ );  /* deletes from list */
    }
}

/*-----------------------------------------------------------------------------
*   setup atexit(), error reporting in Visual Studio
*----------------------------------------------------------------------------*/
#define REPORT_STDERR(reportType)   \
    _CrtSetReportMode(reportType, _CRTDBG_MODE_FILE | _CRTDBG_MODE_DEBUG); \
    _CrtSetReportFile(reportType, _CRTDBG_FILE_STDERR )

static void init( void )
{
    static bool initialized = FALSE;

    if ( ! initialized )
    {
#ifdef MEMALLOC_DEBUG
        warn( msg_init );
#endif

        /* make sure the exceptions are initialized */
        init_except();

#ifdef _CRTDBG_MAP_ALLOC        /* MS Visual Studio malloc debug */
        _CrtSetDbgFlag( _CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF );
        REPORT_STDERR( _CRT_WARN );
        REPORT_STDERR( _CRT_ERROR );
        REPORT_STDERR( _CRT_ASSERT );

        /* _CrtSetBreakAlloc(86);       /* break on allocation Nr. XX */
#endif

        atexit( cleanup );

        initialized = TRUE;
    }
}
#undef REPORT_STDERR

/*-----------------------------------------------------------------------------
*   Create a new MemBlock
*----------------------------------------------------------------------------*/
static MemBlock *new_block( size_t client_size, char *file, int lineno )
{
    MemBlock *block;
    size_t   block_size;

    /* create memory to hold MemBlock + client area + fence */
    block_size = BLOCK_SIZE( client_size );
    block      = malloc( block_size );

    if ( block == NULL )
    {
        die( NotEnoughMemoryException,
             msg_alloc_failed, file, lineno, block_size );
        /* not reached */
    }

    /* init block */
    block->signature   = MEMBLOCK_SIGN;
    block->client_size = client_size;
    block->file        = file;
    block->lineno      = lineno;

    /* fill fences */
    memset( START_FENCE_PTR( block ), FENCE_SIGN, FENCE_SIZE );
    memset( END_FENCE_PTR( block ),   FENCE_SIGN, FENCE_SIZE );

    /* add to list of blocks in reverse order, so that cleanup is reversed */
    LIST_INSERT_HEAD( &mem_blocks, block, entries );

#ifdef MEMALLOC_DEBUG
    warn( msg_new_alloc, block->file, block->lineno,
          CLIENT_SIZE( block ), CLIENT_PTR( block ) );
#endif

    return block;
}

/*-----------------------------------------------------------------------------
*   Find a block via client ptr, exit if not found
*----------------------------------------------------------------------------*/
static MemBlock *find_block( void *client_ptr, char *file, int lineno )
{
    MemBlock *block;

    block = BLOCK_PTR( client_ptr );

    if ( block->signature != MEMBLOCK_SIGN )
    {
        die( AssertionException,
             msg_unmatched_block, file, lineno );
        /* not reached */
    }

    return block;
}

/*-----------------------------------------------------------------------------
*   Check block fence
*----------------------------------------------------------------------------*/
static void check_fences( MemBlock *block, char *file, int lineno )
{
    char fence[FENCE_SIZE];

    memset( fence, FENCE_SIGN, FENCE_SIZE );

    /* check fences */
    if ( 0 != memcmp( fence, START_FENCE_PTR( block ), FENCE_SIZE ) )
    {
        die( AssertionException,
             msg_buffer_underflow, file, lineno, block->file, block->lineno );
        /* not reached */
    }

    if ( 0 != memcmp( fence, END_FENCE_PTR( block ), FENCE_SIZE ) )
    {
        die( AssertionException,
             msg_buffer_overflow, file, lineno, block->file, block->lineno );
        /* not reached */
    }
}

/*-----------------------------------------------------------------------------
*   xmalloc
*----------------------------------------------------------------------------*/
void *_xmalloc( size_t client_size, char *file, int lineno )
{
    MemBlock *block;

    init();             /* setup if first time */

    block = new_block( client_size, file, lineno );
    return CLIENT_PTR( block );
}

/*-----------------------------------------------------------------------------
*   xfree
*----------------------------------------------------------------------------*/
void _xfree( void *client_ptr, char *file, int lineno )
{
    MemBlock *block;

    init();             /* setup if first time */

    /* if input is NULL, do nothing */
    if ( client_ptr == NULL )
    {
        return;
    }

    block = find_block( client_ptr, file, lineno );

#ifdef MEMALLOC_DEBUG
    warn( msg_delete_alloc, file, lineno,
          CLIENT_SIZE( block ), CLIENT_PTR( block ),
          block->file, block->lineno );
#endif

    /* delete from list to avoid recursion atexit() if overflow */
    LIST_REMOVE( block, entries );

    /* check fences */
    check_fences( block, file, lineno );

    /* delete memory blocks */
    free( block );
}

/*-----------------------------------------------------------------------------
*   xcalloc
*----------------------------------------------------------------------------*/
void *_xcalloc( int num, size_t size, char *file, int lineno )
{
    MemBlock *block;
    size_t   client_size;
    void     *client_ptr;

    init();             /* setup if first time */

    client_size = num * size;
    block       = new_block( client_size, file, lineno );
    client_ptr  = CLIENT_PTR( block );

    memset( client_ptr, 0, client_size );

    return client_ptr;
}

/*-----------------------------------------------------------------------------
*   xstrdup
*----------------------------------------------------------------------------*/
char *_xstrdup( char *source, char *file, int lineno )
{
    MemBlock *block;
    size_t   client_size;
    void     *client_ptr;

    init();             /* setup if first time */

    client_size = strlen( source ) + 1;
    block       = new_block( client_size, file, lineno );
    client_ptr  = CLIENT_PTR( block );

    /* copy string */
    strcpy( client_ptr, source );

    return client_ptr;
}

/*-----------------------------------------------------------------------------
*   xrealloc
*----------------------------------------------------------------------------*/
void *_xrealloc( void *client_ptr, size_t client_size, char *file, int lineno )
{
    MemBlock *block;
    size_t   block_size;

    init();             /* setup if first time */

    /* if input is NULL, behave as malloc */
    if ( client_ptr == NULL )
    {
        return _xmalloc( client_size, file, lineno );
    }

    /* find the block */
    block = find_block( client_ptr, file, lineno );

#ifdef MEMALLOC_DEBUG
    warn( msg_delete_alloc, file, lineno,
          CLIENT_SIZE( block ), CLIENT_PTR( block ),
          block->file, block->lineno );
#endif

    /* delete from list as realloc may move block */
    LIST_REMOVE( block, entries );

    /* check fences */
    check_fences( block, file, lineno );

    /* reallocate and create new end fence */
    block_size = BLOCK_SIZE( client_size );
    block      = realloc( block, block_size );

    if ( block == NULL )
    {
        die( NotEnoughMemoryException,
             msg_alloc_failed, file, lineno, block_size );
        /* not reached */
    }

    client_ptr = CLIENT_PTR( block );

    /* update block */
    block->client_size = client_size;
    block->file        = file;
    block->lineno      = lineno;

    /* fill end fence */
    memset( END_FENCE_PTR( block ),   FENCE_SIGN, FENCE_SIZE );

    /* add to list of blocks in reverse order, so that cleanup is reversed */
    LIST_INSERT_HEAD( &mem_blocks, block, entries );

#ifdef MEMALLOC_DEBUG
    warn( msg_new_alloc, block->file, block->lineno,
          CLIENT_SIZE( block ), CLIENT_PTR( block ) );
#endif

    return client_ptr;
}
