//ABSTRACT: Replacement design for rivets
$kodon_version = "v1.0.0";
// clang-format off

include<BOSL2/std.scad>;
// clang-format on

/* external part definitions */

$fn = 60;
//gD = 10;
gZ = 2;
//cylinder(h=gZ, r= gD,anchor = CTR) {
//	 position(TOP)
//	 torus(r_maj = gD * .8 , r_min = gD*.1 , anchor = CTR);
//}

//r = gD*1.15;

//corner_r = 3;
//down(gZ/2)
//kodon_cap(z=1);
module kodon_cap(r = 5, z) {
	//	 intersection(){
	//			linear_extrude(1)
	regular_ngon(n = 6, r = r, rounding = gD * .3, anchor = CTR);
	//			up(1)
#torus(
				 r_maj = outer_kodon_cylinder_radius , 
				 r_min = .4, anchor = CTR);
				 //	 }
}

gD = 10;

hexagon_rounding = gD * .15;
linear_extrude(gD * .1)
	regular_ngon(n = 6, r = gD, rounding = hexagon_rounding, anchor = CTR);
up(hexagon_rounding * .3)
	hex_cylinder_ring(gD);
up(1) {

	cylinder(r = gD * .8, h = hexagon_rounding / 2, anchor = BOT);
	torus_min = gD * 0.1;
	torus_maj = gD * .8 - torus_min;
	up(1 / 2)
		torus(
			r_maj  = torus_maj,
			r_min  = torus_min,
			anchor = CTR);
}

up(hexagon_rounding * .1) {
	/* bolt */
	bolt_bottom_D		 = gD * .5;
	bolt_bottom_rounding = bolt_bottom_D * .15;
	//	 linear_extrude(1)
	up(1)
		linear_extrude(bolt_bottom_rounding)
			regular_ngon(n = 6, r = bolt_bottom_D, rounding = bolt_bottom_rounding);
	up(bolt_bottom_rounding * 2) hex_cylinder_ring(bolt_bottom_D);
	up(bolt_bottom_rounding)
		linear_extrude(bolt_bottom_rounding * 2)
			regular_ngon(
				n		 = 6,
				r		 = bolt_bottom_D - (bolt_bottom_rounding),
				rounding = bolt_bottom_rounding);
}

//#linear_extrude(1)

module hex_cylinder_ring(gD) {
	r				= gD * .15;
	apothem			= gD * cos(30);
	edge			= gD * 2 * sin(30);
	cylinder_length = edge - 2 * r * tan(30);
	cylinder_center = apothem - r;
	top_half() union() {
		zrot_copies(n = 6)
			translate([
				0,
				cylinder_center,
				0
			])
				rotate([ 0, 90, 0 ])
					cylinder(
						r	   = r,
						h	   = cylinder_length,
						anchor = CTR) {
			position(TOP)
				xrot(-60)
					sphere(r = r);
		}
	}
}