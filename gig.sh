# turn off power saving
# echo 'performance' > '/sys/class/scsi_host/host5/link_power_management_policy'

alias OSD="osd_cat -p middle -A center -f '-*-helvetica-*-r-*-*-34-*-*-*-*-*-*-*' -d 10 -s 2 -S red -c green"

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
    gnome-terminal -e bash csoundit.sh &
    ruby disconnect-jack.rb csound6
    jack_connect chuck:output1 threshMixer:input2 
    jack_connect chuck:output2 threshMixer:input2    
    gnome-terminal -e python stft-videosonify-osc.py &
)

echo "Press Enter when you want the performance to start!
read
(sleep 3; echo ACT I: Liars | OSD) &
(sleep 300; echo Closing ACT I| OSD) &
(sleep 360; echo ACT II: Gluttonous | OSD)
(sleep 660; echo Closing ACT II| OSD) &
(sleep 720; echo ACT III: Violent Against Art | OSD)
(sleep 1020; echo Closing ACT III| OSD) &
# sleep 18 minute
sleep 1080
echo Finale: Baphomet | OSD
echo Press enter to kill everything
read
killall csound
killall csound6
killall chuck
killall stft-videosonify-osc.py
