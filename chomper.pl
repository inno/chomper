#!/usr/bin/perl

use strict;
use warnings;
use File::Random qw( random_file );

my $lame_bin = `which lame`;
my $aubiocut_bin = `which aubiocut`;

die "lame (http://lame.sourceforge.net) is required for this tool to work!\n" unless $lame_bin;
die "aubio (http://aubio.org) is required for this tool to work!\n" unless $aubiocut_bin;

chomp $lame_bin;
chomp $aubiocut_bin;

my $count = shift;
my $root_dir = shift;

die "Syntax: $0 {count_to_chew} {file_source} {destination}\n" if !$count or !$root_dir;
die "The count must be numeric and greater than one\n" if $count < 1;
die "Path [$root_dir] is not valid\n" unless -d $root_dir;

chomp $root_dir;

my $dest_dir = shift || 'smpl';
my $tmp_dir = 'p1aygrnd';

$|=1;

print "Determing directory structure...\n";
my @files = pluck_files($root_dir, $count);

print "\nDecoding";
my $i = decode_files(\@files, $root_dir, $tmp_dir);

print "\nChopping";
chop_files($tmp_dir);

print "\nParsing";
rand_sampling($tmp_dir, 'smpl');

print "Cleanup...\n";
`rm -rf $tmp_dir`;

print "Done!\n";


sub pluck_files {
    my ($root_dir, $count) = @_;
    my @files;

    foreach ( 1 .. $count ) {
        push @files, random_file (
            -dir       => $root_dir,
            -check     => qr/\.mp3$/,
            -recursive => 1
        );
        if ( $_ == 1 ) { print "Gathering files" }
        print '.';
    }

    return @files;
}
sub decode_files {
    my ($files, $root_path, $dest_path) = @_;

    `rm -rf $dest_path`;
    mkdir $dest_path;

    my $count = 0;
    foreach my $file ( @{$files} ) {
        `$lame_bin --quiet --decode "$root_path/$file" $dest_path/$count.wav`;
        $count++;
        print '.';
    }

    return $count;
}

sub chop_files {
    my ($dest_path) = @_;

    chdir $dest_path;
    foreach my $file ( 0 .. $count-1 ) {
        `$aubiocut_bin -b -L -c -i $file.wav`; # Should we be using -L ?
        unlink "$file.wav" && print '.';
    }
    chdir '..';
}

sub rand_sampling {
    my ($src_path, $dest_path) = @_;
    my $max = 127;

    mkdir $dest_path;

    my @sampling;

    foreach my $count ( 1 .. $max ) {
        my $file = random_file(
            -dir   => $src_path,
            -check => qr/\.wav$/,
        );

        print '.';
        `mv $src_path/$file $dest_path/$count.wav`;
    }
}
