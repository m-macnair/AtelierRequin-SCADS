//ABSTRACT: Replacement design for rivets
$obol_capacitor_version = "v2.0.0";
// clang-format off
include<BOSL2/std.scad>; 
include <BOSL2/screws.scad>
include <crest_3d.scad>
include <constants.scad>
include <shared.scad>
				// clang-format on

				$fn = 120;

O_value			   = 1;
obol_character	   = greek_numeral(O_value);
O_height_deviation = 1;
B_R_deviation	   = 1;
B_Z_deviation	   = 1;

/* fixed~ */

bolt_tolerance = "8g";
nut_tolerance  = "8G";

/* derived */
O_thread_height = O_height_deviation * (O_value);
obol_M			= str("M", O_value);

C_r = O_value * B_R_deviation;
C_z = (O_value / 2 * B_Z_deviation) * PHI;

combined_bulb_z = C_z + (C_z * .2);
fin_Z			= combined_bulb_z;
BS_R			= C_r + (O_value * 0.1);
BS_Z			= C_z * .1;
nut_height		= O_value * 0.2;
screw(
	obol_M,
	l		  = O_thread_height,
	head	  = "none",
	tolerance = bolt_tolerance,
	anchor	  = BOTTOM) {
	position(TOP) {
		/*bulb*/
		difference() {
			cyl(
				r		  = C_r,
				height	  = C_z,
				anchor	  = BOT,
				texture	  = "diamonds",
				tex_size  = [ O_value * .2, O_value * .2 ],
				tex_depth = O_value * 0.025,
				style	  = "concave"

			) {
				/* fins */
				//			down((combined_bulb_z - fin_Z) / 2)
				zrot_copies(n = 6) {
					left(C_r)
						cuboid(
							[
								C_r * 0.4, // radial thickness
								C_r * 0.2, // tangential width
								fin_Z	   // height
							],
							rounding = C_r * 0.05,
							anchor	 = CTR,
							edges	 = [
								   //							 FRONT + RIGHT,
								   //							 BACK + RIGHT,
								   //							 FRONT + LEFT,
								   LEFT + BACK,
								   LEFT + FRONT,
								   LEFT + TOP,
								   TOP + BACK,
								   TOP +
								   FRONT
							]);
				}

				/* shock absorber */
				position(BOT) {

					up(BS_Z / 2)
						cyl(
							r		 = BS_R,
							h		 = BS_Z,
							anchor	 = TOP,
							rounding = BS_Z * 0.05);
				}

				/* caps */

				position(TOP) {
					/* first cap */
					name_cap();
				}
				position(TOP) {
					/* second cap */
					secondary_bulb();
				}
				position(TOP) {
					/* second cap */
					up(C_z + nut_height - O_m)
						crest_cap();
				}
			}
			up(C_z + ((O_value * 0.1)))
				name_circle();
		}
	}
}
module secondary_bulb() {
	cyl(
		r		  = BS_R / 2 * PHI,
		h		  = C_z,
		anchor	  = BOT,
		rounding2 = C_z * 0.1);
}

module name_cap() {
	cyl(
		r = BS_R,
		h = BS_Z,
		//						rounding = BS_R * .1,
		anchor = BOT
		//							 edges = "BOTTOM"
	);
}

module name_circle() {
	path1		= path3d(circle(r = BS_R * .85));
	path_lenght = path_length(path1);
	echo(str("Path length for name circle: ", path1));
	path_text(
		center = true,
		path1,
		str(
			"ΤΟ ΚΑΤΑ ΜΕΤΡΟΝ (", obol_character, ") ΟΒΟΛΩΝ ΔΟΧΕΙΟΝ ΤΟΥ ΠΛΑΣΜΑΤΟΣ ΕΞ ΟΥ ΟΙ ΑΣΤΕΡΕΣ ΓΙΝΟΝΤΑΙ")

			,
		font	   = "GFSDidot",
		size	   = O_value * 0.05,
		lettersize = O_value * 0.05,
		normal	   = TOP,
		h		   = O_value * 0.1);
}
module crest_cap() {

	zrot(90)
		difference() {
		filled_iso_nut(
			size   = O_value,
			height = nut_height);
		down(nut_height * .1)
#scale([ O_value * .75, O_value * .75, nut_height * .2 ])

			requin_crest();
	}
}
