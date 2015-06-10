
## Cockpit

var test_time = 2.0; # Time indicators are illuminated in test mode

var powerpath = "/systems/electrical/outputs/low-voltage/dashboard";
var dimpath = "/instrumentation/illumination/indicators-brightness";

var indicator = {
     new: func (n,where,desc = "Not set") {
	     var i = { parents: [indicator] };
	     i.iprop = props.globals.getNode("/instrumentation/indicators/"~where,1);
		 i.brightness = i.iprop.getNode("brightness",1);
		 i.brightness.setValue(0);
		 i.powered = i.iprop.getNode("powered",1);
		 i.powered.setBoolValue(0);
		 return i;
		},
	 on: func {
	     volts = props.globals.getNode(powerpath).getValue();
		 dim = props.globals.getNode(dimpath).getValue();
		 if ( volts > 10 ) {
		     me.powered.setBoolValue(1);
			}
		},
	 off: func {
	     me.powered.setBoolValue(0);
		},
	 test: func {
	     var state = me.powered.getBoolValue();
		 me.on();
		 settimer( func { me.powered.setBoolValue(state); }, test_time);
		}
	};

	
var initialize = func {
     var power = props.globals.getNode(powerpath).getValue();
	 if ( power > 10 ) {
	     var relays = props.globals.getNode("/systems/electrical/relays",1);
		 var binnacles = relays.getNode("binnacles",1);
		 var indis = relays.getNode("indicators",1);
		 indis.setBoolValue(1);
		 binnacles.setBoolValue(1);
		 settimer( func {
			 indicator_test();
			},1.0);
		 settimer( func {
		     setprop("/instrumentation/binnacles/standby-comms", 0);
			 #setprop("/instrumentation/binnacles/standby-screen", 0);
			},1.5);
		 settimer( func {
		     setprop("/instrumentation/binnacles/standby-nav", 0);
			 setprop("/instrumentation/binnacles/standby-systems", 0);
			},2.0);
		 settimer( func {
		     setprop("/instrumentation/binnacles/standby-driving", 0);
			 setprop("/instrumentation/binnacles/standby-turbine", 0);
			},2.5);
		 var litb = relays.getNode("lit-buttons",1);
		 litb.setBoolValue(0);
		 settimer( loop , 1.5 );
		}
	}	    

var indicator_test = func {
     setprop("/instrumentation/indicators/test-mode", 1);
     ind_power.test();
	 ind_minrpm.test();
	 ind_fuelon.test();
	 ind_ignitors.test();
	 ind_normalcruise.test();
	 ind_autocruise.test();
	 ind_pursuit.test();
	 ind_turnleft.test();
	 ind_turnright.test();
	 ind_beam.test();
	 ind_lights.test();
	 settimer( func { setprop("/instrumentation/indicators/test-mode", 0); }, test_time);
	}
	
var loop = func {
     var power = props.globals.getNode(powerpath).getValue();
	 indicator_loop();
	 milometer.update();
     if ( power > 10 ) {
	     settimer( loop , 0.2 );
		}
	 else {
	     var relays = props.globals.getNode("/systems/electrical/relays");
		 relays.getNode("binnacles",1).setBoolValue(0);
		 relays.getNode("indicators",1).setBoolValue(0);
		 relays.getNode("lit-buttons",1).setBoolValue(0);
	    }
	}

var litbutton = func(x) {
     if ( x == "12v" ) {
	     initialize();
		}
	}
	
var indicator_loop = func {
	     var inds = props.globals.getNode("/instrumentation/indicators");
	     var dim = props.globals.getNode(dimpath).getValue();
		 
		 var indpower = 0;
		 var indfuelon = 0;
		 var indminrpm = 0;
		 var indignitors = 0;
		 var indnorm = 0;
		 var indauto = 0;
		 var indpurs = 0;
		 
		 var cutoff = props.globals.getNode("/controls/engines/engine[0]/cutoff").getBoolValue();
		 var rpm = props.globals.getNode("/engines/engine[0]/rpm").getValue();
		 var alpha = props.globals.getNode("/systems/alpha-circuit/mode-selected").getValue();
		 var auto = props.globals.getNode("/systems/alpha-circuit/auto").getBoolValue();
		 
		 if ( rpm > 0.5 ) { indpower = 1 };
		 if ( rpm > 12 ) { indminrpm = 1 };
		 if ( rpm > 20 ) { indignitors = 1 };
		 if ( !cutoff ) { indfuelon = 1 };
		 
		 if ( alpha == "park" ) { indnorm = 0; indpurs = 0; }
		 if ( alpha == "normal" ) { indnorm = 1; }
		 if ( alpha == "pursuit" ) { indpurs = 1; }
		 
		 if ( auto ) { indauto = 1; indnorm = 0; }
		 		 
		 if ( !inds.getNode("test-mode").getBoolValue() ) {
		     inds.getNode("power/powered").setBoolValue(indpower);
		     inds.getNode("fuel-on/powered").setBoolValue(indfuelon);
		     inds.getNode("min-rpm/powered").setBoolValue(indminrpm);
		     inds.getNode("ignitors/powered").setBoolValue(indignitors);
			 inds.getNode("normal-cruise/powered").setBoolValue(indnorm);
			 inds.getNode("auto-cruise/powered").setBoolValue(indauto);
			 inds.getNode("pursuit/powered").setBoolValue(indpurs);
			}
		 
		 foreach(n; inds.getChildren()) {
		     if ( n.getName() != "test-mode" ) {
			     var v = n.getNode("powered").getBoolValue();
			     var bright = n.getNode("brightness");
			     if ( v ) { bright.setValue(dim); }
			     else { bright.setValue(0); }
				}
			}
		}
		
var ind_normalcruise = indicator.new(0,"normal-cruise","Normal Cruise");
var ind_autocruise = indicator.new(0,"auto-cruise","Auto Cruise");
var ind_pursuit = indicator.new(0,"pursuit","Pursuit");
var ind_power = indicator.new(0,"power","Power");
var ind_minrpm = indicator.new(0,"min-rpm","Min RPM");
var ind_fuelon = indicator.new(0,"fuel-on","Fuel On");
var ind_ignitors = indicator.new(0,"ignitors","Ignitors");
var ind_turnleft = indicator.new(0,"turn-left","");
var ind_turnright = indicator.new(0,"turn-right","");
var ind_beam = indicator.new(0,"beam","");
var ind_lights = indicator.new(0,"lights","");

var milometer = {
     update: func {
	     var gpsmiles = props.globals.getNode("/instrumentation/gps/odometer").getValue();
	     var actualmiles = ( gpsmiles * 0.86 );
	     props.globals.getNode("/instrumentation/binnacles/odometer",1).setIntValue(actualmiles);
	    },
    };
