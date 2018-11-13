#!/usr/bin/perl

$previous = <>;
chomp($previous);
while ( $current = <> ) {
chomp($current);
print $current . "\t" .
$previous . "\n";
$previous = $current;
}
