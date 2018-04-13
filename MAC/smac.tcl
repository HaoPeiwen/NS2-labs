#·ÂÕæ½Å±¾³ÌÐò lmac.tcl
#default script options
set opt(chan)    Channel/WirelessChannel 
set opt(prop)    Propagation/TwoRayGround 
set opt(netif)   Phy/WirelessPhy 
set opt(mac)     Mac/LMAC
set opt(ifq)     Queue/DropTail/PriQueue 
set opt(ll)      LL 
set opt(ant)     Antenna/OmniAntenna 
set opt(ifqlen)  50 
set opt(x)       1000 
set opt(y)       1000
set opt(rp)      AODV
set opt(start)   5.0
set opt(stop)    500.0
set opt(seed)    1.0
set opt(nn)      5       
set opt(energymodel)         EnergyModel
set opt(initialenergy)       1000
set opt(receivepower)        0.3682
set opt(transmitpower)       0.386
set opt(idlepower)           0.3442
set opt(sleeppower)          5.0e-5


#Turning on/off sleep-wakeup cycles for SMAC
Mac/LMAC set syncFlag_ 1

#duty cycle in SMAC
Mac/LMAC set dutyCycle_ 60



set ns_ [new Simulator]
set chan [new $opt(chan)]          
set topo [new Topography]
$topo load_flatgrid $opt(x) $opt(y)
set tracefd [open L-MAC.tr w]
$ns_ trace-all $tracefd
set namtrace [open L-MAC.nam w]
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)
set god_ [create-god $opt(nn)]

$ns_ node-config -adhocRouting $opt(rp)\
                 -llType $opt(ll)\
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -propType $opt(prop) \
                 -phyType $opt(netif) \
                 -channel $chan \
                 -topoInstance $topo \
                 -energyModel $opt(energymodel)\
                 -txPower $opt(transmitpower)\
                 -rxPower $opt(receivepower)\
                 -idlePower $opt(idlepower)\
                 -sleepPower $opt(sleeppower)\
                 -initialEnergy   $opt(initialenergy)\
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \

#create the number of nodes               
for {set i 0} {$i < $opt(nn)} {incr i} {
     set node_($i) [$ns_ node]
     $node_($i) random-motion 0
}



$node_(0) set X_ 500.0
$node_(0) set Y_ 500.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 300.0
$node_(1) set Y_ 500.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 500.0
$node_(2) set Y_ 300.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 700.0
$node_(3) set Y_ 500.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 500.0
$node_(4) set Y_ 700.0
$node_(4) set Z_ 0.0



#definr traffic model
set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(1) $udp_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 512
$cbr_(1) set interval_ 0.05
$cbr_(1) set random_ 0
$cbr_(1) set maxpkts_ 1000
$cbr_(1) attach-agent $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $node_(3) $null_(1)
$ns_ connect $udp_(1) $null_(1)
$ns_ at $opt(start) "$cbr_(1) start"



set udp_(2) [new Agent/UDP]
$ns_ attach-agent $node_(2) $udp_(2)
set cbr_(2) [new Application/Traffic/CBR]
$cbr_(2) set packetSize_ 512
$cbr_(2) set interval_ 2.0
$cbr_(2) set random_ 0
$cbr_(2) set maxpkts_ 1000
$cbr_(2) attach-agent $udp_(2)
set null_(2) [new Agent/Null]
$ns_ attach-agent $node_(4) $null_(2)
$ns_ connect $udp_(2) $null_(2)
$ns_ at $opt(start) "$cbr_(2) start"



# Define node initial position in nam
for {set i 0} {$i<$opt(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 100
}

# Tell nodes when the simulation ends
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop).0 "$node_($i) reset"
}

$ns_ at $opt(stop).0 "stop"
$ns_ at $opt(stop).01 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd namtrace
    $ns_ flush-trace
    close $tracefd
    close $namtrace
    exec nam L-MAC.nam &
    exit 0
}

puts "Starting Simulation..." 
$ns_ run
