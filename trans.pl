while(<>){
        if(/^(\d+:\d+:\d+,\d+)/){
                print "##$_";
        }else{
                print "$_";
        }
}
