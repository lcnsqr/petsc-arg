# Output to SVG, with Verdana 8pt font
set terminal svg size 800,600 enhanced font "sans-serif,14"

# Thinner, filled bars
set boxwidth 0.4
set style fill solid 1.00 

# Set a title and Y label. The X label is obviously months, so we don't set it.
set title "SDumont: Experiments distribution by time (GPU)" font ",22" tc rgb "#606060"
set ylabel "Experiments"

set xlabel "Seconds"

# Rotate X labels and get rid of the small stripes at the top (nomirror)
set xtics right rotate by 45 offset 0,0
#set xtics offset 0 center

# Show human-readable Y-axis. E.g. "100 k" instead of 100000.
#set format y '%.0s %c'

# Replace small stripes on the Y-axis with a horizontal gridlines
set tic scale 0
set grid ytics lc rgb "#505050" lw 1

# Remove border around chart
unset border

# Manual set the Y-axis range
#set yrange [100000 to 300000]

set output 'gpu.svg'
set boxwidth 1
set style data histograms
plot "gpu.dat" using 2:xtic(1) notitle lt rgb "#3465a4"
