
### Drivetrain

## Settings

# Gear Ratios

var ratios = {1: 1, 2: 0.75, 3: 0.5, 4: 0.25,};


var txroot = props.globals.getNode("/systems/transmission",1);
var ctrls = props.globals.getNode("/controls/transmission",1);

var transmission = {
	 select: func(a) {
	     sel = ctrls.getNode("selector");
		 curr = sel.getValue();
		 spd = ( curr - a );
		 if ( spd < 0 ) { spd = ( spd * -1 ) };
		 interpolate(sel, a, (spd*0.25));
		 settimer( func { 
		     txroot.getNode("selected").setValue(a); 
         	 if ( a > 0 ) { me.parkbrake(0); }
			 else { me.parkbrake(1); }
			},(spd*0.3));
		},
	 shift: func(c) {
	     var curr = props.globals.getNode("controls/transmission/selector").getValue();
		 var new = ( curr + c );
		 if (( new > -1 ) and ( new < 5  )) { me.select(new); }
		},
	 gear: func(a) {
	     pr = txroot.getNode("gear", 1);
		 rt = txroot.getNode("gear-ratio", 1);
		 ratio = ratios.a;
		 pr.setIntValue(a);
		 rt.setValue(ratio);
		},
	 parkbrake: func(b) {
	     props.globals.getNode("controls/gear/brake-parking").setValue(b);
		},
	 init: func {
	     me.parkbrake(1);
		 print("Drivetrain OK");
		},
	}
