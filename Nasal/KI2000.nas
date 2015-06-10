## Knight Industries 2000
# by Algernon Aerospace

var initDelay = 1;

	 var leftDoor = aircraft.door.new("/systems/doors/door-left", 2.5);
	 var rightDoor = aircraft.door.new("/systems/doors/door-right", 2.5);
	 var leftWindow = aircraft.door.new("/systems/glass/window-left", 2.5);
	 var rightWindow = aircraft.door.new("/systems/glass/window-right", 2.5);
	 var leftRoof = aircraft.door.new("/systems/glass/roof-left", 2.5);
	 var rightRoof = aircraft.door.new("/systems/glass/roof-right", 2.5);
	 var headlamps = aircraft.door.new("/systems/headlamps", 0.75);

var check = func {
	var initprop = props.globals.getNode("/sim/nasal/nasal-initialised",1).getBoolValue();
    if ( !initprop ) {
	     init();
		 }
	 else { print("Nasal Re-Initalise Request: Denied (Scripts already initialised)");
    }
}
	
setlistener("/sim/signals/fdm-initialized", check);

var init = func {
     
	 print("Initialising Knight Industries 2000");
	 
	 # Initialise doors, windows and roof
	 
	 #Start scripts
	 ae.init();
	 turbine.loop();
	 alpha.temploop();
	 temp_loop();
	 #settimer( func { instruments.initialize(); },8);
	}
	
var glass = func() {
	 var gl = props.globals.getNode("/systems/glass/opacity");
	 if ( gl.getValue() == 0 ) { interpolate("/systems/glass/opacity", 1, 2.5); }
	 else { interpolate("/systems/glass/opacity", 0, 2.5); }
	}
	
var temp_loop = func {
     var hls = props.globals.getNode("/systems/headlamps/position-norm");
	     if ( hls.getValue() > 0.65 ) {
		     interpolate("/systems/headlamps/brightness-norm", 1, 0.15);
			}
		 else {
		     interpolate("/systems/headlamps/brightness-norm", 0, 0.35);
			}
		settimer(temp_loop, 0.1);
	}
	
