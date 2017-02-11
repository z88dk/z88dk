#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test strhash.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -Wall -otest test.c strhash.c class.c alloc.c strpool.c str.c dbg.c";

write_file("test.c", <<'END');
#include "strhash.h"
#include <assert.h>

#define ERROR die("Test failed at line %d\n", __LINE__)

void _check_list (StrHash *hash, char *expected, char *file, int lineno)
{
	StrHashElem *iter, *elem;
	char tokens[256], wrong_key[256], *tokensp;
	char *exp_key, *exp_value, *value;
	int i;
	void *next_elem;
	
	/* strtok cannot modify constant strings */
	strcpy(tokens, expected);
	tokensp = tokens;
	
	for ( i = 0, iter = StrHash_first(hash); ; i++, iter = StrHash_next(iter) )
	{
		next_elem = iter ? iter->value : NULL;
		
		/* next expected key */
		exp_key = strtok(tokensp, " "); 
		tokensp = NULL;
		
		if (exp_key == NULL && next_elem)
		{
			die("%s %d : got %s, expected end of hash\n", 
			    file, lineno, iter->key);
		}
		else if (exp_key != NULL && ! next_elem)
		{
			die("%s %d : got end of hash, expected %s\n", 
			    file, lineno, exp_key);
		}
		else if (exp_key == NULL && ! next_elem)
		{
			break;		/* OK */
		}
		
		/* get expected value */
		exp_value = strtok(tokensp, " ");
		if (exp_value == NULL)
		{
			die("%s %d : exp_value should not be NULL\n", 
			    file, lineno);
		}
				
		/* check that key and value match */
		if (strcmp(iter->key, exp_key))
		{
			die("%s %d : key mismatch, got %s, expected %s\n", 
			    file, lineno, iter->key, exp_key);
		}
		
		if (strcmp((char *)(iter->value), exp_value))
		{
			die("%s %d : value mismatch, got %s, expected %s\n", 
			    file, lineno, (char *)(iter->value), exp_value);
		}
		
		if (iter->value != next_elem)
		{
			die("%s %d : value pointer mismatch\n", 
			    file, lineno);
		}
		
		/* compute wrong key */
		strcpy(wrong_key, iter->key);
		(*wrong_key)++;

		/* check positive and negative StrHash_get() */
		value = StrHash_get(hash, iter->key);
		if (value == NULL || strcmp(value, (char *)(iter->value)))
		{
			die("%s %d : get(%s) = %s, expected %s\n", 
			    file, lineno, iter->key, value, (char *)(iter->value));
		}

		value = StrHash_get(hash, wrong_key);
		if (value != NULL)
		{
			die("%s %d : get(%s) = %s, expected NULL\n", 
			    file, lineno, wrong_key, value);
		}
		
		/* check positive and negative StrHash_exists() */
		if ( ! StrHash_exists(hash, iter->key) )
		{
			die("%s %d : exists(%s) = FALSE, expected TRUE\n", 
			    file, lineno, iter->key);
		}

		if ( StrHash_exists(hash, wrong_key) )
		{
			die("%s %d : exists(%s) = TRUE, expected FALSE\n", 
			    file, lineno, wrong_key);
		}
		
		/* check positive and negative StrHash_find() */
		elem = StrHash_find(hash, iter->key);
		if ( elem == NULL || elem != iter )
		{
			die("%s %d : find(%s) failed\n", 
			    file, lineno, iter->key);
		}

		elem = StrHash_find(hash, wrong_key);
		if ( elem != NULL )
		{
			die("%s %d : find(%s) failed\n", 
			    file, lineno, wrong_key);
		}
	}
	
	/* check count */
	if ( hash != NULL && (size_t) i != hash->count )
		die("%s %d : count is %d, expected %d\n", file, lineno, hash->count, i);
}

#define check_list(hash,expected) _check_list(hash,expected,__FILE__,__LINE__)

int ascending (StrHashElem *a, StrHashElem *b)
{
	return strcmp((char*)(a->value), (char*)(b->value));
}

int descending (StrHashElem *a, StrHashElem *b)
{
	return strcmp((char*)(b->value), (char*)(a->value));
}

/* reuse string - test saving of keys by hash */
char *S(char *str)
{
	static char buffer[MAXLINE];
	
	strcpy(buffer, str);		/* overwrite last string */
	return buffer;
}

