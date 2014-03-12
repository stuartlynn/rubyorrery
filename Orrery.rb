require 'erb'

class Orrery 

	def initialize (planets)
		
		@planets = planets
		@size_scale 	            = 20
		@length_scale               = 1000

		@shaft_seperation           = 200
		@vertical_gear_speration    = 20

		@ms_base_radius             = 90
		@ms_radius_inc              = 10
		@ms_key_width               = 5
		@ms_key_length              = 10
		@ms_bore 		            = 30


		@ps_base_radius 		    = 20
		@ps_radius_inc  			= 7
		@ps_thickness   			= 4
		@orrery_shaft_height        = 300

		@base_gear_no 				= 10

		@table_leg_height			= 50
		@table_leg_width			= 5
		@table_width 				= @shaft_seperation*2
		@table_length				= 200
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

	def ps_cylinder_r(order_no) 
		(@ps_base_radius+ (order_no)*@ps_radius_inc)
	end

	def pair_pitch(ratio)
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
		planet[:period]/@planets[0][:period].to_f 
	end

	def render_planet_arm(planet, index)
		render_part("planet_arm", {planet: planet, index: index}, [500, 400*(index+1), 0] )
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
		render_part("planet_shaft", {planet:planet, index:index, ratio: planet_gear_ratio(planet)}, [0, 500 + 200*index, 0])
	end

	def render_table()
		render_part("table",{})
	end


	def generate_all()
		[includes,
		 render_part("drive_shaft",{}, [ @table_width/2.0 + @shaft_seperation/2.0, @table_length/2.0 , @table_leg_height- @planets.length*@vertical_gear_speration +25]),
		 # render_planet_arms(),
		 render_planet_shafts(),
		 render_table()
		]
	end

end