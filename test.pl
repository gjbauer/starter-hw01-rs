#!/usr/bin/perl
use 5.26.0;
use warnings FATAL => 'all';
use feature qw(signatures);
no warnings "experimental::signatures";

use Test::Simple tests => 9;

ok(-e "./screenfetch.txt", "screenfetch.txt exists");

remove_mac_junk();
require_clean();
chdir("cube");
system("cargo", "build");
chdir("../square");
run_make();
chdir("..");


if (-e "square/square") {
    ok(-x "square/square", "square binary executable");
    ok(sq(0) == 0, "sq(0)");
    ok(sq(2) == 4, "sq(2)");
    ok(sq(10) == 100, "sq(100)");
}
else {
    for (1..4) {
        ok(-x "square/square", "square binary executable");
    }
}

if (-x "cube/target/debug/cube-rs") {
    ok(-x "cube/target/debug/cube-rs", "cube binary executable");
    ok(cu(0) == 0, "cu(0)");
    ok(cu(3) == 27, "cu(2)");
    ok(cu(10) == 1000, "cu(100)");
}
else {
    for (1..4) {
        ok(-x "cube/target/debug/cube-rs", "cube binary executable");
    }
}

run_make("clean");

sub sq {
    my ($xx) = @_;
    return run("square/square", $xx);
}

sub cu {
    my ($xx) = @_;
    return run("cube/target/debug/cube-rs", $xx);
}

sub run {
    my ($cmd, $arg) = @_;
    my $vv = `timeout -s 9 5 "./$cmd" "$arg"`;
    $vv =~ s/result\s*=//;
    chomp $vv;
    return int($vv);
}

sub remove_mac_junk {
    if ("$^O" eq "linux") {
        system(q(find . -name '._*' -exec rm {} \;));
    }
}

sub require_clean {
    my $is_clean = 1;
    my @filetypes = `find . -type f -exec file {} \\;`;
    for my $line (@filetypes) {
        my ($path, $type) = split(':', $line, 2);
        if ($type !~ /text/ && $type !~ /empty/) {
            say "#";
            say "# Binary file '$path' found, of type '$type'";
            say "#";
            $is_clean = 0;
        }
    }

    unless ($is_clean) {
        say "#\n#";
        say "#      You must run 'make clean' before submitting.";
        say "#\n#";
        exit(1);
    }
}

sub run_make {
    my ($action) = @_;
    $action ||= "";

    say "# make $action ...";
    my $cmd = qq{make $action 2>&1 || true};
    my $output = `$cmd`;
    $output =~ s/^/# /mg;
    say "$output#";
}

