#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Compare performance of hash table and avltree as symbol storage on a code example

use Modern::Perl;
use Test::More;
use List::AllUtils 'uniq';
require 't/test_utils.pl';

my $objs = "avltree.o lib/alloc.o lib/str.o lib/list.o errors.o error_func.o strpool.o lib/strhash.o lib/class.o";
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
