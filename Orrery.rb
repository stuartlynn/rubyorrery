require 'erb'

class Orrery 

	def initialize (planets, name = "kepler planet")
		
		@planets = planets
		@system_name  = name 
		@size_scale 	            = 10
		@length_scale               = 3000

		@shaft_seperation           = 200

		@drive_shaft_seperation 		= 400

		@vertical_gear_speration    = 20

		@ms_base_radius             = 90
		@ms_radius_inc              = 10
		@ms_key_width               = 5
		@ms_key_length              = 10
		@ms_bore 		            = 40
		@base_planet_no					=	 0 

		@ps_base_radius 		    = 30
		@ps_radius_inc  			= 7
		@ps_thickness   			= 4
		@orrery_shaft_height        = 300

		@base_gear_no 				= 20

		@table_leg_height			= 0
		@table_leg_width			= 5
		@table_width 					= @shaft_seperation
		@table_length					= 150

		@table_height 				= 20
	end

	def includes 
		Dir.glob('includes/*.scad').inject(""){|r,a| r+= IO.read(a); r }
	end

	def main_gears_bore_diameter(order_no) 
		@ms_base_radius-(@ms_radius_inc*order_no);
	end

	def planet_shaft_height
		@orrery_shaft_height/@planets.count;
	end

	def ith_planet_shaft_height(index)
		@orrery_shaft_height - planet_shaft_height*index
	end

	def drive_ratio(pitch, sep, base_gear_no)
		2.0*pitch*sep/base_gear_no.to_f - 1.0
	end

	def ps_cylinder_r(order_no) 
		(@ps_base_radius+ (order_no)*@ps_radius_inc)
	end

	def pair_pitch(ratio, seperation=nil)
		sepration ||= @shaft_seperation
		(1+ ratio)*@base_gear_no/(2.0*@shaft_seperation);
	end

	def render_part(part_name, options= {}, location=nil)
		local_test = 2 

		template = IO.read("templates/#{part_name}.scad.erb")
		
		if location 
			template= """
				translate([#{location[0]}, #{location[1]}, #{location[2]}]){
				#{template}
			}
		"""
		end

		template = ERB.new(template)
		template.result(binding)
	end

	def planet_gear_ratio(planet)
		# planet[:period]/@planets[@planets.length/2][:period].to_f 

		planet[:period]/@planets[@base_planet_no][:period].to_f 
	end

	def render_planet_arm(planet, index)
		render_part("planet_arm", {planet: planet, index: index}, [20 + 102*(@planets.length-index), 190   , 0 ] )
	end

	def render_planet_arms
		result = []
		@planets.each_with_index do |planet,index|
			result << render_planet_arm(planet,index)
		end
		result 
	end

	def render_planet_shafts()
		result = [ ]
		@planets.each_with_index do |planet,index|
			result << render_planet_shaft(planet, index, @base_gear_no)
		end
		result
	end

	def render_planet_shaft(planet,index, base_gear_no)
		render_part("planet_shaft", {planet:planet, index:index, ratio: planet_gear_ratio(planet)}, [-60, 270 + 252*index, 0])
		# render_part("planet_shaft", {planet:planet, index:index, ratio: planet_gear_ratio(planet)}, [0, 0, @table_height + index*planet_shaft_height])
	end

	def render_table()
		render_part("table",{})
	end

	def generate_controll_shaft

	end


	def generate_all()
		[includes,
		 "scale([0.13,0.13,0.13]){",
		 render_part("drive_shaft",{}, [ @table_width/2.0 + @shaft_seperation/2.0 +20, @table_length/2.0  + 700,0]),
		 # render_part("drive_shaft",{}, [ @shaft_seperation/2.0 + @ms_bore/2.0 -2, 0 ,@table_height]),
		 
		 # "rotate([0,0,90]){",
		 	render_planet_arms(),
		 # "}",
		 render_planet_shafts(),
		 render_table(),

		 # render_part("planet_name", {}, [-@shaft_seperation, -@table_width/2.0, @table_height -10]),
		 # render_part("turny_bit", {}, [ @drive_shaft_seperation + @ms_bore/2.0 -2, @drive_shaft_seperation + @ms_bore/2.0 -2,@table_height ]),
		 # render_part("turny_bit", {}, [ 500, 400, 0 ]),
		 "}"
		]
	end

end