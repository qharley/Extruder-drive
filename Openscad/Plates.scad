// Plates

use <extruder-drive.scad>
use <spacer-1off.scad>
use <gears.scad>

extruder_drive_set_4off();
//gear_set_4off();

module extruder_drive_set_4off(){
	for (i = [0:2])
		for (j = [0:2])
			translate([53*i,53*j,0])
				if (j == 0){
					morgan_drive_block();
				}
				else if (i == 0 && j==1){
					morgan_drive_block();
				}
				else if (i != 2 || j!=2){
					NEMA17_spacer();
				}
}

module gear_set_4off(){
	for (i=[0:3])
		rotate([0,0,90*i]){

			translate([8,8,0])
				small_gear();
			translate([38,38,7])
				rotate([0,180,0])
					large_gear();
			translate([45,7.5,0])
				6mm_adaptor();	

		}

}
			