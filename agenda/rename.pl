#! /usr/bin/perl

for ($i = 9; $i <= 28; $i++) {
	$cmd = sprintf("cp day%02d.md day%02d.md", $i, $i-1);
	print "$cmd\n";
	system($cmd)/256 == 0 || die;
}
