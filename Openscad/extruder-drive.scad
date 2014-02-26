// Morgan 1.75 Extruder by qharley
// Based heavilly off the RepRapPro mini extruder
//
// Modified to take the more readilly available 624 bearings, and 10mm OD drive gears.
// Feb 2014

use <library.scad>;
use <gears.scad>;
include <config.scad>

//translate([-10,14,18])
	//rotate([0,90,0])
		//color("blue") cylinder(r=.5, h=10.5);

$fn=64;
filament_d=1.75+0.2;
filament_offset_x=(5/2+filament_d/2+2.5);
echo(filament_offset_x);
drive_offset_y=17;
bite=0;
motor_hole_pitch=31;//26;
frame_clamp = true;  // Flattens end where Mendel frame clamp lands - AB
gear_play = -0.5;			// Positive value will give more play on gears (default = -0.5)
							// Moves motor mount position
idler_slit = 1;			// Gap width - default = 1
//da8=sqrt(2+sqrt(2))/4;
echo(da8);

dx=filament_offset_x+filament_d/2+5.6/2-bite;
dy=drive_offset_y;
h=sqrt(pow(dx,2)+pow(dy,2));
echo(h);
//NEMA17();

//mirror([1,0,0])  6mm_adaptor();
morgan_drive_block();


module 6mm_adaptor()
{
	difference(){
		linear_extrude(height=10)
			projection(cut=true)
				translate([0,0,20]) rotate ([90,0,0])  mirror([1,0,0]) drive_block();
			translate([-6,-2.55,7.5])
				cube([10,20,6], center=true);
			translate([-6,-2.2,0])
				cube([6,10,10], center=true);
			translate([-6,-7.2,0])
				cylinder(r=3,h=10);
	}
}



module morgan_drive_block(){
	mirror([1,0,0]){
		translate([0,0,2])
			drive_block();
		linear_extrude(height = 2)
			projection(cut=true)
				drive_block();
	}
}
//translate([0,0,14]) rotate([0,0,0])
//translate([28,2,14]) rotate([0,180,0])
//	small_gear();
//translate([-(filament_offset_x+filament_d/2+5.6/2-bite),drive_offset_y,15.5])
//	large_gear();

//echo("gear sep",sqrt(pow(filament_offset_x+filament_d/2+5.6/2-bite,2)+pow(drive_offset_y,2)));

