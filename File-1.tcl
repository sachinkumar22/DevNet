::cisco::eem::event_register_timer countdown time 10 maxrun 120000000

#  
#  Debugging TCL script
#
#  Dec 2015
#
#  Copyright (c) 2014-2015 by cisco Systems, Inc.
#  All rights reserved.
#
#

namespace import ::cisco::eem::*
namespace import ::cisco::lib::*

puts "Debug Logs started collecting..."

set filename Self_IP_Ping_Validation_Debug_File
set fd [open "$filename" a+]

set flag 0

if [catch {cli_open} result] {
error $result $errorInfo
} else {
array set cli1 $result
}

if [catch {cli_exec $cli1(fd) "en"} result] {
error $result $errorInfo
}





set clist [list "conf t" "platform shell" "end"]
foreach config_list $clist {
if [catch {cli_exec $cli1(fd) "$config_list"} result] {
error $result $errorInfo
}
}



set loop_flag 1

# Phase 1: issue the command
if [catch {cli_write $cli1(fd) "request platform software system shell"} result] {
error $result $errorInfo
}

if [catch {cli_read_pattern $cli1(fd) ".*continue.*"} result] {
error $result $errorInfo
}
# write a newline character
if [catch {cli_write $cli1(fd) "y"} result] {
error $result $errorInfo
}

if [catch {cli_read_pattern $cli1(fd) ".*_RP.*$" } result] {
error $result $errorInfo
}

if [catch {cli_write $cli1(fd) "/tmp/sw/fp/0/0/fp/mount/usr/binos/conf/sdcli_start.sh"} result] {
 error $result $errorInfo
}
if [catch {cli_read_pattern $cli1(fd) "sdcli#" } result] {
 error $result $errorInfo
}
set ChannelCompact_list {{nile debug stats 0 ChannelCompact} {nile debug stats 1 ChannelCompact}}
set EgressHeaderBufferProcessor_list {{nile debug stats 0 EgressHeaderBufferProcessor} {nile debug stats 1 EgressHeaderBufferProcessor}}
set ingress_mmap_i_read_list {{arsenic mmap i_read 0x45 0008010c} {arsenic mmap i_read 0x45 0009010c} {arsenic mmap i_read 0x45 0026010c} {arsenic mmap i_read 0x40 0008010c} {arsenic mmap i_read 0x40 0009010c} {arsenic mmap i_read 0x40 0026010c}}
set ingress_fixptokenout_list {{nile pp reg fixptokenout show 0 0} {nile pp reg fixptokenin show 0 0} {nile pp reg fixptokenout show 1 0} {nile pp reg fixptokenin show 1 0}}
set egress_fixptokenout_list {{nile pp reg egrfixptokenin show 0 0} {nile pp reg egrfixptokenout show 0 0} {nile pp reg egrfixptokenin show 1 0} {nile pp reg egrfixptokenout show 1 0}}
set EgressReceive_list {{nile debug stats 0 EgressReceive} {nile debug stats 1 EgressReceive}}

foreach ChannelCompact $ChannelCompact_list {
if [catch {cli_write $cli1(fd) "$ChannelCompact"} result] {
error $result $errorInfo
}

set cmd_out [ cli_read_pattern $cli1(fd) "sdcli#" ] 
 
if {![regexp -nocase {.*ChCompactChecksumerrorCount +0 +.0x[0-9a-f].} $cmd_out]} {
puts $fd "Failure seen at $ChannelCompact in level1 egress"
puts $fd "ChannelCompact output:\n $cmd_out"



puts "Flavour of Self IP Ping Issue has been seen"
puts $fd "Flavour of Self IP Ping Issue has been seen"


} 
}

