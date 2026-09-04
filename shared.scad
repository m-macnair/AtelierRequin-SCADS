$atelier_requin_shared_version = "v1.0.0";
module filled_iso_nut(
	size   = 8,
	height = 3) {
	difference() {
		down(height / 2)
			top_only_nutshape(size, height, "hex", undef, 1);
	}
}

module top_only_nutshape(nutwidth, h, shape, bevel1, bevel2, bevang) {
	bevel_d = 0.9;
	intersection() {
		if (shape == "hex")
			cyl(d = nutwidth, circum = true, $fn = 6, l = h, chamfer2 = bevel2 ? 0 : nutwidth * .01);
		else
			cuboid([ nutwidth, nutwidth, h ], chamfer = nutwidth * .01, except = [ if (bevel1) BOT, if (bevel2) TOP ]);
		fn		  = quantup(segs(r = nutwidth / 2), shape == "hex" ? 6 : 4);
		d		  = shape == "hex" ? 2 * nutwidth / sqrt(3) : sqrt(2) * nutwidth;
		chamfsize = (d - nutwidth) / 2 / bevel_d;
		cyl(d = d * .99, h = h + .01, realign = true, circum = true, $fn = fn, chamfer1 = bevel1 ? chamfsize : 0, chamfer2 = bevel2 ? chamfsize : 0, chamfang = bevang);
	}
}

function greek_numeral(n) =
	assert(n >= 1 && n <= 20, "Greek numeral must be 1–20")
		["α", "β", "γ", "δ", "ε", "ϛ", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ϟ", "ρ", "σ"][n - 1];