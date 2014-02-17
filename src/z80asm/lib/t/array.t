#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/array.t,v 1.1 2014-02-17 22:05:20 pauloscustodio Exp $
#
# Test array.h

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c strutil.c class.c xmalloc.c die.c";

write_file("test.c", <<'END');
#include "xmalloc.h"
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
	xfree(point->name);
}

ARRAY( Point );
DEF_ARRAY( Point );

PointArray *points;

int main(int argc, char *argv[])
{
	Point *p;
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
	assert( points->items->size == 256 );

	PointArray_unreserve(points);
	assert( points->items->len == 12 );
	assert( points->items->size == 13 );
	
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
	
	PointArray_remove_all(points);
	PointArray_unreserve(points);
	assert( PointArray_size(points) == 0 );
	assert( points->items->len == 0 );
	assert( points->items->size == 1 );
	
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";
t_capture("test", "", "", 0);

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
# Revision 1.1  2014-02-17 22:05:20  pauloscustodio
# Template array that grows on request. Items may move in memory on reallocation.
# Uses strutil.h for implementation.
#
# 
