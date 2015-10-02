float f;

fun void myshred()
{
    // infinite loop
    while ( true )
    {
        // wait on event
        0.3::second => now;
        // print
        <<< f >>>;
    }
}

spork ~ myshred();

fun void setter() {
    OscRecv recv;
    // use port 7770
    7770 => recv.port;
    recv.listen();
    recv.event("/fft/sbins,f f f f f f f f f f f f f f f f") @=> OscEvent @ rate_event;
    while( true )
    {
	    // wait for event to arrive
	    rate_event => now;
	    
	    // grab the next message from the queue. 
	    while( rate_event.nextMsg() )
	    { 
	        
	        
	        // getFloat fetches the expected float (as indicated by "i f")
	        rate_event.getFloat() => f;
	        
	        // print
	        <<< "got (via OSC):", f >>>;
	    }
    }
}


spork ~ setter();
while(true) {
    1.0::second => now;
}
