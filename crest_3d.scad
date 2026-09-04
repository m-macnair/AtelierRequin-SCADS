//ABSTRACT: scad handler for a design I made in 2015
$crest_version = "v1.0.0";
// clang-format off
include<BOSL2/std.scad>;
// clang-format on
module requin_crest() {
	shared_crest("crest.svg");
}

module shared_crest(crest) {
	attachable(
		anchor = "origin",
		size   = [ 0.783, 1, 1 ]) {
		linear_extrude(1)
			left(0.783 / 2)
				fwd(.5)
					import(crest);
		children();
	}
}

module paired_crest() {
	shared_crest("paired_crest.svg");
}