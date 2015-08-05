# cobar log phaser

```
ls stdout.log.2015-07-* |awk '{print"perl trans.pl "$0"|perl cobar-trans-log.pl - >"$0".info"}' |sh

ls stdout.log.2015-07-*.info |awk '{print "perl stat.info.pl "$0" >"$0".stat"}' |sh

ls stdout.log.2015-07-*.info.stat|awk '{print "sort -t \";\" -k2,2 -k1,1rn "$0"|perl add_ip.pl - >"$0".sort.csv";}' |sh
```

