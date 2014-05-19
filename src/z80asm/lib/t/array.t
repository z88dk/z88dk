#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/array.t,v 1.12 2014-05-19 00:11:25 pauloscustodio Exp $
#
# Test array.h

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c array.c strutil.c strpool.c class.c xmalloc.c die.c";

write_file("test.c", <<'END');
#include "xmalloc.h"
#include "array.h"
#include "die.h"
#include <assert.h>

typedef struct Point 
{
	char *name;
	int x, y;
} Point;

void Point_free(void *_point) 
{
	Point *point = _point;
	xfree(point->name);
}

ARRAY( Point );
DEF_ARRAY( Point );

PointArray *points;
uint8_tArray *bytes;
intArray *ints;
longArray *longs;

int main(int argc, char *argv[])
{
	Point *p;
	long *lp;
	int *ip;
	uint8_t *bp;
	long l;
	int i;
	
	points = OBJ_NEW( PointArray );
	points->free_data = Point_free;
	
	PointArray_unreserve(points);
	
	assert( PointArray_size(points) == 0 );
	assert( points->items->len == 0 );
	assert( points->items->size == 1 );
	
	p = PointArray_item(points, 0);
	assert( p == (Point*)points->items->str );
	assert( PointArray_size(points) == 1 );
	assert( points->items->len == sizeof(Point) );
	assert( points->items->size >= sizeof(Point)+1 );

	PointArray_unreserve(points);
	assert( points->items->len == sizeof(Point) );
	assert( points->items->size == sizeof(Point)+1 );
	
	assert( p->name == NULL );
	assert( p->x == 0 );
	assert( p->y == 0 );
	
	p->name = xstrdup("hello");
	p->x = 1;
	p->y = 2;
	
	p = PointArray_item(points, 10);
	PointArray_unreserve(points);
	assert( p == (Point*)points->items->str + 10 );
	assert( PointArray_size(points) == 11 );
	assert( points->items->len == 11*sizeof(Point) );
	assert( points->items->size == 11*sizeof(Point)+1 );

	p->name = xstrdup("world");
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
	PointArray_unreserve(points);
	assert( PointArray_size(points) == 12 );
	assert( points->items->len == 12*sizeof(Point) );
	assert( points->items->size == 12*sizeof(Point)+1 );

	p = PointArray_item(points, 11);
	PointArray_unreserve(points);
	assert( p == (Point*)points->items->str + 11 );
	assert( PointArray_size(points) == 12 );
	assert( points->items->len == 12*sizeof(Point) );
	assert( points->items->size == 12*sizeof(Point)+1 );

	p->name = xstrdup("hello again");
	p->x = 5;
	p->y = 6;
	
	p = PointArray_item(points, 11);
	PointArray_unreserve(points);
	assert( strcmp(p->name, "hello again") == 0 );
	assert( p->x == 5 );
	assert( p->y == 6 );
	
	/* shrink */
	PointArray_set_size(points, 1);
	PointArray_unreserve(points);
	assert( PointArray_size(points) == 1 );
	assert( points->items->len == 1*sizeof(Point) );
	assert( points->items->size == 1*sizeof(Point)+1 );

	p = PointArray_item(points, 0);
	assert( p == (Point*)points->items->str + 0 );
	assert( strcmp(p->name, "hello") == 0 );
	assert( p->x == 1 );
	assert( p->y == 2 );
	
	/* push */
	p = PointArray_push(points);
	PointArray_unreserve(points);
	assert( p == (Point*)points->items->str + 1 );
	assert( PointArray_size(points) == 2 );
	assert( points->items->len == 2*sizeof(Point) );
	assert( points->items->size == 2*sizeof(Point)+1 );
	
	p->name = xstrdup("new point");
	p->x = 7;
	p->y = 8;
	
	/* top */
	p = PointArray_top(points);
	PointArray_unreserve(points);
	assert( p == (Point*)points->items->str + 1 );
	assert( strcmp(p->name, "new point") == 0 );
	assert( p->x == 7 );
	assert( p->y == 8 );
	
	/* pop */
	PointArray_pop(points);
	PointArray_unreserve(points);
	assert( PointArray_size(points) == 1 );
	assert( points->items->len == 1*sizeof(Point) );
	assert( points->items->size == 1*sizeof(Point)+1 );
	
	/* top */
	p = PointArray_top(points);
	PointArray_unreserve(points);
	assert( p == (Point*)points->items->str + 0 );
	assert( strcmp(p->name, "hello") == 0 );
	assert( p->x == 1 );
	assert( p->y == 2 );
	
	PointArray_remove_all(points);
	PointArray_unreserve(points);
	assert( PointArray_size(points) == 0 );
	assert( points->items->len == 0 );
	assert( points->items->size == 1 );
	
	/* top */
	p = PointArray_top(points);
	PointArray_unreserve(points);
	assert( p == NULL );
	
	/* byte array */
	bytes = OBJ_NEW( uint8_tArray );
	for ( i = 10; i >= 0; i-- ) 
	{
		bp = uint8_tArray_item(bytes, i);
		*bp = (uint8_t) i;
	}
	for ( i = 0; i <= 10; i++ )
	{
		bp = uint8_tArray_item(bytes, i);
		assert( *bp == (uint8_t) i );
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

# $Log: array.t,v $
# Revision 1.12  2014-05-19 00:11:25  pauloscustodio
# Make sure strpool is deleted after class, because objects defined with class may use strpool
#
# Revision 1.11  2014/05/17 14:27:13  pauloscustodio
# Use C99 integer types int8_t, uint8_t, int16_t, uint16_t, int32_t, uint32_t
#
# Revision 1.10  2014/05/06 22:17:38  pauloscustodio
# Made types uint8_t, UINT and ULONG all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
#
# Revision 1.9  2014/05/02 21:34:58  pauloscustodio
# byte_t, uint_t and ulong_t renamed to uint8_t, UINT and ULONG
#
# Revision 1.8  2014/05/02 21:13:54  pauloscustodio
# Add byte array to default types
#
# Revision 1.7  2014/04/19 15:15:40  pauloscustodio
# Update for 64-bit architecture
#
# Revision 1.6  2014/04/19 14:57:58  pauloscustodio
# Fix test scripts to run in UNIX
#
# Revision 1.5  2014/04/15 20:06:44  pauloscustodio
# Solve warning: no newline at end of file
#
# Revision 1.4  2014/04/12 15:18:06  pauloscustodio
# Add intArray and longArray to array.c
#
# Revision 1.3  2014/04/07 21:06:23  pauloscustodio
# Reduce default size to 16 to waste less space when used as base for array.h
#
# Revision 1.2  2014/03/02 14:08:42  pauloscustodio
# Add methods to set size, push, pop and lookup top item
#
# Revision 1.1  2014/02/17 22:05:20  pauloscustodio
# Template array that grows on request. Items may move in memory on reallocation.
# Uses strutil.h for implementation.
#
#
