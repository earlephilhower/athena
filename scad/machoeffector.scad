include <athena.scad>

// Layout for printing.  Ensure everyone is at same Z base!
if (true) intersection() {
    union() {
        if (true) translate([0,0,-3]) probepoint();
        if (true) machojheadeffector();
        if (true) translate([0,25,0]) holder();
        if (true) translate([3,48,7.8]) rotate([0,0,-90]) fancowl();
        if (true)
            for (x=[23,38]) for (y=[41, 52]) translate([x, y, 0]) fanpowershroud();
        if (false) {
            translate([50,-20,-3]) rotate([0,0,-30]) {
                pneucap(thru=true);
                translate([18,0,0]) pneucap(thru=false);
                translate([18,-18,0]) pneunut();
                translate([0,-18,0]) pneunut();
            }
        }
    }
    // And get rid of anything below -3 (our base)
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

module probepoint() {
    difference() {
        union() {
            cylinder(d1=19, d2=18,h=5);
            cylinder(d1=3, d2=.4, h=10, $fn=16);
        }
        cylinder(d1=18, d2=17,h=4);
    }

    for (a=[0,90]) rotate([0,0,a]) translate([0,0,3.8/2]) cube([10,1.2,3.8], center=true);
}

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
        for (x=[+1, -1])
            for (y=[-.1, -.9])
                translate([x*(fan_w/2 - .1 * fan_w), 0, y * fan_w]) fanscrew(ht=14);
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
        // Get rid of arrow, interferes with hotend fan
        translate([0, 26.3, 0]) cube([10,10,10], center=true);
    }

    // Anchors
    anchor_w = 10;
    for (angle = [0, 120, 240]) {
        rotate([0,0,angle]) translate([0,17.5,5]) {
            difference() {
                union() {
                    cube([anchor_w,5.5,4], center=true);
                    translate([0,0,1.5]) rotate([90,0,0]) cylinder(d=anchor_w, h=5.5, center=true);

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
            rotate([0,0,120]) translate([0,32.5,30/2-6/2]) cylinder(d=23, h=30, center=true);
            translate([-24,0,20]) rotate([0,0,50]) cube([24,5,10], center=true);
        }
        rotate([0,0,120]) translate([0,32.5,30/2-6/2]) cylinder(d=18.6, h=31, center=true);
        rotate([0,0,120]) translate([0,17.5,5]) translate([0,0,1.5]) rotate([90,0,0]) cylinder(d=7, h=60, center=true);
    }

    // Fan Grabber
    rotate([0,0,-120]) translate([0,10+17.5-2,+30/2-3]) difference() {
        union() {
            cube([18,25,32], center=true);
            // Bolt hole reinforcement
            rotate([0,90,0]) translate([-12.5,-9.5,0]) cylinder(d=7.0, h=18, center=true);
        }
        cube([15.5,26,33], center=true);
        // Bolt hole
        rotate([0,90,0]) translate([-12.5,-9.5,0]) cylinder(d=4, h=50, center=true);
        // Fan intake
        translate([0,13,5]) rotate([180,90,0]) cylinder(d=33, h=20);
    }
    translate([21,3,12]) rotate([0,0,60]) rotate([90,0,0]) scale([1,1.9,1]) difference() {
        cube([10,10,2], center=true);
        rotate([0,0,45]) translate([10,0,0]) cube([20,20,3], center=true);
    }
    translate([7,-20,12]) rotate([0,0,60]) rotate([270,0,0]) scale([1,1.9,1]) difference() {
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

module fancowl() {
    module fancowl_tube(w=0) {
        hull() {
            cube([w*2+15,w*2+20,1], center=true);
            translate([0,0,30]) cube([w*2+15/2,w*2+20/4,1], center=true);
            for (a=[5,10,20,40,60,80]) rotate([a,0,0]) cube([w*2+15,w*2+20,1], center=true);
            translate([0,13,0]) rotate([90,0,0]) cube([w*2+15,w*2+20,1], center=true);
        }
    }
    difference() {
        union() {
        rotate([104,0,0]) difference() {
            fancowl_tube(1);
            fancowl_tube(0);
            translate([-15/2,1,12]) rotate([-120,0,0]) cube([15,20,50]);
        }
        for (x=[-8,8]) translate([x,1,60/2]) cube([1,20,60-1], center=true);
        for (y=[-7/*, 9*/]) translate([0,y,60-2/2-2/2]) cube([16,4,3], center=true);
        }
        translate([-8,-9,35-1]) scale([1,5,9]) rotate([0,90,0]) cylinder(d=5,h=4,center=true);
    }
}


module fanpowershroud()
{
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

    rotate([90,0,0]) translate([0,10,0]) difference() {
        translate([-12/2, -15+2, -1.5]) union() { cube([12, 21, 8]); cube([12, 11, 9]); }
        translate([0,0,5-3]) rotate([0,0,180]) dupontmale();
        fanfemale();

        translate([-2.8,-12,7]) rotate([0,180,0]) rotate([0,0,90]) rotate([180,00,0]) linear_extrude(height = 2) text(text = "GND", font = "Liberation Sans", size = 2.5);
        translate([-2.8+4,-12,7]) rotate([0,180,0]) rotate([0,0,90]) rotate([180,00,0]) linear_extrude(height = 2) text(text = "VCC", font = "Liberation Sans", size = 2.5);
        translate([-2.8+4+4,-12,7]) rotate([0,180,0]) rotate([0,0,90]) rotate([180,00,0]) linear_extrude(height = 2) text(text = "TACH", font = "Liberation Sans", size = 2.5);
    };
};





module pneucap(thru = false) {
    ht = thru ? 12 : 10;
    wd = thru ? 11.7 : 12;
    difference() {
        cylinder(d=12+3, h=ht, $fn=6);
        translate([0,0,-.1]) cylinder(d=wd, h=ht+1, $fn=6);
        translate([0,0,-.1]) cylinder(d1=wd+.8, d2=wd, h=2, $fn=6);
    };

    difference() {
        union() {
            translate([0, 0, ht+2]) {
                difference() {
                    metric_thread(diameter=12.5, pitch=1.1, length=11, taper=.33);
                    translate([0,0,-.1]) cylinder(d=4.6,h=20, $fn=32);
                };
                for (z=[0.5:1.5:10]) {
                    translate([0,0,z]) difference() {
                        cylinder(d=7, h=.4);
                        translate([0,0,-.05]) cylinder(d=4.2, h=.5, $fn=16);
                    }
                }
            }
        }
        translate([0,0,12]) for (angle=[0:120:359]) {
            rotate([0,0,angle]) translate([-.6,0,-.1]) cube([1.6,10,20]);
        }
    }

    translate([0,0,ht]) difference() {
        cylinder(d1=13, d2=12, h=2, $fn=32);
        cylinder(d1=7, d2=5, h=2, $fn=32);
    }
}



module pneunut() {
    difference() {
        cylinder(d=12+4, h=8, $fn=6);
        metric_thread(diameter=11.5, pitch=1.1, length=9);
    }
}

