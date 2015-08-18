$/="##########";
<>;
while(my $line=<>){
        chomp $line;
#=pod
        if($line =~ /(\d+:\d+:\d+,\d+) INFO/){
                print $1.";INFO;";
                &get_info($line);
        }
        if ($line =~ /(\d+:\d+:\d+,\d+) ERROR/) {
                print $1.";ERROR;";
                &get_error($line);
        }
#=cut
        if($line =~ /(\d+:\d+:\d+,\d+) WARN/){
                print $1.";WARN;";
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
        if($txt =~ /schema=.*\]/){
                #print "\n$txt\n";
                my $start = index($txt,"\]");
                #print "\n$start\n";
                print &trans_line(substr($txt,$start + 1));
        }else{
                @arr = split(/ERROR/,$txt);
                print &trans_line($arr[-1]);
        }
        #@arr = split(/ERROR|schema=.*\]/,$txt);
        #print &trans_line($arr[-1]);
        print ";\n";
}

sub trans_line{
        my $aaa = shift;
        $aaa =~ s/\s+/ /g;
        $aaa =~ s/^\s+|\s+$//g;
        $aaa =~ s/ ;/;/g;
        return $aaa;
}

sub get_warn {
        my $tmp = shift;
        my @arr = split(/\n/,$tmp);
        my $txt = join(" ",@arr);
        &get_host($txt);
        $txt =~ s/MSG:/####;/;
        $txt =~ s/ROUTE:/####;/;
        $txt =~ s/SQL:/####;/;
        if($txt =~ /####;/){
                my @bbb = split(/####;/,$txt);
                print &trans_line($bbb[1]).";".&trans_line($bbb[-1]);
        }elsif($txt =~ /default\{/ && $txt =~ /\}/){
                my $start = index($txt,"\{");
                my $end   = rindex($txt,"\}");
                my $sql   = substr($txt,$start+1,$end -$start -1);
                my $msg   = substr($txt,$end+1);
                #print "\n$txt\n";
                #print "\n$start\n";
                #print "\n$end\n";
                print &trans_line($msg).";".&trans_line($sql);
        }else{
                @bbb = ($txt =~ /\]/) ? split(/\]/,$txt) : split(/WARN/,$txt);
                if ($bbb[-1] =~ /java/) {
                        my $start = index($bbb[-1],"java");
                        my $sql   = substr($bbb[-1],0,$start - 1 );
                        my $msg   = substr($bbb[-1],$start);
                        print &trans_line($msg).";".&trans_line($sql);
                }else{
                        print &trans_line($bbb[-1]);
                }
        }
        #print &trans_line($txt);
        print ";\n";
}

sub phaser_warn{
        my $tmp = shift;
        &get_host($tmp);
        my @arr = split(/schema=.*\]/,$tmp);
        my $aaa = &trans_line($arr[-1]);
        if($aaa =~ /\#\#\#\#\{|\#\#\#\#\}/){
                #print "\n$aaa\n";
                my @bbb = split(/\#\#\#\#\{|\#\#\#\#\}/,$aaa);
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

=pod
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
                                $txt =~ s/\.default\{/\.default\#\#\#\#\{/;
                                $txt =~ s/\} java/\#\#\#\#\}java/;
                                #&phaser_warn($txt);
                        }else{
                                $txt = join(" ",@arr[$i .. $#arr]);
                                $txt =~ s/\]/\]\#\#\#\#\{/;
                                $txt =~ s/java/\#\#\#\#\}java/;
                                $txt =~ s/at \#\#\#\#\}java/at java/g;
                                #&phaser_warn($txt);
                        }
                        &phaser_warn($txt);
                        last;
                }
                if($arr[$i] =~ /java/){
                        my $txt = join(" ",@arr[$i .. $#arr]);
                        $txt =~ s/java/\#\#\#\#\}java/;
                        $txt =~ s/at \#\#\#\#\}java/at java/g;
                        &phaser_warn($txt);
                        last;
                }
#=pod
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
                        print  &trans_line($msg).";". &trans_line($sql).";\n";
                        last;
                }
#=cut
        }
}
=cut

