module snap_shaft(h = 100, r1=20, r2=30){
	difference(){
		union(){
			cylinder(r=r1, h=h);
			translate([0,0,90]){
				cylinder(r1=r2,r2=r1, h=r2);
			}
		}
		translate([0,0,2*r2+30]){
			cube(center=true,[2*r2,(r2-r1)*2,2*r2]);
		}	
	}
}

