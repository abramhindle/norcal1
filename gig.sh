# turn off power saving
# echo 'performance' > '/sys/class/scsi_host/host5/link_power_management_policy'

alias OSD="osd_cat -p middle -A center -f '-*-helvetica-*-r-*-*-34-*-*-*-*-*-*-*' -d 10 -s 2 -S red -c green"

# start thresh mixer

(
    cd mixer
    gnome-terminal -e csound threshmixer.csd &
    sleep 6;
    # disconnect it
    ruby disconnect-jack.rb threshmixer
    # connect it
    jack_connect threshmixer:output1 system:output1
    jack_connect threshmixer:output2 system:output1
    jack_connect threshmixer:output1 system:output2
    jack_connect threshmixer:output2 system:output2
    jack_connect system:input1 threshmixer:input4
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
