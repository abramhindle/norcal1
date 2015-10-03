# turn off power saving
# echo 'performance' > '/sys/class/scsi_host/host5/link_power_management_policy'

# alias OSD="osd_cat -p middle -A center -f '-*-helvetica-*-r-*-*-34-*-*-*-*-*-*-*' -d 10 -s 2 -S red -c green"

# start thresh mixer

(
    gnome-terminal -t threshMixer -e "csound threshmixer.csd" &
    sleep 6;
    # disconnect it
    ruby disconnect-jack.rb threshMixer
    # connect it
    jack_connect threshMixer:output1 system:playback_1
    jack_connect threshMixer:output2 system:playback_1
    jack_connect threshMixer:output1 system:playback_2
    jack_connect threshMixer:output2 system:playback_2
    jack_connect system:capture_1 threshMixer:input4
)

(
    gnome-terminal -t ChucK -e "chuck oneliner.ck" &
    sleep 6
    ruby disconnect-jack.rb ChucK   
    jack_connect ChucK:outport\ 0 threshMixer:input1 
    jack_connect ChucK:outport\ 1 threshMixer:input1

)


(
    cd more-history-mean 
    gnome-terminal -t "meanHist CSound" -e "bash csoundit.sh" &
    sleep 6
    ruby disconnect-jack.rb meanHist
    jack_connect meanHist:output1 threshMixer:input2 
    jack_connect meanHist:output2 threshMixer:input2    
    gnome-terminal -t "meanHist py" -e "python stft-videosonify-osc.py -c 1 -a 2 -b -0.3" &
)

echo "Press Enter when you want the performance to start!"
read
(sleep 3; echo ACT I: Liars | ./OSD.sh) &
(sleep 300; echo Closing ACT I| ./OSD.sh) &
(sleep 360; echo ACT II: Gluttonous | ./OSD.sh) &
(sleep 660; echo Closing ACT II| ./OSD.sh) &
(sleep 720; echo ACT III: Violent Against Art | ./OSD.sh) &
(sleep 1020; echo Closing ACT III| ./OSD.sh) &
# sleep 18 minute
echo sleep 1080
echo We faked the sleep, press enter to end!
read
echo Finale: Baphomet | ./OSD.sh
echo Press enter to kill everything
read
bash kill.sh
