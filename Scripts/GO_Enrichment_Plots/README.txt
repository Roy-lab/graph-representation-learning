#######
Step 1: Prepare a table.txt file to be plotted. Row and column headers are required. See input_table.txt for an example.
#######


#######
Step 2: Run general_table_to_heatmapawk.pl and save as [FILENAME].hmawk
#######
 USAGE: ./general_table_to_heatmapawk.pl [input_table.txt] [row_size_#] [col_size_#] ["on"/"off"] > input_table.hmawk
	- row_size_# / col_size_# : size of the height / width of the heatmap cells in the figure
	- on/off : switch for visualizing given number inside the cell or not (default:off)

  e.g.	./general_table_to_heatmapawk.pl input_table.txt 16 16 > input_table.hmawk
	./general_table_to_heatmapawk.pl input_table.txt 16 16 on > input_table_on.hmawk


#######
Step 3: Plot the figure. This will generate two types of results (svg and png) automatically.
#######
 USAGE: ./draw_heatmap_awk_default.sh [input_table.hmawk] [MAX_value]
	- MAX_value : maximum value for the heatmap color range, e.g. "1" for binary, "10" if your max value in the table is 10, etc.

  e.g.	./draw_heatmap_awk_default.sh input_table.hmawk 1


#######
Step 4: (optional) See the result figure and re-draw figure by adjusting param
#######

