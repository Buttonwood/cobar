$/="##";
<>;
while(my $line=<>){
        chomp $line;
#=pod
        if($line =~ /(\d+:\d+:\d+,\d+) INFO/){
                print $1.";";
                &get_info($line);
        }
        if ($line =~ /(\d+:\d+:\d+,\d+) ERROR/) {
                print $1.";";
                &get_error($line);
        }
#=cut
        if($line =~ /(\d+:\d+:\d+,\d+) WARN/){
                print $1.";";
                &get_warn($line);
        }
}

sub get_host{
        my $tmp = shift;
        if ($tmp =~ /host=(\d+\.\d+\.\d+\.\d+)/){
                print $1.";";
        }else{
                print "no_host;";
        }
}
sub get_info {
        my $tmp = shift;
        my @arr = split(/\n/,$tmp);
        my $txt = join(" ",@arr);
        &get_host($txt);
        @arr = split(/INFO|schema=.*\]/,$txt);
        print &trans_line($arr[-1]);
        print ";\n";
}

sub get_error {
        my $tmp = shift;
        my @arr = split(/\n/,$tmp);
        my $txt = join(" ",@arr);
        &get_host($txt);
        @arr = split(/ERROR|schema=.*\]/,$txt);
        print &trans_line($arr[-1]);
        print ";\n";
}

sub trans_line{
        my $aaa = shift;
        $aaa =~ s/\s+/ /g;
        $aaa =~ s/^\s+|\s+$//g;
        $aaa =~ s/ ;/;/g;
        return $aaa;
}

sub phaser_warn{
        my $tmp = shift;
        &get_host($tmp);
        my @arr = split(/schema=.*\]/,$tmp);
        my $aaa = &trans_line($arr[-1]);
        if($aaa =~ /\{|\}/){
                my @bbb = split(/\{|\}/,$aaa);
                if ($#bbb > 1){
                        print &trans_line($bbb[-1]).";".&trans_line($bbb[1]).";\n";
                }else{
                        print &trans_line($bbb[1])."\n";
                }
        }else{
                print  "$aaa;\n";
        }
}


use Data::Dumper;

sub get_warn{
        my $tmp = shift;
        my @arr = split(/\n/,$tmp);
        my $msg = "";
        my $sql = "";
        for(my $i=0;$i<=$#arr;$i++){
                if($arr[$i] =~ /WARN  .*\[/){
                        my $txt = "";
                        $txt = join(" ",@arr[$i .. $#arr]);
                        if($arr[$i] =~ /\]dnDocdb\d+\.default\{/){
                                $txt = join(" ",@arr[$i .. $#arr]);
                        }else{
                                $txt = join(" ",@arr[$i .. $#arr]);
                                $txt =~ s/\]/\]\{/;
                                $txt =~ s/^java/^java\}/;
                        }
                        &phaser_warn($txt);
                        last;
                }
                if($arr[$i] =~ /^java/){
                        my $txt = join(" ",@arr[$i .. $#arr]);
                        &phaser_warn($txt);
                        last;
                }
                if($arr[$i] =~ /\s+MSG:/){
                        $msg = $arr[$i];
                        $msg =~ s/\s+MSG://;
                }
                if($arr[$i] =~ /\s+ROUTE:/){
                        &get_host($arr[$i]);
                }
                if($arr[$i] =~ /\s+SQL:/){
                        $sql = join(" ",@arr[$i .. $#arr]);
                        $sql =~ s/\s+SQL://;
                        $sql =~ s/\s+/ /g;
                        print "$msg;$sql;\n";
                        last;
                }
        }
}
