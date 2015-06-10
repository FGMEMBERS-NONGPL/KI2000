
# Turbine

var update_period = 0.5;

var troot = props.globals.getNode("/systems/turbine");

var throttle = troot.getNode("throttle");
var throttle_idle = 0;
var throttle_cruise = 0.6;
var throttle_pursuit = 0.95;


var loop = func {
     # Check transmission selected
	 var txsel = props.globals.getNode("/systems/transmission/selected").getValue();
	 if ( txsel == 0 ) { throttle.setValue(throttle_idle); }
	 if ( ( txsel == 1 ) or ( txsel == 2 ) or ( txsel == 3 ) ) { throttle.setValue(throttle_cruise); }
	 if ( txsel == 4 ) { throttle.setValue(throttle_pursuit); }
	
	 # ...and repeat
	 settimer(loop, update_period);
	}