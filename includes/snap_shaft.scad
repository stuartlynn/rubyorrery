module snap_shaft(h = 30, r1=10, overhang=2){
	difference(){
		difference(){
			union(){
				cylinder(r=r1, h=h);
				translate([0,0,h-(r1+overhang)/2])
					cylinder(r1=(r1+overhang),r2=r1, h=(r1+overhang)/2.0);
			}
			translate([0,0, (h-r1)]){
				cube(center=true,[2*(r1+overhang),(overhang)*2,2*(r1+overhang)]);
			}	
		}
		union(){
			translate([r1,-(r1+overhang),0])
				cube([overhang,(r1+overhang)*2,h]);
			translate([-r1-overhang,-(r1+overhang),0])
				cube([overhang,(r1+overhang)*2,h]);
		}
	}
}