foreach EgressReceive $EgressReceive_list {
for {set i 1} {$i<=6} {incr i} {
after 2000	
if [catch {cli_write $cli1(fd) "$EgressReceive"} result] {
error $result $errorInfo
}

set cmd_out [ cli_read_pattern $cli1(fd) "sdcli#" ] 
 
if {$i  == 1} {
     if {[regexp -nocase {.*ERxSobCount +([0-9]+) +.0x[0-9a-f]+.*ERxEobCount +([0-9]+) +.0x[0-9a-f]+.*ERxHeaderCount +([0-9]+) +.0x[0-9a-f]+.*ERxAbortCount +([0-9]+) +.0x[0-9a-f].} $cmd_out match ERxSobCount_1 ERxEobCount_1 ERxHeaderCount_1 ab_count_1]} {
	}
} else {
	if {[regexp -nocase {.*ERxSobCount +([0-9]+) +.0x[0-9a-f]+.*ERxEobCount +([0-9]+) +.0x[0-9a-f]+.*ERxHeaderCount +([0-9]+) +.0x[0-9a-f]+.*ERxAbortCount +([0-9]+) +.0x[0-9a-f].} $cmd_out match ERxSobCount_2 ERxEobCount_2 ERxHeaderCount_2 ab_count_2]} {
		if {(($ERxSobCount_2 == 0) || ($ERxSobCount_1 != $ERxSobCount_2)) && (($ERxEobCount_2 == 0) || ($ERxEobCount_1 != $ERxEobCount_2)) && (($ERxHeaderCount_2 == 0) || ($ERxHeaderCount_1 != $ERxHeaderCount_2)) && (($ab_count_1 == 0) && ($ab_count_2 == 0))} {
			set ERxSobCount_1 $ERxSobCount_2
			set ERxEobCount_1 $ERxEobCount_2
			set ERxHeaderCount_1 $ERxHeaderCount_2
		} else {
		puts $fd "Failure seen at $EgressReceive in level1 ingress"
		puts $fd "EgressReceive output:\n $cmd_out"
		puts $fd "ERxSobCount_1 ===> $ERxSobCount_1"
		puts $fd "ERxEobCount_1 ===> $ERxEobCount_1"
		puts $fd "ERxHeaderCount_1 ===> $ERxHeaderCount_1"
		puts $fd "ERxSobCount_2 ===> $ERxSobCount_2"
		puts $fd "ERxEobCount_2 ===> $ERxEobCount_2"
		puts $fd "ERxHeaderCount_2 ===> $ERxHeaderCount_2"
		puts $fd "ab_count_1===> $ab_count_1"
		puts $fd "ab_count_2===> $ab_count_2"






}
}
}
}
}

foreach ingress_mmap_i_read $ingress_mmap_i_read_list {
for {set i 0} {$i < 2} {incr i} {
after 10000		
if [catch {cli_write $cli1(fd) "$ingress_mmap_i_read"} result] {
error $result $errorInfo
}

set cmd_out [ cli_read_pattern $cli1(fd) "sdcli#" ] 

if {![regexp -nocase {.*result=00000000} $cmd_out]} {
puts $fd "Failure seen at $ingress_mmap_i_read in level1 ingress"
puts $fd "ingress_mmap_i_read output:\n $cmd_out"



puts "Flavour of Self IP Ping Issue has been seen"
puts $fd "Flavour of Self IP Ping Issue has been seen"

}
}
}

foreach ingress_fixptokenout $ingress_fixptokenout_list {
for {set i 1} {$i<=6} {incr i} {
after 10000	
if [catch {cli_write $cli1(fd) "$ingress_fixptokenout"} result] {
error $result $errorInfo
}

set cmd_out [ cli_read_pattern $cli1(fd) "sdcli#" ] 

set Token_Stuck 0
 
if {$i  == 1} {
     if {[regexp -nocase {.*EAMapper += +([0-9]+) +.0x[0-9a-f].*LMapper += +([0-9]+) +.0x[0-9a-f]..*PMapper += +([0-9]+) +.0x[0-9a-f].} $cmd_out match ea_mapper1 l_mapper1 p_mapper1]} {
	     }
	} else {
	if {[regexp -nocase {.*EAMapper += +([0-9]+) +.0x[0-9a-f].*LMapper += +([0-9]+) +.0x[0-9a-f]..*PMapper += +([0-9]+) +.0x[0-9a-f].} $cmd_out match ea_mapper2 l_mapper2 p_mapper2]} {
		 if {(($ea_mapper2 == 0) || ($ea_mapper1 != $ea_mapper2)) && (($l_mapper2 == 0) || ($l_mapper1 != $l_mapper2)) && (($p_mapper2 == 0) || ($p_mapper1 != $p_mapper2))} {
		  	set ea_mapper1 $ea_mapper2
			set l_mapper1 $l_mapper2
			set p_mapper1 $p_mapper2
		} else {
		puts $fd "Failure seen at $ingress_fixptokenout in level1 ingress"
puts $fd "ingress_fixptokenout output:\n $cmd_out"
puts $fd "ea_mapper1 ===> $ea_mapper1"
puts $fd "ea_mapper2 ===> $ea_mapper2"
puts $fd "l_mapper1 ===> $l_mapper1"
puts $fd "l_mapper2 ===> $l_mapper2"
puts $fd "p_mapper1 ===> $p_mapper1"
puts $fd "p_mapper2 ===> $p_mapper2"

set Token_Stuck 1

}
}
}
}
if {$Token_Stuck == 1} {
puts "Flavour of Self IP Ping Issue has been seen"
puts $fd "Flavour of Self IP Ping Issue has been seen"
}
}

