#! /usr/bin/perl -w
#
# Script to support entry and modification of X-Label entries
#
# $Id: editlabel.pl 4 2008-06-09 15:58:25Z memes $

use strict;
use Term::ReadLine;
use File::Basename;
use File::Copy qw(move);
use File::Temp qw(tempfile);

my $HISTORY_NAME = "editlabel";
my $PROMPT = "Enter tags: ";
my $HISTORY_FILE = dirname($0) . "/.editlabel";

my $term = Term::ReadLine->new($HISTORY_NAME);
$term->ReadHistory($HISTORY_FILE) if (-r $HISTORY_FILE);
my $out = $term->OUT || \*STDOUT;
foreach (@ARGV) {
    my $msg = &fixup($_);
    if (-r $msg) {
	my $labels = &getLabels($msg);
	$term->AddHistory($labels);
	if ($term->Features->{preput}) {
	    $labels = $term->readline($PROMPT, $labels);
	} else {
	    print "Existing labels: $labels";
	    $labels = $term->readline($PROMPT);
	}
	&setLabels($msg, $labels);
	$term->AddHistory($labels);
	print $out "\n";
    }
}
$term->WriteHistory($HISTORY_FILE);

sub fixup() {
    (my $file = $_) =~ s#/new/new/#/new/#;
    $file =~ s#/cur/cur/#/cur/#;
    die "Cannot read $file" unless (-r $file);
    return $file;
}
    
sub getLabels() {
    my $file = $_;
    die "$file does not exist" unless (-e $file);
    my $labels = `formail -cxX-Label: < $file 2>/dev/null`;
    chomp $labels;
    $labels =~ s/^\s+|\s+$//g;
    return $labels;
}

sub setLabels() {
    my ($file, $labels) = @_;
    my ($fh, $fileNew) = tempfile();
    my $cmd  = undef;
    die "Cannot read $file" unless (-r $file);
    if ($labels) {
	$cmd = "formail -fI \"X-Label: $labels\" < $file > $fileNew";
    } else {
	$cmd = "formail -fI \"X-Label:\" < $file > $fileNew";
    }
    unless (system($cmd)) {
	move($fileNew, $file) or die "Unable to move $fileNew to $file: $!";
    }
}
