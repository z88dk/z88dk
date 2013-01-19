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
# Copyright (C) Paulo Custodio, 2011-2012

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-class.t,v 1.4 2013-01-19 00:04:53 pauloscustodio Exp $
# $Log: whitebox-class.t,v $
# Revision 1.4  2013-01-19 00:04:53  pauloscustodio
# Implement StrHash_clone, required change in API of class.h and all classes that used it.
#
# Revision 1.3  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.2  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.1  2012/05/24 17:16:28  pauloscustodio
# CH_0009 : new CLASS to define simple classes
#
#
# Test class

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

# test class

my $objs = "die.o except.o strutil.o safestr.o";
ok ! system "make $objs";
my $compile = "-DCLASS_DEBUG -DMEMALLOC_DEBUG class.c memalloc.c $objs";

my $init = <<'END';
CLASS(Name)
	char *str;
END_CLASS;

DEF_CLASS(Name);

void Name_init (Name *self)
{ 
	fprintf(stderr, "Name_init 0x%p\n", self);
	self->str = xstrdup("John"); 
}

void Name_copy (Name *self, Name *other) 	
{ 
	fprintf(stderr, "Name_copy 0x%p\n", self);
	self->str = xstrdup(self->str); 
}

void Name_fini (Name *self) 	
{ 
	fprintf(stderr, "Name_fini 0x%p\n", self);
	xfree(self->str); 
}

CLASS(Person)
	Name *name;
	int  age;
END_CLASS;

DEF_CLASS(Person);

void Person_init (Person *self) 	
{ 
	fprintf(stderr, "Person_init 0x%p\n", self);
	self->name = OBJ_NEW(Name); 
	self->age = 31; 
}

void Person_copy (Person *self, Person *other) 	
{ 
	fprintf(stderr, "Person_copy 0x%p\n", self);
	self->name = Name_clone(self->name); 
}

void Person_fini (Person *self) 	
{ 
	fprintf(stderr, "Person_fini 0x%p\n", self);
	OBJ_DELETE(self->name); 
}

END


t_compile_module($init, <<'END', $compile);
	Person *p1, *p2;
	int test;
	
	if (argc != 2)							return 1;
	test = atoi(argv[1]);
	
	if (test >= 1) {
		p1 = OBJ_NEW(Person);	
		if (! p1) 							return 2;
		if (p1->age != 31)					return 3;
		if (! p1->name)						return 4;
		if (strcmp(p1->name->str, "John"))	return 5;
	}
	
	if (test >= 2) {
		p2 = Person_clone(p1);
		if (! p2) 							return 6;
		if (p2->age != 31)					return 7;
		if (! p2->name)						return 8;
		if (strcmp(p2->name->str, "John"))	return 9;
		if (p1 == p2)						return 10;
		if (p1->name == p2->name)			return 11;
		if (p1->name->str == p2->name->str)	return 12;
	}
	
	if (test >= 3) {
		OBJ_DELETE(p1);
		if (p1)								return 13;
	}
	
	if (test >= 4) {
		OBJ_DELETE(p2);
		if (p2)								return 14;
	}
	
	return 0;
END

# no allocation
t_run_module([0], "", <<ERR, 0);
ERR


# alloc one, no free
t_run_module([1], "", <<ERR, 0);
memalloc: init
memalloc test.c(4): alloc 36 bytes at ADDR_1
Person_init ADDR_1
memalloc test.c(1): alloc 32 bytes at ADDR_2
Name_init ADDR_2
memalloc test.c(2): alloc 5 bytes at ADDR_3
class: init
class test.c(1): new class Name at ADDR_2
class test.c(4): new class Person at ADDR_1
class: cleanup
class test.c(4): delete class Person at ADDR_1 created at test.c(4)
Person_fini ADDR_1
class test.c(1): delete class Name at ADDR_2 created at test.c(1)
Name_fini ADDR_2
memalloc test.c(3): free 5 bytes at ADDR_3 allocated at test.c(2)
memalloc test.c(1): free 32 bytes at ADDR_2 allocated at test.c(1)
memalloc test.c(4): free 36 bytes at ADDR_1 allocated at test.c(4)
memalloc: cleanup
ERR


