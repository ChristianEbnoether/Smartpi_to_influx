#!/bin/bash 

sleeptime=0.1

get_curl () {
curl  http://192.168.97.104:9246/metrics > smartpitemp.txt
}

get_data () {
    COUNTER=0
    while [  $COUNTER -le 1 ]; do
    
	VAR_A=`cat smartpitemp.txt | grep smartpi_reactive_power_volt_amps | grep A| grep -o '[0-9]\+.[0-9]\+'`
	VAR_B=`cat smartpitemp.txt | grep smartpi_reactive_power_volt_amps | grep B| grep -o '[0-9]\+.[0-9]\+'`
	VAR_C=`cat smartpitemp.txt | grep smartpi_reactive_power_volt_amps | grep C| grep -o '[0-9]\+.[0-9]\+'`    
    
	PFR_A=`cat smartpitemp.txt | grep power_factor_ratio | grep A| grep -o '[0-9]\+.[0-9]\+'`
	PFR_B=`cat smartpitemp.txt | grep power_factor_ratio | grep B| grep -o '[0-9]\+.[0-9]\+'`
	PFR_C=`cat smartpitemp.txt | grep power_factor_ratio | grep C| grep -o '[0-9]\+.[0-9]\+'`
	    
	A_A=`cat smartpitemp.txt | grep smartpi_phase_angle | grep A| grep -o '[0-9]\+.[0-9]\+'`
	A_B=`cat smartpitemp.txt | grep smartpi_phase_angle | grep B| grep -o '[0-9]\+.[0-9]\+'`
	A_C=`cat smartpitemp.txt | grep smartpi_phase_angle | grep C| grep -o '[0-9]\+.[0-9]\+'`


	f_A=`cat smartpitemp.txt | grep smartpi_frequency_hertz | grep A| grep -o '[0-9]\+.[0-9]\+'`
	f_B=`cat smartpitemp.txt | grep smartpi_frequency_hertz | grep B| grep -o '[0-9]\+.[0-9]\+'`
	f_C=`cat smartpitemp.txt | grep smartpi_frequency_hertz | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	V_A=`cat smartpitemp.txt | grep smartpi_volts | grep A| grep -o '[0-9]\+.[0-9]\+'`
	V_B=`cat smartpitemp.txt | grep smartpi_volts | grep B| grep -o '[0-9]\+.[0-9]\+'`
	V_C=`cat smartpitemp.txt | grep smartpi_volts | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	W_A=`cat smartpitemp.txt | grep smartpi_active_watts | grep A| grep -o '[0-9]\+.[0-9]\+'`
	W_B=`cat smartpitemp.txt | grep smartpi_active_watts | grep B| grep -o '[0-9]\+.[0-9]\+'`
	W_C=`cat smartpitemp.txt | grep smartpi_active_watts | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	
	PVA_A=`cat smartpitemp.txt | grep apparent_power_volt_amps | grep A| grep -o '[0-9]\+.[0-9]\+'`
	PVA_B=`cat smartpitemp.txt | grep apparent_power_volt_amps | grep B| grep -o '[0-9]\+.[0-9]\+'`
	PVA_C=`cat smartpitemp.txt | grep apparent_power_volt_amps | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	
	I_A=`cat smartpitemp.txt | grep smartpi_amps | grep A| grep -o '[0-9]\+.[0-9]\+'`
	I_B=`cat smartpitemp.txt | grep smartpi_amps | grep B| grep -o '[0-9]\+.[0-9]\+'`
	I_C=`cat smartpitemp.txt | grep smartpi_amps | grep C| grep -o '[0-9]\+.[0-9]\+'`
	I_N=`cat smartpitemp.txt | grep smartpi_amps | grep N| grep -o '[0-9]\+.[0-9]\+'`
	let COUNTER=COUNTER+1
    done
    let COUNTER=COUNTER+1
} 

print_data () {
    echo "V_A: $test"
}

write_data () {
    #Write the data to the database
    
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=PVA,phase=L1 value=$PVA_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=PVA,phase=L2 value=$PVA_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=PVA,phase=L3 value=$PVA_C"    
    
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=PFR,phase=L1 value=$PFR_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=PFR,phase=L2 value=$PFR_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=PFR,phase=L3 value=$PFR_C"    
    
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=VAR,phase=L1 value=$VAR_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=VAR,phase=L2 value=$VAR_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=VAR,phase=L3 value=$VAR_C"    
    
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=Angle,phase=L1 value=$A_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=Angle,phase=L2 value=$A_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=Angle,phase=L3 value=$A_C"    
    
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=volt,phase=L1 value=$V_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=volt,phase=L2 value=$V_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=volt,phase=L3 value=$V_C"


    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=freq,phase=L1 value=$f_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=freq,phase=L2 value=$f_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=freq,phase=L3 value=$f_C"

    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=watt,phase=L1 value=$W_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=watt,phase=L2 value=$W_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=watt,phase=L3 value=$W_C"
    
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=strom,phase=L1 value=$I_A"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=strom,phase=L2 value=$I_B"
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=strom,phase=L3 value=$I_C" 
    curl -i -XPOST 'http://192.168.1.10:8086/write?db=smartpi' --data-binary "smartpi,host=192.168.1.10,sensor=strom,phase=N value=$I_N"   

}

#Prepare to start the loop and warn the user
while :
do
    #Sleep between readings
    sleep "$sleeptime"
    get_curl
    get_data
    #print_data
    write_data
done

