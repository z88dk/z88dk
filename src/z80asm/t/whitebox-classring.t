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
# Copyright (C) Paulo Custodio, 2011-2013
#

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "class.o";

t_compile_module(<<'END_INIT', <<'END', $objs);

#define ERROR return __LINE__

#include "classring.h"

CLASS(Obj)
	char *string;
END_CLASS;

void Obj_init (Obj *self) 	{ self->string = xnew_n(char, 100); }
void Obj_copy (Obj *self, Obj *other)
							{ self->string = xnew_n(char, 100);
							  strcpy( self->string, other->string); }
void Obj_fini (Obj *self)	{ xfree(self->string); }
void Obj_clear(Obj *self)	{ self->string[0] = 0; }

DEF_CLASS(Obj);

#define MAX_SIZE 5

CLASS_RING(Obj, MAX_SIZE);
DEF_CLASS_RING(Obj);

int _i, _j, _size;
BOOL _empty, _full;
Obj *_obj;

void dump_ring( char *name, ObjRing *ring )
{
	int i, size;
	Obj *obj;
	
	size = G_N_ELEMENTS(ring->queue);

	warn("%s = \"", name);
	for (i = 0; i < size; i++) {
		obj = ObjRing_get(ring, i);
		if (obj == NULL)
			break;
		warn("%s", obj->string);
	}
	warn("\"\n");

	for (i = 0; i < size; i++)
		warn("  %c ", i == ring->first ? '#' : ' ');
	warn("\n");

	for (i = 0; i < size; i++) 
		warn("+-%c-", i == ring->first ? '#' : '-'); 
	warn("+\n");

	for (i = 0; i < size; i++)
		warn("| %1s ", ring->queue[i]->string );
	warn("|\n");

	for (i = 0; i < size; i++) 
		warn("+-%c-", i == ring->last ? '#' : '-'); 
	warn("+\n");

	for (i = 0; i < size; i++)
		warn("  %c ", i == ring->last ? '#' : ' ');
	warn("\n");
}

