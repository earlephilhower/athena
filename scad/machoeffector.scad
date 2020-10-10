include <athena.scad>

// Layout for printing.  Ensure everyone is at same Z base!
intersection() {
    union() {
        machojheadeffector();
        translate([0,25,0]) holder();
        translate([10,48,7.8]) rotate([0,0,-90]) fancowl();
        for (x=[30,-30]) for (y=[40, 50]) translate([x, y, 0]) fanpowershroud();
    }
    translate([-500,-500,-3]) cube([1000,1000,1000]);
}



margin = 0.1;
throat_d = 13+margin;
throat_h = 6+margin;
top_d = 16.4+margin;
top_h = (12.7-6)/2;
fins_d = 22.3+margin;
fins_h = 30;

fan_w = 40;
mount_h = throat_h + top_h;
shroud_d = 15+6.321;
clamp_d = 10+1;



screwhead_d = 5.5+.6;
screwhead_ln = 5.5+.2;
nut_d = 3.0+.2;
hole_d = 3.2+.1;

jhead_sink = 1.5;


module jhead() {
    union() {
        rotate([180,0,0]) center_cyl(top_d, top_h);
        center_cyl(top_d, top_h);
        center_cyl(throat_d, throat_h, top_h);
        center_cyl(top_d, top_h, top_h + throat_h);
        center_cyl(fins_d, fins_h, top_h + throat_h + top_h);
        center_cyl(5, 5, top_h + throat_h + top_h + fins_h);
        left = 62.3 - (top_h + throat_h + top_h + fins_h + 5);
        center_cube(20,30,left, top_h + throat_h + top_h + fins_h + 5);
    }
}


module center_cyl(dm, ht, off=0, fn=32) {
    translate([0,0,-off-ht/2]) cylinder(d=dm, h=ht+.001, $fn=fn, center=true);
}
module center_cube(x, y, z, off=0) {
    translate([0,0,-off-z/2]) cube([x,y,z], center=true);
}


module screwhole(diam=hole_d, depth=shroud_d, fn=16) {
    rotate([90,0,0]) cylinder(d=diam, h=depth+.001, center=true, $fn=fn);
}

module screwhole_taper(diam=hole_d, enddiam=hole_d, depth=shroud_d, fn=16) {
    rotate([90,0,0]) cylinder(d1=diam, d2=enddiam, h=depth+.001, center=true, $fn=fn);
}


module fanscrew(diam=2, ht=0.8*shroud_d+.2) {
        translate([0,-shroud_d,0]) rotate([90,0,0]) cylinder(d=diam, h=ht, center=true,$fn=16);
}