foreach egress_fixptokenout $egress_fixptokenout_list {
for {set i 1} {$i<=6} {incr i} {
after 10000	
if [catch {cli_write $cli1(fd) "$egress_fixptokenout"} result] {
error $result $errorInfo
}

set cmd_out [ cli_read_pattern $cli1(fd) "sdcli#" ] 
set Token_Stuck 0 
if {$i  == 1} {
     if {[regexp -nocase {.*EAMapper += +([0-9]+) +.0x[0-9a-f].*LMapper += +([0-9]+) +.0x[0-9a-f]..*PMapper += +([0-9]+) +.0x[0-9a-f].} $cmd_out match ea_mapper1 l_mapper1 p_mapper1]} {
	}
} else {
	if {[regexp -nocase {.*EAMapper += +([0-9]+) +.0x[0-9a-f].*LMapper += +([0-9]+) +.0x[0-9a-f]..*PMapper += +([0-9]+) +.0x[0-9a-f].} $cmd_out match ea_mapper2 l_mapper2 p_mapper2]} {
		if {(($ea_mapper2 == 0) || ($ea_mapper1 != $ea_mapper2)) && (($l_mapper2 == 0) || ($l_mapper1 != $l_mapper2)) && (($p_mapper2 == 0) || ($p_mapper1 != $p_mapper2))} {
		    set ea_mapper1 $ea_mapper2
			set l_mapper1 $l_mapper2
			set p_mapper1 $p_mapper2
		} else {
		puts $fd "Failure seen at $egress_fixptokenout in level1 ingress"
puts $fd "egress_fixptokenout output:\n $cmd_out"
puts $fd "ea_mapper1 ===> $ea_mapper1"
puts $fd "ea_mapper2 ===> $ea_mapper2"
puts $fd "l_mapper1 ===> $l_mapper1"
puts $fd "l_mapper2 ===> $l_mapper2"
puts $fd "p_mapper1 ===> $p_mapper1"
puts $fd "p_mapper2 ===> $p_mapper2"



set Token_Stuck 1




}
}
}
}
if {$Token_Stuck == 1} {
puts "Flavour of Self IP Ping Issue has been seen"
puts $fd "Flavour of Self IP Ping Issue has been seen"
}
}