#define TEST(ring, values)										\
	dump_ring( #ring, ring);									\
	_size = strlen(values); 									\
	_empty = ObjRing_empty(ring);								\
	_full  = ObjRing_full(ring);								\
	ASSERT( _size == 0        ? _empty : ! _empty );			\
	ASSERT( _size == MAX_SIZE ? _full  : ! _full  );			\
																\
	for ( _i = 0 ; _i < _size ; _i++ ) {						\
		_obj = ObjRing_get( ring, _i );							\
		ASSERT( _obj->string[0] == values[_i] );				\
		_j = - _i - 1;											\
		_obj = ObjRing_get( ring, _j );							\
		ASSERT( _obj->string[0] == values[ _size + _j ] );		\
	}															\
	for (        ; _i < _size + 2*MAX_SIZE; _i++ ) {			\
		_obj = ObjRing_get( ring, _i );							\
		ASSERT( _obj == NULL );									\
		_j = - _i - 1;											\
		_obj = ObjRing_get( ring, _j );							\
		ASSERT( _obj == NULL );									\
	}															\

#define ADD(ring, func, value)					\
	warn("%s(\"%s\")\n", #func, value);			\
	_full = ObjRing_full(ring);					\
	_obj = ObjRing_##func(ring);				\
	if (_full)									\
		ASSERT( _obj == NULL );					\
	else {										\
		ASSERT( _obj != NULL );					\
		ASSERT( _obj->string[0] == 0 );			\
		strcpy( _obj->string, value );			\
	}											\
	
#define DROP(ring, func, value)					\
	warn("%s(\"%s\")\n", #func, value);			\
	_empty = ObjRing_empty(ring);				\
	_obj = ObjRing_##func(ring);				\
	if (_empty) 								\
		ASSERT( _obj == NULL );					\
	else										\
		ASSERT( _obj->string[0] == value[0] );	\
	
END_INIT
	/* main */
	ObjRing *ring, *ring2;
	
	warn("start\n");
	
	ring = OBJ_NEW(ObjRing);
	
	TEST(ring, "");
	
	/* push */
	ADD(ring, push, "a");	TEST(ring, "a");
	ADD(ring, push, "b");	TEST(ring, "ab");
	ADD(ring, push, "c");	TEST(ring, "abc");
	ADD(ring, push, "d");	TEST(ring, "abcd");
	ADD(ring, push, "e");	TEST(ring, "abcde");
	ADD(ring, push, "X");	TEST(ring, "abcde");
	ADD(ring, push, "X");	TEST(ring, "abcde");
	
	/* shift */
	DROP(ring, shift, "a");	TEST(ring, "bcde");
	DROP(ring, shift, "b");	TEST(ring, "cde");
	DROP(ring, shift, "c");	TEST(ring, "de");
	DROP(ring, shift, "d");	TEST(ring, "e");
	DROP(ring, shift, "e");	TEST(ring, "");
	DROP(ring, shift, "X");	TEST(ring, "");
	DROP(ring, shift, "X");	TEST(ring, "");
	
	/* unshift */
	ADD(ring, unshift, "a");TEST(ring, "a");
	ADD(ring, unshift, "b");TEST(ring, "ba");
	ADD(ring, unshift, "c");TEST(ring, "cba");
	ADD(ring, unshift, "d");TEST(ring, "dcba");
	ADD(ring, unshift, "e");TEST(ring, "edcba");
	ADD(ring, unshift, "X");TEST(ring, "edcba");
	ADD(ring, unshift, "X");TEST(ring, "edcba");
	
	/* pop */
	DROP(ring, pop, "a");	TEST(ring, "edcb");
	DROP(ring, pop, "b");	TEST(ring, "edc");
	DROP(ring, pop, "c");	TEST(ring, "ed");
	DROP(ring, pop, "d");	TEST(ring, "e");
	DROP(ring, pop, "e");	TEST(ring, "");
	DROP(ring, pop, "X");	TEST(ring, "");
	DROP(ring, pop, "X");	TEST(ring, "");
	
	/* cross-boudary */
	ADD(ring, push, "X");	TEST(ring, "X");
	ADD(ring, push, "Y");	TEST(ring, "XY");
	ADD(ring, push, "Z");	TEST(ring, "XYZ");
	DROP(ring, shift, "X");	TEST(ring, "YZ");
	DROP(ring, shift, "Y");	TEST(ring, "Z");
	DROP(ring, shift, "Z");	TEST(ring, "");
	
	/* push */
	ADD(ring, push, "a");	TEST(ring, "a");
	ADD(ring, push, "b");	TEST(ring, "ab");
	ADD(ring, push, "c");	TEST(ring, "abc");
	ADD(ring, push, "d");	TEST(ring, "abcd");
	ADD(ring, push, "e");	TEST(ring, "abcde");
	ADD(ring, push, "X");	TEST(ring, "abcde");
	ADD(ring, push, "X");	TEST(ring, "abcde");
	
	/* shift */
	DROP(ring, shift, "a");	TEST(ring, "bcde");
	DROP(ring, shift, "b");	TEST(ring, "cde");
	DROP(ring, shift, "c");	TEST(ring, "de");
	DROP(ring, shift, "d");	TEST(ring, "e");
	DROP(ring, shift, "e");	TEST(ring, "");
	DROP(ring, shift, "X");	TEST(ring, "");
	DROP(ring, shift, "X");	TEST(ring, "");
	
	/* unshift */
	ADD(ring, unshift, "a");TEST(ring, "a");
	ADD(ring, unshift, "b");TEST(ring, "ba");
	ADD(ring, unshift, "c");TEST(ring, "cba");
	ADD(ring, unshift, "d");TEST(ring, "dcba");
	ADD(ring, unshift, "e");TEST(ring, "edcba");
	ADD(ring, unshift, "X");TEST(ring, "edcba");
	ADD(ring, unshift, "X");TEST(ring, "edcba");
	
	/* pop */
	DROP(ring, pop, "a");	TEST(ring, "edcb");
	DROP(ring, pop, "b");	TEST(ring, "edc");
	DROP(ring, pop, "c");	TEST(ring, "ed");
	DROP(ring, pop, "d");	TEST(ring, "e");
	DROP(ring, pop, "e");	TEST(ring, "");
	DROP(ring, pop, "X");	TEST(ring, "");
	DROP(ring, pop, "X");	TEST(ring, "");
	
	/* clone */
	ring2 = ObjRing_clone(ring);
	
	TEST(ring, ""); 		TEST(ring2, "");
	
	ADD(ring, push, "a");	ADD(ring2, unshift, "z");
	TEST(ring, "a"); 		TEST(ring2, "z");
	
	ADD(ring, push, "b");	ADD(ring2, unshift, "y");
	TEST(ring, "ab"); 		TEST(ring2, "yz");
	
	ADD(ring, push, "c");	ADD(ring2, unshift, "x");
	TEST(ring, "abc"); 		TEST(ring2, "xyz");
	
	warn("end\n");
	return 0;
END

t_run_module([], '', <<'ERR', 0);
start
ring = ""
  #                     
+-#-+---+---+---+---+---+
|   |   |   |   |   |   |
+-#-+---+---+---+---+---+
  #                     
push("a")
ring = "a"
  #                     
+-#-+---+---+---+---+---+
| a |   |   |   |   |   |
+---+-#-+---+---+---+---+
      #                 
push("b")
ring = "ab"
  #                     
+-#-+---+---+---+---+---+
| a | b |   |   |   |   |
+---+---+-#-+---+---+---+
          #             
push("c")
ring = "abc"
  #                     
+-#-+---+---+---+---+---+
| a | b | c |   |   |   |
+---+---+---+-#-+---+---+
              #         
push("d")
ring = "abcd"
  #                     
+-#-+---+---+---+---+---+
| a | b | c | d |   |   |
+---+---+---+---+-#-+---+
                  #     
push("e")
ring = "abcde"
  #                     
+-#-+---+---+---+---+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
push("X")
ring = "abcde"
  #                     
+-#-+---+---+---+---+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
push("X")
ring = "abcde"
  #                     
+-#-+---+---+---+---+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("a")
ring = "bcde"
      #                 
+---+-#-+---+---+---+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("b")
ring = "cde"
          #             
+---+---+-#-+---+---+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("c")
ring = "de"
              #         
+---+---+---+-#-+---+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("d")
ring = "e"
                  #     
+---+---+---+---+-#-+---+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("e")
ring = ""
                      # 
+---+---+---+---+---+-#-+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("X")
ring = ""
                      # 
+---+---+---+---+---+-#-+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
shift("X")
ring = ""
                      # 
+---+---+---+---+---+-#-+
| a | b | c | d | e |   |
+---+---+---+---+---+-#-+
                      # 
unshift("a")
ring = "a"
                  #     
+---+---+---+---+-#-+---+
| a | b | c | d | a |   |
+---+---+---+---+---+-#-+
                      # 
unshift("b")
ring = "ba"
              #         
+---+---+---+-#-+---+---+
| a | b | c | b | a |   |
+---+---+---+---+---+-#-+
                      # 
unshift("c")
ring = "cba"
          #             
+---+---+-#-+---+---+---+
| a | b | c | b | a |   |
+---+---+---+---+---+-#-+
                      # 
unshift("d")
ring = "dcba"
      #                 
+---+-#-+---+---+---+---+
| a | d | c | b | a |   |
+---+---+---+---+---+-#-+
                      # 
unshift("e")
ring = "edcba"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+---+---+---+---+-#-+
                      # 
unshift("X")
ring = "edcba"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+---+---+---+---+-#-+
                      # 
unshift("X")
ring = "edcba"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+---+---+---+---+-#-+
                      # 
pop("a")
ring = "edcb"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+---+---+---+-#-+---+
                  #     
pop("b")
ring = "edc"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+---+---+-#-+---+---+
              #         
pop("c")
ring = "ed"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+---+-#-+---+---+---+
          #             
pop("d")
ring = "e"
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+---+-#-+---+---+---+---+
      #                 
pop("e")
ring = ""
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+-#-+---+---+---+---+---+
  #                     
pop("X")
ring = ""
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+-#-+---+---+---+---+---+
  #                     
pop("X")
ring = ""
  #                     
+-#-+---+---+---+---+---+
| e | d | c | b | a |   |
+-#-+---+---+---+---+---+
  #                     
push("X")
ring = "X"
  #                     
+-#-+---+---+---+---+---+
| X | d | c | b | a |   |
+---+-#-+---+---+---+---+
      #                 
push("Y")
ring = "XY"
  #                     
+-#-+---+---+---+---+---+
| X | Y | c | b | a |   |
+---+---+-#-+---+---+---+
          #             
push("Z")
ring = "XYZ"
  #                     
+-#-+---+---+---+---+---+
| X | Y | Z | b | a |   |
+---+---+---+-#-+---+---+
              #         
shift("X")
ring = "YZ"
      #                 
+---+-#-+---+---+---+---+
| X | Y | Z | b | a |   |
+---+---+---+-#-+---+---+
              #         
shift("Y")
ring = "Z"
          #             
+---+---+-#-+---+---+---+
| X | Y | Z | b | a |   |
+---+---+---+-#-+---+---+
              #         
shift("Z")
ring = ""
              #         
+---+---+---+-#-+---+---+
| X | Y | Z | b | a |   |
+---+---+---+-#-+---+---+
              #         
push("a")
ring = "a"
              #         
+---+---+---+-#-+---+---+
| X | Y | Z | a | a |   |
+---+---+---+---+-#-+---+
                  #     
push("b")
ring = "ab"
              #         
+---+---+---+-#-+---+---+
| X | Y | Z | a | b |   |
+---+---+---+---+---+-#-+
                      # 
push("c")
ring = "abc"
              #         
+---+---+---+-#-+---+---+
| X | Y | Z | a | b | c |
+-#-+---+---+---+---+---+
  #                     
push("d")
ring = "abcd"
              #         
+---+---+---+-#-+---+---+
| d | Y | Z | a | b | c |
+---+-#-+---+---+---+---+
      #                 
push("e")
ring = "abcde"
              #         
+---+---+---+-#-+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
push("X")
ring = "abcde"
              #         
+---+---+---+-#-+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
push("X")
ring = "abcde"
              #         
+---+---+---+-#-+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("a")
ring = "bcde"
                  #     
+---+---+---+---+-#-+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("b")
ring = "cde"
                      # 
+---+---+---+---+---+-#-+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("c")
ring = "de"
  #                     
+-#-+---+---+---+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("d")
ring = "e"
      #                 
+---+-#-+---+---+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("e")
ring = ""
          #             
+---+---+-#-+---+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("X")
ring = ""
          #             
+---+---+-#-+---+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
shift("X")
ring = ""
          #             
+---+---+-#-+---+---+---+
| d | e | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
unshift("a")
ring = "a"
      #                 
+---+-#-+---+---+---+---+
| d | a | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
unshift("b")
ring = "ba"
  #                     
+-#-+---+---+---+---+---+
| b | a | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
unshift("c")
ring = "cba"
                      # 
+---+---+---+---+---+-#-+
| b | a | Z | a | b | c |
+---+---+-#-+---+---+---+
          #             
unshift("d")
ring = "dcba"
                  #     
+---+---+---+---+-#-+---+
| b | a | Z | a | d | c |
+---+---+-#-+---+---+---+
          #             
unshift("e")
ring = "edcba"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+-#-+---+---+---+
          #             
unshift("X")
ring = "edcba"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+-#-+---+---+---+
          #             
unshift("X")
ring = "edcba"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+-#-+---+---+---+
          #             
pop("a")
ring = "edcb"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+-#-+---+---+---+---+
      #                 
pop("b")
ring = "edc"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+-#-+---+---+---+---+---+
  #                     
pop("c")
ring = "ed"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+---+---+-#-+
                      # 
pop("d")
ring = "e"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+---+-#-+---+
                  #     
pop("e")
ring = ""
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+-#-+---+---+
              #         
pop("X")
ring = ""
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+-#-+---+---+
              #         
pop("X")
ring = ""
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+-#-+---+---+
              #         
ring = ""
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+-#-+---+---+
              #         
ring2 = ""
              #         
+---+---+---+-#-+---+---+
| b | a | Z | e | d | c |
+---+---+---+-#-+---+---+
              #         
push("a")
unshift("z")
ring = "a"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | a | d | c |
+---+---+---+---+-#-+---+
                  #     
ring2 = "z"
          #             
+---+---+-#-+---+---+---+
| b | a | z | e | d | c |
+---+---+---+-#-+---+---+
              #         
push("b")
unshift("y")
ring = "ab"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | a | b | c |
+---+---+---+---+---+-#-+
                      # 
ring2 = "yz"
      #                 
+---+-#-+---+---+---+---+
| b | y | z | e | d | c |
+---+---+---+-#-+---+---+
              #         
push("c")
unshift("x")
ring = "abc"
              #         
+---+---+---+-#-+---+---+
| b | a | Z | a | b | c |
+-#-+---+---+---+---+---+
  #                     
ring2 = "xyz"
  #                     
+-#-+---+---+---+---+---+
| x | y | z | e | d | c |
+---+---+---+-#-+---+---+
              #         
end
ERR


unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-classring.t,v 1.9 2013-12-15 13:18:35 pauloscustodio Exp $
# $Log: whitebox-classring.t,v $
# Revision 1.9  2013-12-15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.8  2013/09/22 21:06:00  pauloscustodio
# replace g_free by g_free0
#
# Revision 1.7  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.6  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with glib functions
#
# Revision 1.5  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.4  2013/09/01 18:08:29  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.3  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.2  2013/05/12 19:20:34  pauloscustodio
# warnings
#
# Revision 1.1  2013/04/13 15:55:10  pauloscustodio
# New CLASS_RING for circular queue of tokens pre-allocated to spare the
# alloc/free for each token received from the lexer, and to allow quick
# look-ahead for the parser without the need to push back tokens.
#
