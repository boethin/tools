#!/usr/bin/perl
use strict;
#
# Generate a good random password.
#

BEGIN { $\ = "\n" }

# max length arg
my $maxlen = shift;
$maxlen > 0 or $maxlen = 40;

# random generator
my @rands;
sub irand { 
	@rands = unpack('N*', `head -c 400 /dev/urandom`) unless @rands > 0;
	(shift @rands) % int($_[0]);
}

# sources
my @chr = ( 'A' .. 'Z', 'a' .. 'z' );
my @dig = ( 0 .. 9 );
my @ext = ( '^', '!', '$', '%', '&', '/', '{', '}', '[', ']',  '(', ')', 
	'=', '?', '@', '*', '+', '#', '>', '<', '|', ';', ',', ':', '.', '-', '_' );
my @all = ( @chr, @dig, @ext );

# random length
my $len = $maxlen - irand($maxlen / 3);
$len = 1 unless $len > 0;

my @q = map { $all[ irand(scalar @all) ] } ( 1 .. $len );
print keys %{ { map { $_ => 1 } @q } };







