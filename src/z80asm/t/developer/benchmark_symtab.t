#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/developer/benchmark_symtab.t,v 1.17 2014-01-11 01:29:50 pauloscustodio Exp $
# $Log: benchmark_symtab.t,v $
# Revision 1.17  2014-01-11 01:29:50  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.16  2014/01/02 17:18:17  pauloscustodio
# StrList removed, replaced by List
#
# Revision 1.15  2013/12/30 02:05:34  pauloscustodio
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.14  2013/12/26 23:42:28  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.13  2013/12/25 17:02:10  pauloscustodio
# Move strhash.c to the z80asm/lib directory
#
# Revision 1.12  2013/12/25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.11  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.10  2013/12/15 20:30:38  pauloscustodio
# Move except.c to the z80asm/lib directory
#
# Revision 1.9  2013/12/15 19:01:07  pauloscustodio
# Move platform specific defines from types.h to config.h.
# Remove dependency of types.h from glib.h.
# Use NUM_ELEMS() instead of glib G_N_ELEMENTS().
#
# Revision 1.8  2013/12/15 13:18:43  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.7  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.6  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.5  2013/09/22 21:04:21  pauloscustodio
# New File and FileStack objects
#
# Revision 1.4  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with glib functions
#
# Revision 1.3  2013/09/01 18:45:35  pauloscustodio
# Remove NUM_ELEMS, use G_N_ELEMENTS instead (from glib.h)
# Remove FALSE, TRUE, MIN, MAX; defined in glib.h
#
# Revision 1.2  2013/05/23 22:07:44  pauloscustodio
# replace symbol* by Symbol*
#
# Revision 1.1  2013/05/23 21:45:24  pauloscustodio
# Benchmark hashtable vs avltree for symbol table
#
#
# Compare performance of hash table and avltree as symbol storage on a code example

use Modern::Perl;
use Test::More;
use List::AllUtils 'uniq';
require 't/test_utils.pl';

my $objs = "avltree.o lib/xmalloc.o lib/die.o lib/except.o lib/strutil.o lib/list.o  errors.o strpool.o lib/strhash.o lib/class.o file.o";
my $src = "t/data/zx48.asm";
my @words;

# get all words from zx82 source file
ok open(my $fh, "<", "$src"), "open $src";
while (<$fh>) {
	s/'.'/ /gi;
	s/"[^"]+"/ /gi;
	if (/^;;\s*(\S+)/) {
		my $word = $1;
		$word =~ s/\W/_/g;
		push @words, uc($word);
		next;
	}
	s/;.*/ /gi;
	s/^#.*/ /gi;
	s/%[01]+/ /gi;
	s/\$[0-9a-f]+/ /gi;
	s/\b\d[0-9a-f]*H\b/ /gi;
	s/\b\d+\b/ /gi;
	
	push @words, uc($1) while /\b([a-z_]\w*)\b/gi;
}
my @uniq = uniq(@words);
ok scalar(@uniq), "Found ".scalar(@uniq)." words used ".scalar(@words)." times";

my $init = <<'END';
#include "sym.h"
#include "symbols.h"
#include <time.h>

#define LOOPS	10000

char *words[] = {
<WORDS>,
	NULL
};

int cmpid( Symbol *kptr, Symbol *p )
{
    return strcmp( kptr->name, p->name );
}

int cmpname( char *name, Symbol *p )
{
    return strcmp( name, p->name );
}

Symbol *FindSymbol2( char *name, avltree *treeptr )
{
	return treeptr == NULL ? NULL : 
			find( treeptr, name, ( int ( * )( void *, void * ) ) cmpname );
}

void FreeSym2( Symbol *node )
{
    if ( node->references != NULL )
    {
		OBJ_DELETE( node->references );
    }

    xfree( node );               /* then release the symbol record */
}


avltree *avlroot = NULL;
StrHash *hashroot = NULL;

void add_avltree(char *name)
{
    Symbol *foundsymbol;
	
	foundsymbol = FindSymbol2( name, avlroot );
	if ( foundsymbol != NULL )
	{
		foundsymbol->value++;
	}
	else
	{
		foundsymbol = xnew(Symbol);
		foundsymbol->name = name;
		foundsymbol->value = 0;
		insert( &avlroot, foundsymbol, ( int ( * )( void *, void * ) ) 		 cmpid );
	}
}

void test_avltree()
{
	int i, loop;
	time_t start_time, end_time;
	
	time(&start_time);
		for (loop = 0; loop < LOOPS; loop++)
		{
			for (i = 0; words[i]; i++)
			{
				add_avltree(words[i]);
			}
		}
	time(&end_time);
	warn("avltree: %ld s\n", end_time-start_time);
	
	deleteall( &avlroot, ( void ( * )( void * ) ) FreeSym2 );
}

void add_hash(char *name)
{
    Symbol *foundsymbol;
	
	if ( hashroot == NULL )
		hashroot = OBJ_NEW(StrHash);
		
	foundsymbol = (Symbol *)StrHash_get( hashroot, name );
	if ( foundsymbol != NULL )
	{
		foundsymbol->value++;
	}
	else
	{
		foundsymbol = xnew(Symbol);
		foundsymbol->name = name;
		foundsymbol->value = 0;
		StrHash_set( hashroot, name, foundsymbol );
	}
}

void test_hash()
{
	int i, loop;
	time_t start_time, end_time;
    StrHashElem *elem, *tmp;
	
	time(&start_time);
		for (loop = 0; loop < LOOPS; loop++)
		{
			for (i = 0; words[i]; i++)
			{
				add_hash(words[i]);
			}
		}
	time(&end_time);
	warn("hash: %ld s\n", end_time-start_time);

	warn("total source input words: %5d\n", NUM_ELEMS(words));
	warn("total different words:    %5d\n", HASH_COUNT(hashroot->hash));
	
    HASH_ITER( hh, hashroot->hash, elem, tmp )
    {
        xfree(elem->value);
    }
}

END

$init =~ s/<WORDS>/     join(",\n", map {"\t".'"'.$_.'"'} @words) /e;

t_compile_module($init, <<'END', $objs);
	test_avltree();
	test_hash();


	
END

t_run_module([], "", <<'END', 0);
avltree: 32 s
hash: 19 s
total source input words: 19333
total different words:     2326
END

# delete directories and files
unlink_testfiles();
done_testing;
