require './Orrery.rb'
require 'pry'

# planet_sizes = [1.416, 2, 2.227];
# planet_periods= [0.837495,1.5, 3.29485];
# planet_distances = [ 0.0584,0.1, 0.2407];

planet_sizes = [0.13 , 0.31, 0.83,0.49];
planet_periods= [3.7,10.4, 22.3, 54.3];
planet_distances = [ 0.05,0.099, 0.165, 0.298];



K89 = [
	{
		period: 3.7,
		distance:  0.05,
		size: 0.13
	},
	{
		period: 10.4,
		distance:0.099,
		size: 0.31
	},
	{
		period: 22.3,
		distance: 0.165,
		size: 0.83
	},

	{
		period: 54.3,
		distance: 0.298,
		size: 0.49
	}
]

o = Orrery.new K89

File.open("simple_test.scad", "w") do |f| 
	f.puts o.generate_all
	
end