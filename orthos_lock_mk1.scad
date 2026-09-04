//ABSTRACT: Replacement design for rivets
$orthos_lock_version = "v3.0.0";
// clang-format off

include<BOSL2/std.scad>;
// clang-format on

$fn = 60;

C_D = 1;
//C_D = 1;

/* Invariant */
PHI		= (1 + sqrt(5)) / 2;
PHI_INV = 1 / PHI;

function chain_capture_diameter(C_D, margin = 1.10) =
	(1 + 2 / sqrt(3)) * C_D * margin;

ccp = chain_capture_diameter(C_D);

//circle(d = ccp);

//up (1)
//triangle_distribution(C_D , 1.1) circle(d=C_D);

module triangle_distribution(D, margin = 1) {
	this_diameter = D * margin;
	zrot_copies(n = 3)
		left(this_diameter / sqrt(3))
			children();
}
square_shackle(C_D, ccp);
module square_shackle(C_D, ccp) {
	shackle_position = (ccp / 2) + C_D / 2;
	cylinder_height	 = ccp + C_D;
	back(shackle_position)
		yrot(90)

			cyl(h = cylinder_height, d = C_D, anchor = CTR) {
		position(TOP) sphere(d = C_D);
		position(BOT) sphere(d = C_D);
	}
	xrot(-90)
		xcopies(shackle_position * 2, 2)
			cylinder(h = cylinder_height, d = C_D, anchor = CTR) {
		position(TOP) sphere(d = C_D);
		position(BOT) cyl(d = C_D * 1.4, h = C_D, anchor = BOT, rounding2 = C_D * .2);
		position(BOT) cyl(d = C_D, h = C_D, anchor = TOP);
	}
}
function flat_dimension(dimension, rounding) =
	dimension - (2 * rounding);

fwd(ccp * 2)
	lock_body(C_D, ccp);
module lock_body(C_D, ccp) {
	minimum_body_x = ccp + C_D * 2;
	rounding	   = C_D * (PHI_INV / 2);
	lock_X		   = minimum_body_x * 1.2;
	lock_Y		   = (minimum_body_x * 2) * PHI_INV;
	lock_Z		   = C_D * 2;
	difference() {
		cuboid(
			[
				lock_X,
				lock_Y,
				lock_Z
			],
			rounding = rounding,
			anchor	 = CTR) {

			position(TOP) {
				difference() {
					/* face plate */
					cuboid([
						flat_dimension(lock_X, rounding),
						flat_dimension(lock_Y, rounding),
						C_D * .1

					],
						   anchor	= CTR,
						   rounding = C_D * .1,
						   edges	= [ FRONT + RIGHT, BACK + RIGHT, FRONT + LEFT, BACK + LEFT ]

					);
					key_part(C_D, lock_X, rounding);
				}
			}
			position(TOP)
				xcopies(flat_dimension(lock_X, rounding) - C_D, 2)
					ycopies(flat_dimension(lock_Y, rounding) - C_D, 2)
						sphere(C_D * .2, anchor = CTR);
		}
		up(lock_Z / 2)
			sphere(d = C_D, anchor = CTR);
	}
}

module key_part(C_D, lock_X, rounding) {
	plate_variable = flat_dimension(lock_X, rounding) * PHI_INV;

	down(C_D * .5)
		linear_extrude(C_D)
			text(
				"T",

				font   = "GFSDidot",
				size   = plate_variable,
				anchor = CTR

			);

	cyl(d = C_D * 1.1, anchor = CTR);
}