module shroud() {
    difference() {
        union() {
            translate([0,-shroud_d/2,0]) difference() {
                center_cube(fan_w, shroud_d, fan_w);
                translate([0,0,-fan_w/2]) rotate([90, 0, 0]) scale([1,1.2,1.2]) cylinder(d2=fan_w * .85, d1=fan_w * .65, h=shroud_d+.1, center=true);
                };
            translate([0, -shroud_d/2, -.5*top_h]) center_cube(fan_w, shroud_d, mount_h);
        }
        translate([0,-shroud_d/2,shroud_d/2 - top_h]) center_cube(fan_w, shroud_d+.1, mount_h);
        translate([0,0,-top_h/2-jhead_sink]) jhead();
        translate([top_d/2 + nut_d, -shroud_d/2, -mount_h/2 -.5*top_h]) union() {
            screwhole(hole_d);
            translate([0,screwhead_ln/2 - shroud_d/2, 0]) screwhole_taper(screwhead_d+.4, screwhead_d+1, screwhead_ln+14, 6);
            }
        translate([-(top_d/2 + nut_d), -shroud_d/2, -mount_h/2-.5*top_h]) union() {
            screwhole(hole_d);
            translate([0,screwhead_ln/2 - shroud_d/2, 0]) screwhole_taper(screwhead_d+.4, screwhead_d+1, screwhead_ln+14, 6);
            }
        translate([fan_w/2 - .1 * fan_w, 0, -.1 * fan_w]) fanscrew();
        translate([-(fan_w/2 - .1 * fan_w), 0, -.1 * fan_w]) fanscrew();
        translate([fan_w/2 - .1 * fan_w, 0, -.9 * fan_w]) fanscrew();
        translate([-(fan_w/2 - .1 * fan_w), 0, -.9 * fan_w]) fanscrew();
        scale([1.2,1,1]) translate([0,-20,-22]) rotate([90,0,0]) cylinder(d1=fan_w * .55, d2 = fan_w *0.85, h=shroud_d+.1, center=true);
        }

}
module roundcube(x, y, z, r, ul=true, ur=true, ll=true, lr=true) {
    union() {
        difference() {
            cube([x, y, z]);
            if (ul) translate([0-.1, 0-.1, 0-.1]) cube([r+.2, r+.2, z+.2]);
            if (ur) translate([x-r-.1, 0-.1, 0-.1]) cube([r+.2, r+.2, z+.2]);
            if (ll) translate([0-.1, y-r-.1, 0-.1]) cube([r+.2, r+.2, z+.2]);
            if (lr) translate([x-r-.1, y-r-.1, 0-.1]) cube([r+.2, r+.2, z+.2]);
        }
        intersection() {
            cube([x, y, z]);
            union() {
            if (ul) translate([r, r, 0]) cylinder(r=r, h=z);
            if (ur) translate([x-r, r, 0]) cylinder(r=r, h=z);
            if (ll) translate([r, y-r, 0]) cylinder(r=r, h=z);
            if (lr) translate([x-r, y-r, 0]) cylinder(r=r, h=z);
            }
        }
    }
}

module roundcubecenter(x, y, z, r, ul=true, ur=true, ll=true, lr=true) {
    translate([-x/2, -y/2, -z/2]) roundcube(x, y, z, r, ul, ur, ll, lr) ;
}


module holder() {
    spc=0.5;
    translate([0,0,6.4]) difference() {
        translate([0,clamp_d/2, -mount_h/2]) roundcubecenter(fan_w*.800, clamp_d, mount_h, 2, false, false, true, true);
        translate([0,0,+0*top_h-jhead_sink]) jhead();
        translate([0,spc/2,0]) center_cube(fan_w, spc, mount_h);
        translate([top_d/2 + nut_d, clamp_d/2, -mount_h/2]) rotate([0,0,180]) {
            screwhole(hole_d);
            translate([0,screwhead_ln/2 - clamp_d/2, 0]) screwhole(screwhead_d, screwhead_ln);
        }
        translate([-(top_d/2 + nut_d), clamp_d/2, -mount_h/2]) rotate([0,0,180]) {
            screwhole(hole_d);
            translate([0,screwhead_ln/2-clamp_d/2, 0])  screwhole(screwhead_d, screwhead_ln);
        }
    }
}


module machojheadeffector() {
    // Platform
    difference() {
        effector_base();
        translate([0, 0, 0]) cylinder(r = r2_opening, h = t_effector + 0.1, center = true);
        // Wiring hole
        translate([0,-20,0]) cylinder(d=7, h=20, center=true);
        translate([0,-15,0]) cube([7,10,20], center=true);
    }

    // Anchors
    for (angle = [0, 120, 240]) {
        rotate([0,0,angle]) translate([0,17.5,5]) {
            difference() {
                union() {
                    cube([9,5.5,4], center=true);
                    translate([0,0,1.5]) rotate([90,0,0]) cylinder(d=9, h=5.5, center=true);

                }
                translate([0,0,1.5]) rotate([90,0,0]) cylinder(d=3.3, h=10, center=true);
                translate([0,-5,1.5]) rotate([90,0,0]) cylinder(d=7, h=10, center=true, $fn=6);
            };
        };
    }

