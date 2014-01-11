#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/class.t,v 1.5 2014-01-11 01:29:41 pauloscustodio Exp $
#
# Test class.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -DCLASS_DEBUG -otest test.c class.c xmalloc.c die.c";

write_file("test.c", <<'END');
#include "class.h"

CLASS(Name)
	char *str;
END_CLASS;

DEF_CLASS(Name);

void Name_init (Name *self)
{ 
	fprintf(stderr, "Name_init\n");
	self->str = xstrdup("John"); 
}

void Name_copy (Name *self, Name *other) 	
{ 
	fprintf(stderr, "Name_copy\n");
	self->str = xstrdup(self->str); 
}

void Name_fini (Name *self) 	
{ 
	fprintf(stderr, "Name_fini\n");
	xfree(self->str); 
}

CLASS(Person)
	Name *name;
	int  age;
END_CLASS;

DEF_CLASS(Person);

void Person_init (Person *self) 	
{
	fprintf(stderr, "Person_init\n");
	self->name = OBJ_NEW(Name); 
	self->age = 31; 
}

void Person_copy (Person *self, Person *other) 	
{ 
	fprintf(stderr, "Person_copy\n");
	self->name = Name_clone(self->name); 
}

void Person_fini (Person *self) 	
{ 
	fprintf(stderr, "Person_fini\n");
	OBJ_DELETE(self->name); 
}

static Person *the_person = NULL;

int main(int argc, char *argv[])
{
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
		OBJ_DELETE(p1);		/* test double delete */
		if (p1)								return 14;
	}
	
	if (test >= 4) {
		OBJ_DELETE(p2);
		if (p2)								return 15;
		OBJ_DELETE(p2);		/* test double delete */
		if (p2)								return 16;
	}
	
	if (test >= 5) {
		if (the_person != NULL)				return 17;
		p1 = INIT_OBJ(Person, &the_person);
		if (p1 != the_person)				return 18;
		p2 = INIT_OBJ(Person, &the_person);
		if (p2 != the_person)				return 19;
	}
	
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";

# no allocation
t_capture("test 0", "", "", 0);

# alloc one, no free
t_capture("test 1", "", <<'END', 0);
Person_init
Name_init
class: init
class: new class Name
class: new class Person
class: cleanup
class: delete class Person
Person_fini
class: delete class Name
Name_fini
END

# alloc one, clone another, no free
t_capture("test 2", "", <<'END', 0);
Person_init
Name_init
class: init
class: new class Name
class: new class Person
Person_copy
Name_copy
class: new class Name
class: new class Person
class: cleanup
class: delete class Person
Person_fini
class: delete class Name
Name_fini
class: delete class Person
Person_fini
class: delete class Name
Name_fini
END

# alloc one, clone another, free first
t_capture("test 3", "", <<'END', 0);
Person_init
Name_init
class: init
class: new class Name
class: new class Person
Person_copy
Name_copy
class: new class Name
class: new class Person
class: delete class Person
Person_fini
class: delete class Name
Name_fini
class: cleanup
class: delete class Person
Person_fini
class: delete class Name
Name_fini
END

# alloc one, clone another, free first and then second
t_capture("test 4", "", <<'END', 0);
Person_init
Name_init
class: init
class: new class Name
class: new class Person
Person_copy
Name_copy
class: new class Name
class: new class Person
class: delete class Person
Person_fini
class: delete class Name
Name_fini
class: delete class Person
Person_fini
class: delete class Name
Name_fini
class: cleanup
END

# INIT_OBJ
t_capture("test 5", "", <<'END', 0);
Person_init
Name_init
class: init
class: new class Name
class: new class Person
Person_copy
Name_copy
class: new class Name
class: new class Person
class: delete class Person
Person_fini
class: delete class Name
Name_fini
class: delete class Person
Person_fini
class: delete class Name
Name_fini
Person_init
Name_init
class: new class Name
class: new class Person
class: cleanup
class: delete class Person
Person_fini
class: delete class Name
Name_fini
END

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

# $Log: class.t,v $
# Revision 1.5  2014-01-11 01:29:41  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.4  2013/12/26 23:37:34  pauloscustodio
# New INIT_OBJ macro to call OBJ_NEW only if object pointer is NULL.
# Used to initialize an object on the first use.
#
# Revision 1.3  2013/12/23 19:19:52  pauloscustodio
# Show difference in command output in case of test failure
#
# Revision 1.2  2013/12/18 23:50:36  pauloscustodio
# Remove file and lineno from class defintion - not useful
#
# Revision 1.1  2013/12/18 23:05:53  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.13  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.12  2013/09/22 21:06:00  pauloscustodio
# replace glib free by xfree
#
# Revision 1.11  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.10  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with glib functions
#
# Revision 1.9  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.8  2013/09/01 18:30:15  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.7  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.6  2013/05/12 21:39:05  pauloscustodio
# OBJ_DELETE() now accepts and ignores a NULL argument
#
# Revision 1.5  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.4  2013/01/19 00:04:53  pauloscustodio
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
