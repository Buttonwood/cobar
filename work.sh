
perl phaser_sql.pl slow-query.log >slow-query.log.csv
perl stat_keys.pl slow-query.log.csv >slow-query.log.keys.csv

mkdir tmp
perl grep.pl stat.keys.sort.csv slow-query.log.keys.csv

cd tmp
cp ../date_stat.pl ./
mkdir stat
ls *.csv |awk -F '.' '{print "perl date_stat.pl "$1".csv\t>./stat/"$1".stat.csv";}' |sh

cd stat
cp ../../plot.R ./
mkdir html
ls *.stat.csv |awk '{print "R -f plot.R "$0" "$0".num.html "$0".time.html" }' |sh