module drive_block(){
	difference(){
		union(){
			if(!frame_clamp)
				translate([0,5-1,7]) cube([motor_hole_pitch+8,motor_hole_pitch+16,14],center=true);
			else
				translate([1,5-1.25,7]) cube([motor_hole_pitch+11,31+18.5,14],center=true);
				translate([17,24,3]) rotate([0,-90,0]){
				cylinder(r=3,h=40);
				translate([-3,0,0]) cube([3,3,40]);
			}
				//boss for carriage mount hole
				rotate([90,0,0]) translate([23,7,(31-4)/2 -0.5]) rotate([0,0,22.5]) cylinder(r=14*da8,h=8,$fn=8);
				//boss for idler tensioner hole
				translate([20.6,25,14]) rotate([0,-90,0]) cylinder(r=3.5,h=28.1);
				//boss for drive bearings
				translate([filament_offset_x+filament_d/2+5.6/2-bite,drive_offset_y,0]) cylinder(r=6.65,h=17);
                translate([-7.5,8,0]) cube([29,16,17]);
		}
		//****idler****
		translate([filament_offset_x-filament_d/2-7.5,drive_offset_y,5]){
			translate([1,0,-.5])  cylinder(r=7,h=6);
			translate([0.5,0,0])
			  rotate([0,0,22.5]) difference() {
				cylinder(r=4.3*da8,h=40,center=true,$fn=8);
				translate([0,0,5.5]) cylinder(r=4.3*da8,h=0.3);
			}
			//translate([1,0,9]) cylinder(r=4.25,h=14);
				translate([-12,0,2.5]) cube([24,14,6],center=true);
				translate([-15,2,2.4]) union(){
				translate([0,1,0]) cube([20,20,15],center=true);
				//translate([3,-5,-5])cube([16,12,5.2],center=true); // Added by AB
				translate([-10,-8,0]) cylinder(r=20,h=15,center=true);
				}
		}
		translate([filament_offset_x-0.5-2-idler_slit,gear_play,-0.1]) cube([idler_slit,30-gear_play,20]);
		

		//****drive****
		translate([filament_offset_x+filament_d/2+5.6/2-bite+1.1 ,drive_offset_y,2.5]){
			translate([0,0,-3]) cylinder(r=(10.5)/2,h=20);
			translate([0,0,-2]) scale([1,1,1.1]) scale([1,1,1]) bearing_624();
            translate([0,0,(8.8-5)/2-1.8]) cylinder(r1=6.5,r2=10.5/2,h=(8.5-5)/2);
			translate([0,0,14.5]) scale([1,1,2]) scale([1,1,1]) bearing_624();
		}
		
		//****filament path****
		translate([filament_offset_x,0,7.5]) rotate([90,0,0]){
			rotate([0,0,30]) cylinder(r=filament_d/sqrt(3),h=60,center=true,$fn=6);
			//barrel counter bore
			translate([0,0,11.1+1]) {
				rotate([0,0,30]) cylinder(r=8.5/sqrt(3), h=3.3, $fn=6);
                //translate([0,6-8.5/sqrt(3),1.65]) cube([8.5,12,3.3], center=true);
                translate([0,0,2]) cylinder(r=5.3/2,h=8);
			}
			
			//drive clearance and lead in
			translate([0,0,-17.0]) cylinder(r=3/2,h=5.5, center=true);
			translate([0,0,-13.75]) cylinder(r1=3/2,r2=filament_d/2,h=1,center=true );
			translate([0,0,-20.25]) cylinder(r2=3/2,r1=filament_d/2,h=1,center=true);
			//translate([-0.5,0,-17]) cube([5,20,5],center = true);
		}
		
		//****centre bore****
		//for small gear
		//translate([0,0,9]) cylinder(r=9.5,h=20);
		//translate([0,-9.5,9]) cube([25,19,9]);
		//for motor flange
		//translate([0,0,-0.1]) cylinder(r=11.4,h=2.4);
		
		translate([0,gear_play,-1.1]) cylinder(r=3.5,h=20);
		//translate([-1,1,-0.1]) cylinder(r=4.5,h=20);	

		//****motor mount holes****
		for(i=[1,-1]){
			translate([i*motor_hole_pitch/2,-motor_hole_pitch/2+gear_play,-0.1]) rotate([0,0,22.5]) cylinder(r=3.3*da8,h=20,$fn=8);
			translate([i*motor_hole_pitch/2,-motor_hole_pitch/2+gear_play,11]) cylinder(r=3.1,h=5);
		}
		//****idler tensioner****
		for(i=[0,11.5]){
			translate([18.6+5.5,25.25,2.5+i]) rotate([0,-90,0]){
				//if(!frame_clamp)
					rotate([0,0,30]) cylinder(r=5.8/sqrt(3),h=12, center=true,$fn=6);
					rotate([0,0,22.5]) cylinder(r=3.3*da8,h=80, center=true,$fn=8);
			}
		}
		//if(!frame_clamp)
			//translate([17.1+1,25,2.5]) cube([6,5.8,35],center=true);
		//else
			translate([17.1+4.5,26.5,8]) cube([8,6.8,35],center=true);
		//**** ****
			translate([17,-2,8.5]) union(){
				translate([14,20.5,0]) cube([20,19,18],center=true);
				translate([24,12,0]) cylinder(r=20,h=18,center=true);
			}
		//****carriage mount holes****
		translate([2,0,0]) for(i=[1,-1]){		// for(i=[1,-1])
			rotate([90,0,0]) translate([filament_offset_x+i*16+1.5,7.5,5])
			{
        translate([0,0,7]) rotate([0,0,22.5]) cylinder(r=3.3*da8,h=10,$fn=8);
				//rotate([0,0,30]) cylinder(r=5.8/sqrt(3),h=3,$fn=6);
				//translate([-5.8/2,0,0]) cube([5.8,10,3]);
			}
		}
	}
}
module insert(){
	difference(){
		cylinder(r=5.6/2,h=6,center=true);
		cylinder(r=2.3/2,h=6.2,center=true);
	}
}

