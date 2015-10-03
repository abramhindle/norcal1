gnome-terminal -e 'csound threshmixer.csd' &
sleep 4
gnome-terminal -e 'mplayer -ao jack:port=threshMixer stereo-test.flac' &
sleep 3
jack_disconnect system:capture_1 threshMixer:input1
jack_disconnect system:capture_2 threshMixer:input2
jack_connect system:capture_1 threshMixer:input4
jack_connect system:capture_1 threshMixer:output2
jack_connect threshMixer:output2 system:playback_1

