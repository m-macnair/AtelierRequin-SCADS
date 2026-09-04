//ABSTRACT: Replacement design for rivets
$plasma_obol_version = "v3.0.0";
// clang-format off
include<BOSL2/std.scad>; 
include <BOSL2/screws.scad>
include <./crest_3d.scad>
		// clang-format on

		$fn = 60;

O_value			   = 3;
obol_character	   = "γ";
O_height_deviation = 1;
B_R_deviation	   = 1;
B_Z_deviation	   = 1;

/* fixed~ */

bolt_tolerance = "8g";
nut_tolerance  = "8G";

/* derived */
O_thread_height = O_height_deviation * (O_value);
obol_M			= str("M", O_value);

/* Invariant */
PHI		= (1 + sqrt(5)) / 2;
PHI_INV = 1 / PHI;

screw(
	obol_M,
	l		  = O_thread_height,
	head	  = "none",
	tolerance = bolt_tolerance,
	anchor	  = BOTTOM) {
	position(TOP) {
		/*bulb*/
		C_r = O_value * B_R_deviation;
		C_z = (O_value * B_Z_deviation) * PHI;
		cyl(
			r		  = C_r,
			height	  = C_z,
			anchor	  = BOT,
			texture	  = "diamonds",
			tex_size  = [ O_value * .2, O_value * .2 ],
			tex_depth = O_value * 0.05,
			style	  = "concave"

		) {
			/* fins */
			zrot_copies(n = 6) {
				left(C_r)
					cuboid(
						[
							C_r * 0.4,	  // radial thickness
							C_r * 0.2,	  // tangential width
							PHI_INV * C_z // height
						],
						rounding = C_r * 0.03,
						anchor	 = CTR);
			}

			/* shock absorber */
			position(BOT) {
				BS_R = C_r + (O_value * 0.1);
				BS_Z = C_z * .2;
				up(BS_Z / 2)
					cyl(
						r		 = BS_R,
						h		 = BS_Z,
						rounding = O_value * 0.05,
						anchor	 = TOP
						//							 edges = "BOTTOM"
					);
			}

			/* caps */

			position(TOP) {
				/* top cap */
				up(BS_Z * 2) {

					nut_height = O_value * 0.2;
					difference() {

						filled_iso_nut(
							size   = O_value,
							height = nut_height);
						down(nut_height / 2)
#scale([ O_value * .75, O_value * .75, nut_height ])

							requin_crest();
					}
				}

				BS_R = C_r + (O_value * 0.1);
				BS_Z = C_z * .1;
				difference() {
					cyl(
						r		 = BS_R,
						h		 = BS_Z,
						rounding = .1,
						anchor	 = BOT
						//							 edges = "BOTTOM"
					);

					path1 = path3d(circle(r = BS_R * .85));
					up(BS_Z)
						path_text(
							center = true,
							path1,
							str(
								"ΤΟ ΚΑΤΑ ΜΕΤΡΟΝ (", obol_character, ") ΟΒΟΛΩΝ ΔΟΧΕΙΟΝ ΤΟΥ ΠΛΑΣΜΑΤΟΣ ΕΞ ΟΥ ΟΙ ΑΣΤΕΡΕΣ ΓΙΝΟΝΤΑΙ")

								,
							font	   = "GFSDidot",
							size	   = O_value * 0.075,
							lettersize = O_value * 0.073,
							normal	   = TOP,
							h		   = O_value * 0.1);
				}
			}
		}
	}
}

module filled_iso_nut(
	size   = 8,
	height = 3) {
	difference() {
		down(height / 2)
			_nutshape(size, height, "hex", 0, 1);
	}
}