# alloc one, clone another, no free
t_run_module([2], "", <<ERR, 0);
memalloc: init
memalloc test.c(5): alloc 36 bytes at ADDR_1
Person_init ADDR_1
memalloc test.c(1): alloc 32 bytes at ADDR_2
Name_init ADDR_2
memalloc test.c(2): alloc 5 bytes at ADDR_3
class: init
class test.c(1): new class Name at ADDR_2
class test.c(5): new class Person at ADDR_1
memalloc test.c(5): alloc 36 bytes at ADDR_4
Person_copy ADDR_4
memalloc test.c(1): alloc 32 bytes at ADDR_5
Name_copy ADDR_5
memalloc test.c(3): alloc 5 bytes at ADDR_6
class test.c(1): new class Name at ADDR_5
class test.c(5): new class Person at ADDR_4
class: cleanup
class test.c(5): delete class Person at ADDR_4 created at test.c(5)
Person_fini ADDR_4
class test.c(1): delete class Name at ADDR_5 created at test.c(1)
Name_fini ADDR_5
memalloc test.c(4): free 5 bytes at ADDR_6 allocated at test.c(3)
memalloc test.c(1): free 32 bytes at ADDR_5 allocated at test.c(1)
memalloc test.c(5): free 36 bytes at ADDR_4 allocated at test.c(5)
class test.c(5): delete class Person at ADDR_1 created at test.c(5)
Person_fini ADDR_1
class test.c(1): delete class Name at ADDR_2 created at test.c(1)
Name_fini ADDR_2
memalloc test.c(4): free 5 bytes at ADDR_3 allocated at test.c(2)
memalloc test.c(1): free 32 bytes at ADDR_2 allocated at test.c(1)
memalloc test.c(5): free 36 bytes at ADDR_1 allocated at test.c(5)
memalloc: cleanup
ERR


# alloc one, clone another, free first
t_run_module([3], "", <<ERR, 0);
memalloc: init
memalloc test.c(5): alloc 36 bytes at ADDR_1
Person_init ADDR_1
memalloc test.c(1): alloc 32 bytes at ADDR_2
Name_init ADDR_2
memalloc test.c(2): alloc 5 bytes at ADDR_3
class: init
class test.c(1): new class Name at ADDR_2
class test.c(5): new class Person at ADDR_1
memalloc test.c(5): alloc 36 bytes at ADDR_4
Person_copy ADDR_4
memalloc test.c(1): alloc 32 bytes at ADDR_5
Name_copy ADDR_5
memalloc test.c(3): alloc 5 bytes at ADDR_6
class test.c(1): new class Name at ADDR_5
class test.c(5): new class Person at ADDR_4
class test.c(5): delete class Person at ADDR_1 created at test.c(5)
Person_fini ADDR_1
class test.c(1): delete class Name at ADDR_2 created at test.c(1)
Name_fini ADDR_2
memalloc test.c(4): free 5 bytes at ADDR_3 allocated at test.c(2)
memalloc test.c(1): free 32 bytes at ADDR_2 allocated at test.c(1)
memalloc test.c(5): free 36 bytes at ADDR_1 allocated at test.c(5)
class: cleanup
class test.c(5): delete class Person at ADDR_4 created at test.c(5)
Person_fini ADDR_4
class test.c(1): delete class Name at ADDR_5 created at test.c(1)
Name_fini ADDR_5
memalloc test.c(4): free 5 bytes at ADDR_6 allocated at test.c(3)
memalloc test.c(1): free 32 bytes at ADDR_5 allocated at test.c(1)
memalloc test.c(5): free 36 bytes at ADDR_4 allocated at test.c(5)
memalloc: cleanup
ERR


# alloc one, clone another, free first and then second
t_run_module([4], "", <<ERR, 0);
memalloc: init
memalloc test.c(5): alloc 36 bytes at ADDR_1
Person_init ADDR_1
memalloc test.c(1): alloc 32 bytes at ADDR_2
Name_init ADDR_2
memalloc test.c(2): alloc 5 bytes at ADDR_3
class: init
class test.c(1): new class Name at ADDR_2
class test.c(5): new class Person at ADDR_1
memalloc test.c(5): alloc 36 bytes at ADDR_4
Person_copy ADDR_4
memalloc test.c(1): alloc 32 bytes at ADDR_5
Name_copy ADDR_5
memalloc test.c(3): alloc 5 bytes at ADDR_6
class test.c(1): new class Name at ADDR_5
class test.c(5): new class Person at ADDR_4
class test.c(5): delete class Person at ADDR_1 created at test.c(5)
Person_fini ADDR_1
class test.c(1): delete class Name at ADDR_2 created at test.c(1)
Name_fini ADDR_2
memalloc test.c(4): free 5 bytes at ADDR_3 allocated at test.c(2)
memalloc test.c(1): free 32 bytes at ADDR_2 allocated at test.c(1)
memalloc test.c(5): free 36 bytes at ADDR_1 allocated at test.c(5)
class test.c(5): delete class Person at ADDR_4 created at test.c(5)
Person_fini ADDR_4
class test.c(1): delete class Name at ADDR_5 created at test.c(1)
Name_fini ADDR_5
memalloc test.c(4): free 5 bytes at ADDR_6 allocated at test.c(3)
memalloc test.c(1): free 32 bytes at ADDR_5 allocated at test.c(1)
memalloc test.c(5): free 36 bytes at ADDR_4 allocated at test.c(5)
class: cleanup
memalloc: cleanup
ERR


unlink_testfiles();
done_testing;