    // Probe mount
    difference() {
        union() {
            rotate([0,0,120]) translate([0,10+17.5,0]) cube([22,13,6.0], center=true);
            rotate([0,0,120]) translate([0,32,30/2-6/2]) cylinder(d=23, h=30, center=true);
            translate([-24,0,20]) rotate([0,0,50]) cube([24,5,10], center=true);
        }
        rotate([0,0,120]) translate([0,32,30/2-6/2]) cylinder(d=18.6, h=31, center=true);
        rotate([0,0,120]) translate([0,17.5,5]) translate([0,0,1.5]) rotate([90,0,0]) cylinder(d=7, h=60, center=true);
    }

    // Fan Grabber
    rotate([0,0,-120]) translate([0,10+17.5-2,+30/2-3]) difference() {
        cube([18,25,30], center=true);
        cube([15.2,26,31], center=true);
    }
    translate([21,3,13]) rotate([0,0,60]) rotate([90,0,0]) scale([1,2,1]) difference() {
        cube([10,10,2], center=true);
        rotate([0,0,45]) translate([10,0,0]) cube([20,20,3], center=true);
    }
    translate([7,-20,13]) rotate([0,0,60]) rotate([270,0,0]) scale([1,2,1]) difference() {
        cube([10,10,2], center=true);
        rotate([0,0,180+45]) translate([10,0,0]) cube([20,20,3], center=true);
    }


    // Fan shroud
    difference() {
        translate([0,0*6.321,40-0]) rotate([0,0,180]) {
            intersection() {
                translate([0,-shroud_d/2,-fan_w/2]) scale([1.1,1.2,1.8]) rotate([90, 0, 0]) cylinder(d2=fan_w, d1=fan_w *.75, h=shroud_d+.1, center=true);
                shroud();
            }

        }
        translate([0, 0, +t_effector/2 + fan_w/6]) cylinder(r1 = r2_opening, r2=fins_d/2, h = fan_w/3, center = true);
        translate([0, 0, 0]) cylinder(r = r2_opening, h = t_effector + 0.1, center = true);
    }
}


module fancowl_tube(w=0) {
    hull() {
        cube([w*2+15,w*2+20,1], center=true);
        translate([0,0,30]) cube([w*2+15/2,w*2+20/4,1], center=true);
        for (a=[5,10,20,40,60,80]) rotate([a,0,0]) cube([w*2+15,w*2+20,1], center=true);
    }
}

module fancowl() {
    rotate([104,0,0]) difference() {
        fancowl_tube(1);
        fancowl_tube(0);
        translate([-15/2,1,12]) rotate([-120,0,0]) cube([15,20,50]);
    }
}




module fanfemale()
{
    w = 8.2+.2+.5;
    l = 12.8+.2;
    h = 5+.2+.75+.25;
    
    translate([-w/2,0,-0.25]) cube([w, l, h]);
    for (x = [-w/2, w/2 - 2]) translate([x, 0, h-.25]) cube([2, l, 2]);
};
  

module dupontmale()
{
    w = 8+.75;
    l = 15;
    h = 3+.75;
    translate([-w/2, 0, 0]) cube([w,l,h]);
}

module fanpowershroud()
{
    rotate([90,0,0]) translate([0,10,0]) difference() {
        translate([-12/2, -15+2, -1.5]) cube([12, 21, 8]);
        translate([0,0,5-3]) rotate([0,0,180]) dupontmale();
        fanfemale();
    
        translate([-2.8,-12,6.0]) rotate([0,180,0]) rotate([0,0,90]) rotate([180,00,0]) linear_extrude(height = 1) text(text = "GND", font = "Liberation Sans", size = 2.5);
        translate([-2.8+4,-12,6.0]) rotate([0,180,0]) rotate([0,0,90]) rotate([180,00,0]) linear_extrude(height = 1) text(text = "VCC", font = "Liberation Sans", size = 2.5);
        translate([-2.8+4+4,-12,6.0]) rotate([0,180,0]) rotate([0,0,90]) rotate([180,00,0]) linear_extrude(height = 1) text(text = "TACH", font = "Liberation Sans", size = 2.5);
    };
};
