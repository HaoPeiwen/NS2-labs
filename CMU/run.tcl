set seed [exec ./RandomNumber] ;#get a random number as seed

puts "seed is $seed" 

puts "creating 50 random nodes"



exec /home/public/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/setdest/setdest -n 50 -p 0 -M 200 -t 50 -x 900 -y 900 > RandomDest.txt; 

#creat 50 random nodes by setdest, output to file RandomDest.txt; The route depends on different computers.



puts "creating nodes done"

puts "creating random cbr stream"



exec ns /home/public/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn 50 -mc 30 -rate 1.5 -seed $seed > RandomCbr.txt;

#creat 50 nodes' random cbr stream by cbrgen.tcl, output to file RandomCbr.txt; The route depends on different computers.



puts "creating cbr stream done\n"

puts "-------------Simulation-------------"



source RandomScene.tcl ;#run simulatior