#!/bin/bash 

sleeptime=0.05
hostip=192.168.97.249
get_curl () {
curl  -s http://192.168.97.249:9246/metrics -w 0.01 | grep -v "HELP go" | grep -v "#" > /ramdisk/smartpitemp.txt
}

get_data () {
    COUNTER=0
    while [  $COUNTER -le 1 ]; do
    
	VAR_A=`cat /ramdisk/smartpitemp.txt | grep smartpi_reactive_power_volt_amps | grep A| awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.[0-9]\+.[0-9]\+'`
	VAR_B=`cat /ramdisk/smartpitemp.txt | grep smartpi_reactive_power_volt_amps | grep B| awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.[0-9]\+.[0-9]\+'`
	VAR_C=`cat /ramdisk/smartpitemp.txt | grep smartpi_reactive_power_volt_amps | grep C| awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.[0-9]\+.[0-9]\+'`    
    
	PFR_A=`cat /ramdisk/smartpitemp.txt | grep power_factor_ratio | grep A| grep -o '[0-9]\+.[0-9]\+'`
	PFR_B=`cat /ramdisk/smartpitemp.txt | grep power_factor_ratio | grep B| grep -o '[0-9]\+.[0-9]\+'`
	PFR_C=`cat /ramdisk/smartpitemp.txt | grep power_factor_ratio | grep C| grep -o '[0-9]\+.[0-9]\+'`
	    
	A_A=`cat /ramdisk/smartpitemp.txt | grep smartpi_phase_angle | grep A| awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.*[0-9]\+.[0-9]\+'`
	A_B=`cat /ramdisk/smartpitemp.txt | grep smartpi_phase_angle | grep B| awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.*[0-9]\+.[0-9]\+'`
	A_C=`cat /ramdisk/smartpitemp.txt | grep smartpi_phase_angle | grep C| awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.*[0-9]\+.[0-9]\+'`


	f_A=`cat /ramdisk/smartpitemp.txt | grep smartpi_frequency_hertz | grep A| grep -o '[0-9]\+.[0-9]\+'`
	f_B=`cat /ramdisk/smartpitemp.txt | grep smartpi_frequency_hertz | grep B| grep -o '[0-9]\+.[0-9]\+'`
	f_C=`cat /ramdisk/smartpitemp.txt | grep smartpi_frequency_hertz | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	V_A=`cat /ramdisk/smartpitemp.txt | grep smartpi_volts | grep A| grep -o '[0-9]\+.[0-9]\+'`
	V_B=`cat /ramdisk/smartpitemp.txt | grep smartpi_volts | grep B| grep -o '[0-9]\+.[0-9]\+'`
	V_C=`cat /ramdisk/smartpitemp.txt | grep smartpi_volts | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	W_A=`cat /ramdisk/smartpitemp.txt | grep smartpi_active_watts | grep A | awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.[0-9]\+.[0-9]\+'`
	W_B=`cat /ramdisk/smartpitemp.txt | grep smartpi_active_watts | grep B | awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.[0-9]\+.[0-9]\+'`
	W_C=`cat /ramdisk/smartpitemp.txt | grep smartpi_active_watts | grep C | awk -F "} " '{print $2}' | grep -v -e '^$' | grep '.[0-9]\+.[0-9]\+'`
	
	
	PVA_A=`cat /ramdisk/smartpitemp.txt | grep apparent_power_volt_amps | grep A| grep -o '[0-9]\+.[0-9]\+'`
	PVA_B=`cat /ramdisk/smartpitemp.txt | grep apparent_power_volt_amps | grep B| grep -o '[0-9]\+.[0-9]\+'`
	PVA_C=`cat /ramdisk/smartpitemp.txt | grep apparent_power_volt_amps | grep C| grep -o '[0-9]\+.[0-9]\+'`
	
	
	I_A=`cat /ramdisk/smartpitemp.txt | grep smartpi_amps | grep A| grep -o '[0-9]\+.[0-9]\+'`
	I_B=`cat /ramdisk/smartpitemp.txt | grep smartpi_amps | grep B| grep -o '[0-9]\+.[0-9]\+'`
	I_C=`cat /ramdisk/smartpitemp.txt | grep smartpi_amps | grep C| grep -o '[0-9]\+.[0-9]\+'`
	I_N=`cat /ramdisk/smartpitemp.txt | grep smartpi_amps | grep N| grep -o '[0-9]\+.[0-9]\+'`
	let COUNTER=COUNTER+1
    done
    let COUNTER=COUNTER+1
} 

print_data () {
    echo "V_A: "$VAR_A
}

write_data () {
    #Write the data to the database
    
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=PVA,phase=L1 value=$PVA_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=PVA,phase=L2 value=$PVA_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=PVA,phase=L3 value=$PVA_C" >/dev/null 2>&1 -m 0.01
    
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=PFR,phase=L1 value=$PFR_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=PFR,phase=L2 value=$PFR_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=PFR,phase=L3 value=$PFR_C" >/dev/null 2>&1 -m 0.01
    
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=VAR,phase=L1 value=$VAR_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=VAR,phase=L2 value=$VAR_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=VAR,phase=L3 value=$VAR_C" >/dev/null 2>&1 -m 0.01
    
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=Angle,phase=L1 value=$A_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=Angle,phase=L2 value=$A_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=Angle,phase=L3 value=$A_C" >/dev/null 2>&1 -m 0.01
    
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=volt,phase=L1 value=$V_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=volt,phase=L2 value=$V_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=volt,phase=L3 value=$V_C" >/dev/null 2>&1 -m 0.01


    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=freq,phase=L1 value=$f_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=freq,phase=L2 value=$f_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=freq,phase=L3 value=$f_C" >/dev/null 2>&1 -m 0.01

    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=watt,phase=L1 value=$W_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=watt,phase=L2 value=$W_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=watt,phase=L3 value=$W_C" >/dev/null 2>&1 -m 0.01
    
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=strom,phase=L1 value=$I_A" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=strom,phase=L2 value=$I_B" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=strom,phase=L3 value=$I_C" >/dev/null 2>&1 -m 0.01
    curl -s -i -XPOST 'http://127.0.0.1:8086/write?db=smartpi' --data-binary "smartpi,host="$hostip",sensor=strom,phase=N value=$I_N" >/dev/null 2>&1 -m 0.01

}

#Prepare to start the loop and warn the user
while :
do
    #Sleep between readings
    sleep "$sleeptime"
    get_curl
    get_data
   # print_data
    write_data
done
