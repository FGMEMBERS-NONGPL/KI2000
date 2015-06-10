# Alpha Circuit

var aroot = props.globals.getNode("/systems/alpha-circuit",1);

var auto = aroot.getNode("auto",1);
auto.setBoolValue(0);

var mode_selected = aroot.getNode("mode-selected",1);
mode_selected.setValue("park");

var loop = func {
     var turbine = props.globals.getNode("engines/engine[0]/running").getBoolValue();
	 var gearsel = props.globals.getNode("systems/transmission/selected").getValue();
	 var mode = "";
	 if ( turbine ) {
	  	 if ( gearsel == 0 ) { mode = "park"; }
		 if ((gearsel > 0) and (gearsel < 4)) { mode = "normal"; }
		 if (gearsel == 4) { mode = "pursuit"; }
		 mode_selected.setValue(mode);
		}
	}

var temploop = func {
     loop();
	 settimer(temploop, 0.25);
	}
	 
	 