foreach EgressHeaderBufferProcessor $EgressHeaderBufferProcessor_list {
for {set i 1} {$i<=6} {incr i} {
after 2000	
if [catch {cli_write $cli1(fd) "$EgressHeaderBufferProcessor"} result] {
error $result $errorInfo
}

set cmd_out [ cli_read_pattern $cli1(fd) "sdcli#" ] 
 
 if {$i  == 1} {
    if {[regexp -nocase {.*EHBPCredit0 +([0-9]+) +.0x[0-9a-f].*EHBPCredit1 +([0-9]+) +.0x[0-9a-f]} $cmd_out match EHBPCredit_1(0) EHBPCredit_1(1)]} {
	regexp -nocase {.*EHBPCredit2 +([0-9]+) +.0x[0-9a-f].*EHBPCredit3 +([0-9]+) +.0x[0-9a-f]} $cmd_out match EHBPCredit_1(2) EHBPCredit_1(3)
    regexp -nocase {.*EHBPCredit4 +([0-9]+) +.0x[0-9a-f].*EHBPCredit5 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(4) EHBPCredit_1(5) 
    regexp -nocase {.*EHBPCredit6 +([0-9]+) +.0x[0-9a-f].*EHBPCredit7 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(6) EHBPCredit_1(7)
    regexp -nocase {.*EHBPCredit8 +([0-9]+) +.0x[0-9a-f].*EHBPCredit9 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(8) EHBPCredit_1(9) 
    regexp -nocase {.*EHBPCredit10 +([0-9]+) +.0x[0-9a-f].*EHBPCredit11 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(10) EHBPCredit_1(11) 
    regexp -nocase {.*EHBPCredit12 +([0-9]+) +.0x[0-9a-f].*EHBPCredit13 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(12)  EHBPCredit_1(13) 
    regexp -nocase {.*EHBPCredit14 +([0-9]+) +.0x[0-9a-f].*EHBPCredit15 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(14) EHBPCredit_1(15) 
    regexp -nocase {.*EHBPCredit16 +([0-9]+) +.0x[0-9a-f].*EHBPCredit17 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(16) EHBPCredit_1(17) 
    regexp -nocase {.*EHBPCredit18 +([0-9]+) +.0x[0-9a-f].*EHBPCredit19 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(18) EHBPCredit_1(19)
    regexp -nocase {.*EHBPCredit20 +([0-9]+) +.0x[0-9a-f].*EHBPCredit21 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(20) EHBPCredit_1(21) 
    regexp -nocase {.*EHBPCredit22 +([0-9]+) +.0x[0-9a-f].*EHBPCredit23 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_1(22) EHBPCredit_1(23)
    }
  } else {
    if {[regexp -nocase {.*EHBPCredit0 +([0-9]+) +.0x[0-9a-f].*EHBPCredit1 +([0-9]+) +.0x[0-9a-f]} $cmd_out match EHBPCredit_2(0) EHBPCredit_2(1)]} {
	regexp -nocase {.*EHBPCredit2 +([0-9]+) +.0x[0-9a-f].*EHBPCredit3 +([0-9]+) +.0x[0-9a-f]} $cmd_out match EHBPCredit_2(2) EHBPCredit_2(3)
    regexp -nocase {.*EHBPCredit4 +([0-9]+) +.0x[0-9a-f].*EHBPCredit5 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(4) EHBPCredit_2(5) 
    regexp -nocase {.*EHBPCredit6 +([0-9]+) +.0x[0-9a-f].*EHBPCredit7 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(6) EHBPCredit_2(7)
    regexp -nocase {.*EHBPCredit8 +([0-9]+) +.0x[0-9a-f].*EHBPCredit9 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(8) EHBPCredit_2(9) 
    regexp -nocase {.*EHBPCredit10 +([0-9]+) +.0x[0-9a-f].*EHBPCredit11 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(10) EHBPCredit_2(11) 
    regexp -nocase {.*EHBPCredit12 +([0-9]+) +.0x[0-9a-f].*EHBPCredit13 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(12)  EHBPCredit_2(13) 
    regexp -nocase {.*EHBPCredit14 +([0-9]+) +.0x[0-9a-f].*EHBPCredit15 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(14) EHBPCredit_2(15) 
    regexp -nocase {.*EHBPCredit16 +([0-9]+) +.0x[0-9a-f].*EHBPCredit17 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(16) EHBPCredit_2(17) 
    regexp -nocase {.*EHBPCredit18 +([0-9]+) +.0x[0-9a-f].*EHBPCredit19 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(18) EHBPCredit_2(19)
    regexp -nocase {.*EHBPCredit20 +([0-9]+) +.0x[0-9a-f].*EHBPCredit21 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(20) EHBPCredit_2(21) 
    regexp -nocase {.*EHBPCredit22 +([0-9]+) +.0x[0-9a-f].*EHBPCredit23 +([0-9]+) +.0x[0-9a-f].} $cmd_out match EHBPCredit_2(22) EHBPCredit_2(23)
        set flag 0
	}
        while {$flag <= 23} {
		if {($EHBPCredit_2($flag) == 0) || ($EHBPCredit_1($flag) != $EHBPCredit_2($flag))} {
			set EHBPCredit_1($flag)  $EHBPCredit_2($flag) 			
		} else {
		puts $fd "EHBPCredit output is: $cmd_out"
		puts $fd "EHBPCredit_1($flag) ---> $EHBPCredit_1($flag)"
		puts $fd "EHBPCredit_2($flag) ---> $EHBPCredit_2($flag)"



}
        incr flag
        }
	}
  }
}
if [catch {cli_write $cli1(fd) "exit"} result] {
	error $result $errorInfo
}

if [catch {cli_read_pattern $cli1(fd) ".*_RP.*$" } result] {
	error $result $errorInfo
}

if [catch {cli_write $cli1(fd) "exit"} result] {
	error $result $errorInfo
}

if [catch {cli_read_pattern $cli1(fd) ".*#" } result] {
	error $result $errorInfo
}

after 2000

if [catch {cli_write $cli1(fd) "show clock"} result] {
error $result $errorInfo
}

set result [ cli_read_pattern $cli1(fd) ".*#" ]


puts $fd "show clock ===> $result"
unset i

set clist [list "conf t" "no event manager policy Debug_Self_IP_Ping_Flavours.tcl" "end" "conf t" "no event manager policy Debug_Self_IP_Ping_Flavours.tcl" "end"]
puts "Debug Logs are collected successfully..."
puts $fd "Debug Logs are collected successfully..."
foreach unconfig $clist {
puts $fd $unconfig	
if [catch {cli_exec $cli1(fd) "$unconfig"} result] {
error $result $errorInfo
}
}

if [catch {cli_close $cli1(fd) $cli1(tty_id)} result] {
error $result $errorInfo
}

