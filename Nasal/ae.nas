## ae.nas

var interval = 0;
var element_decay = 0.6;

## Properties

var aepath = "/systems/anamorphic-eq";
var elpath = "/systems/anamorphic-eq/elements";

var els = props.globals.getNode(elpath).getChildren();
var aeroot = props.globals.getNode(aepath, 1);

aeroot.initNode("scan-stage-norm", 0, "DOUBLE");
aeroot.initNode("scan-speed", 0.1, "DOUBLE");

var init = func {
	 var elements = aeroot.getNode("elements", 1);
	 elements.initNode("element-lit", 0, "INT");
	 elements.initNode("element[6]", 0, "DOUBLE");
	 foreach(a; els) {
	     var x = a.getIndex();
	     elements.initNode("element["~x~"]", 0, "DOUBLE");
		}
	 
	 props.globals.initNode("/sim/sound/triggers/anamorphic-eq", 0, "BOOL");
	 props.globals.initNode("/systems/anamorphic-eq/surveillance-mode", 0, "BOOL");
	 setlistener("/systems/anamorphic-eq/elements/element-lit", element);
	 loop();
	}
	
var sound = func(g) {
     var pr = props.globals.getNode("/sim/sound/triggers/anamorphic-eq");
	 pr.setBoolValue(1);
	 settimer( func { pr.setBoolValue(0); }, (g * 15));
    }
 
var scan = func(z) {
     var ell = props.globals.getNode(elpath).getNode("element-lit");
     var elc = props.globals.getNode(elpath).getChildren("element");
	 var sm = props.globals.getNode(aepath).getNode("surveillance-mode").getBoolValue();
	 var count = 0;
	 if ( z != "start" ) {
		 var speed = z;
		 sound(speed);
		 interpolate(ell,6,(speed*7));
         settimer( func { interpolate(ell,0,(speed*7)); },(speed*7));
		}
	 else {
	     foreach(e; elc) {
		     var n = e.getIndex();
			 light_element(n);
			}
		}
    }
	
var light_element = func(n) {
     var lit = props.globals.getNode(elpath~"/element["~n~"]");
	 lit.setValue(1);
	 interpolate(lit, 0, element_decay);
	}
	
var element = func {
     var z = props.globals.getNode("/systems/anamorphic-eq/elements/element-lit").getValue();
	 light_element(z);
	}

var loop = func {
     var scanspeed = aeroot.getNode("scan-speed").getValue();
	 var smode = aeroot.getNode("surveillance-mode").getBoolValue();
	 if (smode) {
	     scan(scanspeed);
		}
	 settimer(loop, (scanspeed*20));
	 
	}
	 