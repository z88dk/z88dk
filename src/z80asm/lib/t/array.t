#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test array.h

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "gcc -Wall -otest test.c array.c str.c strpool.c class.c alloc.c dbg.c";

write_file("test.c", <<'END');
#include "alloc.h"
#include "array.h"
#include <assert.h>

typedef struct Point 
{
	char *name;
	int x, y;
} Point;

void Point_free(void *_point) 
{
	Point *point = _point;
	m_free(point->name);
}

ARRAY( Point );
DEF_ARRAY( Point );

PointArray *points;
ByteArray *bytes;
intArray *ints;
longArray *longs;

int main(int argc, char *argv[])
{
	Point *p;
	long *lp;
	int *ip;
	Byte *bp;
	long l;
	int i;
	
	points = OBJ_NEW( PointArray );
	points->free_data = Point_free;
	
	assert( PointArray_size(points) == 0 );
	assert( str_len(points->items) == 0 );
	assert( str_size(points->items) >= 0 );
	
	p = PointArray_item(points, 0);
	assert( p == (Point*)str_data(points->items) );
	assert( PointArray_size(points) == 1 );
	assert( str_len(points->items) == sizeof(Point) );
	assert( str_size(points->items) >= sizeof(Point)+1 );

	assert( str_len(points->items) == sizeof(Point) );
	assert( str_size(points->items) >= sizeof(Point)+1 );
	
	assert( p->name == NULL );
	assert( p->x == 0 );
	assert( p->y == 0 );
	
	p->name = m_strdup("hello");
	p->x = 1;
	p->y = 2;
	
	p = PointArray_item(points, 10);
	assert( p == (Point*)str_data(points->items) + 10 );
	assert( PointArray_size(points) >= 11 );
	assert( str_len(points->items) == 11*sizeof(Point) );
	assert( str_size(points->items) >= 11*sizeof(Point)+1 );

	p->name = m_strdup("world");
	p->x = 3;
	p->y = 4;
	
	p = PointArray_item(points, 0);
	assert( strcmp(p->name, "hello") == 0 );
	assert( p->x == 1 );
	assert( p->y == 2 );
	
	for (i=1; i<10; i++) 
	{
		p = PointArray_item(points, i);
		assert( p->name == NULL );
		assert( p->x == 0 );
		assert( p->y == 0 );
	}

	p = PointArray_item(points, 10);
	assert( strcmp(p->name, "world") == 0 );
	assert( p->x == 3 );
	assert( p->y == 4 );
	
	/* grow */
	PointArray_set_size(points, 12);
	assert( PointArray_size(points) == 12 );
	assert( str_len(points->items) == 12*sizeof(Point) );
	assert( str_size(points->items) >= 12*sizeof(Point)+1 );

	p = PointArray_item(points, 11);
	assert( p == (Point*)str_data(points->items) + 11 );
	assert( PointArray_size(points) == 12 );
	assert( str_len(points->items) == 12*sizeof(Point) );
	assert( str_size(points->items) >= 12*sizeof(Point)+1 );

	p->name = m_strdup("hello again");
	p->x = 5;
	p->y = 6;
	
	p = PointArray_item(points, 11);
	assert( strcmp(p->name, "hello again") == 0 );
	assert( p->x == 5 );
	assert( p->y == 6 );
	
	/* shrink */
	PointArray_set_size(points, 1);
	assert( PointArray_size(points) == 1 );
	assert( str_len(points->items) == 1*sizeof(Point) );
	assert( str_size(points->items) >= 1*sizeof(Point)+1 );

	p = PointArray_item(points, 0);
	assert( p == (Point*)str_data(points->items) + 0 );
	assert( strcmp(p->name, "hello") == 0 );
	assert( p->x == 1 );
	assert( p->y == 2 );
	
	/* push */
	p = PointArray_push(points);
	assert( p == (Point*)str_data(points->items) + 1 );
	assert( PointArray_size(points) == 2 );
	assert( str_len(points->items) == 2*sizeof(Point) );
	assert( str_size(points->items) >= 2*sizeof(Point)+1 );
	
	p->name = m_strdup("new point");
	p->x = 7;
	p->y = 8;
	
	/* top */
	p = PointArray_top(points);
	assert( p == (Point*)str_data(points->items) + 1 );
	assert( strcmp(p->name, "new point") == 0 );
	assert( p->x == 7 );
	assert( p->y == 8 );
	
	/* pop */
	PointArray_pop(points);
	assert( PointArray_size(points) == 1 );
	assert( str_len(points->items) == 1*sizeof(Point) );
	assert( str_size(points->items) >= 1*sizeof(Point)+1 );
	
	/* top */
	p = PointArray_top(points);
	assert( p == (Point*)str_data(points->items) + 0 );
	assert( strcmp(p->name, "hello") == 0 );
	assert( p->x == 1 );
	assert( p->y == 2 );
	
	PointArray_remove_all(points);
	assert( PointArray_size(points) == 0 );
	assert( str_len(points->items) == 0 );
	assert( str_size(points->items) >= 1 );
	
	/* top */
	p = PointArray_top(points);
	assert( p == NULL );
	
	/* byte array */
	bytes = OBJ_NEW( ByteArray );
	for ( i = 10; i >= 0; i-- ) 
	{
		bp = ByteArray_item(bytes, i);
		*bp = (Byte) i;
	}
	for ( i = 0; i <= 10; i++ )
	{
		bp = ByteArray_item(bytes, i);
		assert( *bp == (Byte) i );
	}
	
	/* int array */
	ints = OBJ_NEW( intArray );
	for ( i = 10; i >= 0; i-- ) 
	{
		ip = intArray_item(ints, i);
		*ip = i;
	}
	for ( i = 0; i <= 10; i++ )
	{
		ip = intArray_item(ints, i);
		assert( *ip == i );
	}
	
	/* long array */
	longs = OBJ_NEW( longArray );
	for ( l = 10; l >= 0; l-- ) 
	{
		lp = longArray_item(longs, l);
		*lp = l;
	}
	for ( l = 0; l <= 10; l++ )
	{
		lp = longArray_item(longs, l);
		assert( *lp == l );
	}
	

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
