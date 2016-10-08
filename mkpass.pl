#!/usr/bin/perl
use strict;
#
# Pretty good /dev/urandom ASCII password generator
# 
# password conditions:
# - arbitrary maximum length given, random length at least half of maximum length
# - only printable ASCII, no quote characters
# - contains at least one letter [A-Za-z]
# - contains lower and uppercase letters if length > 3
# - contains at least one digit [0-9] if length > 2
# - contains at least one special character if length > 4
#
#
BEGIN { $\ = "\n"; $, = ''; }

# random generator
my @rands;
sub irand { 
	@rands = unpack('N*', `head -c 400 /dev/urandom`) unless @rands > 0; # take 100
	(shift @rands) % (int($_[0]) or 1);
}

# sources
my @chr = ( 'A' .. 'Z', 'a' .. 'z' );
my @dig = ( 0 .. 9 );
my @ext = ( '^', '!', '$', '%', '&', '/', '{', '}', '[', ']',  '(', ')', 
	'=', '?', '@', '*', '+', '#', '>', '<', '|', ';', ',', ':', '.', '-', '_' );
my $qext = quotemeta join '' => @ext;
my @all = ( @chr, @dig, @ext );


# max length arg
my $maxlen = (shift or 40);
my $minlen = (int($maxlen / 2) or 1);

# random length
my $len = $maxlen - irand($maxlen / 3);
$len = $minlen if $len < $minlen;

tryagain:
my @q = map { $all[ irand(scalar @all) ] } ( 1 .. $len );

# password conditions
goto tryagain unless grep /[A-Za-z]/, @q;
goto tryagain unless $len <= 2 || scalar grep /[0-9]/, @q;
goto tryagain unless $len <= 3 || scalar grep /[A-Z]/, @q;
goto tryagain unless $len <= 3 || scalar grep /[a-z]/, @q;
goto tryagain unless $len <= 4 || scalar grep /[$qext]/, @q;

print keys %{ { map { $_ => 1 } @q } };

exit;
__END__






