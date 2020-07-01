load "template.gnuplot"

set output '../plot_rki_cases.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../daily_data/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.5 * 86400 : STATS_max + 3.0 * 86400 ]

# stats for y
stats "<awk -F, '{if ( $1 >= 1592784000 ) print $3}' ../data_RKI/cases_germany_rki.csv" using 1 nooutput
set yrange [ 0 : 10*(1+int(int(1.25*STATS_max)/10.0)) ]

# x-axis setup
unset xlabel
set xdata time
set timefmt "%s"
set format x "%d.%m."

# y-axis setup
unset ylabel

# key
unset key

set boxwidth 0.75*86400
set style fill solid 1.00

# date
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_RKI/cases_germany_rki.csv | tail -n 1 | xargs date +"%d.%m." -d`")
update_str = "{/*0.75 (letztes Update: " . date_cmd . "; Quelle: Robert Koch-Institut)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold täglich an das RKI gemeldete Neuinfektionen (COVID-19)}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

set offsets 0.00, 0.00, graph 0.15, 0.00

# data
plot  \
  "<awk -F, '{if ( NR > 1 ) print $1+2*3600, $3}' ../data_RKI/cases_germany_rki.csv" using 1:2 with boxes ls 7 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$1;c=b;b=$3; print a, b, b-c}}' ../data_RKI/cases_germany_rki.csv" using 1:2:(sprintf("{/*0.85 %i}", $2)) with labels point ls 2 ps 0.0 center offset char 0.0, 0.80 tc ls 10 notitle
