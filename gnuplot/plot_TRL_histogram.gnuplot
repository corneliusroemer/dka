load "../gnuplot/template.gnuplot"

set output '../plots_de/plot_TRL_histogram.png'

# get last update
date_cmd = sprintf("%s", "`awk -F, '{print "@"$1+3600}' ../data_CWA/transmission_risk_level_statistics.csv | tail -n 2 | head -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 (Stand: " . date_cmd . "; Quelle: Corona-Warn-App)}"

# sum of keys
stats "<awk -F, '{if ($1==0) {print $2+$3+$4+$5+$6+$7+$8+$9}}' ../data_CWA/transmission_risk_level_statistics.csv" using 1 name "K" nooutput
Sum_Keys = K_max / 100.0

# y-axis setup
unset ylabel

# key
unset key

# grid
unset grid 
set grid ytics ls 21 lc rgb '#aaaaaa'

# bars
set boxwidth 0.75
set style fill solid 1.00 
set style data histograms
set style histogram clustered gap 1

set xtics rotate by 0 offset 0, -0.30
set xtics ( "1" 1, "2" 2, "3" 3, "4" 4, "5" 5, "6" 6, "7" 7, "8" 8 )

set xrange [ 9 : 0 ] reverse

set offsets 0.00, 0.00, graph 0.25, 0.00
set datafile separator ","

##################################### German

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Verteilung der TRL in Diagnoseschlüsseln}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot  \
  for [i=1:9] "<awk -F, '{if ($1==0) {print $0}}' ../data_CWA/transmission_risk_level_statistics.csv" using (i-1):(column(i)) with boxes lt rgb "#72777e" notitle, \
  \
  for [i=1:9] "<awk -F, '{if ($1==0) {print $0}}' ../data_CWA/transmission_risk_level_statistics.csv" using (i-1):i:(column(i)>0?sprintf("%d\n(%.1f%%)", column(i), column(i)/Sum_Keys):"") with labels offset 0, graph 0.10 lt rgb "#72777e"

##################################### English

set output '../plots_en/plot_TRL_histogram.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"$1+3600}' ../data_CWA/transmission_risk_level_statistics.csv | tail -n 2 | head -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 (last update: " . date_cmd_en . "; source: Corona-Warn-App)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Distribution of the transmission risk level in diagnosis keys}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot  \
  for [i=1:9] "<awk -F, '{if ($1==0) {print $0}}' ../data_CWA/transmission_risk_level_statistics.csv" using (i-1):(column(i)) with boxes lt rgb "#72777e" notitle, \
  \
  for [i=1:9] "<awk -F, '{if ($1==0) {print $0}}' ../data_CWA/transmission_risk_level_statistics.csv" using (i-1):i:(column(i)>0?sprintf("%d\n(%.1f%%)", column(i), column(i)/Sum_Keys):"") with labels offset 0, graph 0.10 lt rgb "#72777e"
