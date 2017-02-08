#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test class.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -Wall -DCLASS_DEBUG -otest test.c class.c strpool.c alloc.c dbg.c";

write_file("test.c", <<'END');
#include "class.h"

CLASS(Name)
	char *str;
END_CLASS;

DEF_CLASS(Name);

void Name_init (Name *self)
{ 
	fprintf(stderr, "Name_init\n");
	self->str = m_strdup("John"); 
}

void Name_copy (Name *self, Name *other) 	
{ 
	fprintf(stderr, "Name_copy\n");
	self->str = m_strdup(self->str); 
}

void Name_fini (Name *self) 	
{ 
	fprintf(stderr, "Name_fini\n");
	m_free(self->str); 
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
t_capture("./test 0", "", "", 0);

# alloc one, no free
t_capture("./test 1", "", <<'END', 0);
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
t_capture("./test 2", "", <<'END', 0);
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
t_capture("./test 3", "", <<'END', 0);
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
t_capture("./test 4", "", <<'END', 0);
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
t_capture("./test 5", "", <<'END', 0);
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