int main()
{
	StrHash *hash1, *hash2;
	StrHashElem *elem;
	
	/* no init */
	hash1 = NULL;

	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "abc 123");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456");
	
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456 ghi 789");

	OBJ_DELETE( hash1 );
	
	
	/* init object */
	hash1 = OBJ_NEW(StrHash);
	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "abc 123");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456");
	
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "abc 123 def 456 ghi 789");
	

	/* clone */
	hash2 = StrHash_clone(hash1);
	check_list(hash1, "abc 123 def 456 ghi 789");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove(hash1, S("def"));
	check_list(hash1, "abc 123 ghi 789");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove(hash1, S("def"));
	check_list(hash1, "abc 123 ghi 789");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove(hash1, S("ghi"));
	check_list(hash1, "abc 123");
	check_list(hash2, "abc 123 def 456 ghi 789");

	StrHash_remove(hash1, S("abc"));
	check_list(hash1, "");
	check_list(hash2, "abc 123 def 456 ghi 789");

	StrHash_remove_all(hash1);
	check_list(hash1, "");
	check_list(hash2, "abc 123 def 456 ghi 789");
	
	StrHash_remove_all(hash2);
	check_list(hash1, "");
	check_list(hash2, "");
	
	
	/* head / remove_elem */
	StrHash_set(&hash1, S("abc"), "123");
	StrHash_set(&hash1, S("def"), "456");
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");

	elem = StrHash_first(hash1); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "abc")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "def 456 ghi 789");

	elem = StrHash_first(hash1); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "def")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "ghi 789");

	elem = StrHash_first(hash1); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "ghi")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "");

	elem = StrHash_first(hash1); 
	if (elem != NULL) ERROR;
	check_list(hash1, "");

	StrHash_set(&hash1, S("abc"), "123");
	StrHash_set(&hash1, S("def"), "456");
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "abc 123 def 456 ghi 789");

	elem = StrHash_find(hash1, S("def")); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "def")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "abc 123 ghi 789");

	elem = StrHash_find(hash1, S("ghi")); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "ghi")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "abc 123");

	elem = StrHash_find(hash1, S("abc")); 
	if (elem == NULL) ERROR;
	if (strcmp(elem->key, "abc")) ERROR;
	StrHash_remove_elem(hash1, elem);
	check_list(hash1, "");

	elem = StrHash_find(hash1, S("abc")); 
	if (elem != NULL) ERROR;
	check_list(hash1, "");
	
	/* empty */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	
	if (! StrHash_empty(hash1)) ERROR;
	
	StrHash_set(&hash1, S("abc"), "123");
	
	if (StrHash_empty(hash1)) ERROR;
	
	
	/* sort */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "def 456");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "def 456 abc 123");
	
	StrHash_set(&hash1, S("ghi"), "789");
	check_list(hash1, "def 456 abc 123 ghi 789");
	
	StrHash_set(&hash1, S("def"), "457");
	check_list(hash1, "def 457 abc 123 ghi 789");
	
	StrHash_sort(hash1, ascending);
	check_list(hash1, "abc 123 def 457 ghi 789");
	
	StrHash_sort(hash1, descending);
	check_list(hash1, "ghi 789 def 457 abc 123");
	

	/* case-insensitive */
	hash1 = OBJ_NEW(StrHash);
	hash1->ignore_case = TRUE;
	if (StrHash_first(hash1) != NULL)			ERROR;
	check_list(hash1, "");
	
	StrHash_set(&hash1, S("abc"), "123");
	check_list(hash1, "ABC 123");
	
	StrHash_set(&hash1, S("Def"), "456");
	check_list(hash1, "ABC 123 DEF 456");
	
	StrHash_set(&hash1, S("GHI"), "789");
	check_list(hash1, "ABC 123 DEF 456 GHI 789");
	
	StrHash_set(&hash1, S("def"), "456");
	check_list(hash1, "ABC 123 DEF 456 GHI 789");
	
	
	/* free_data */
	OBJ_DELETE(hash1);
	hash1 = OBJ_NEW(StrHash);
	hash1->free_data = m_free_compat;
	
	StrHash_set(&hash1, "abc", m_strdup("123"));
	check_list(hash1, "abc 123");

	StrHash_set(&hash1, "def", m_strdup("456"));
	check_list(hash1, "abc 123 def 456");

	StrHash_set(&hash1, "abc", m_strdup("789"));
	check_list(hash1, "abc 789 def 456");
	
	StrHash_set(&hash1, "ghi", m_strdup("012"));
	check_list(hash1, "abc 789 def 456 ghi 012");
	
	StrHash_remove(hash1, "ghi");
	check_list(hash1, "abc 789 def 456");
	
	return 0;
}
END

system($compile) and die "compile failed: $compile\n";
t_capture("./test", "", "", 0);

unlink <test.*>;
done_testing;

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}
