class Board
	attr_reader :grid

	def initialize(cell)
		@grid = {}
		[*1..10].each do |n|
			[*"A".."J"].each do |l|
			  @grid["#{l}#{n}".to_sym] = cell.new
		    @grid["#{l}#{n}".to_sym].content = Water.new
		  end
	  end
  end

	def show
		output = "<table><tr></tr>"
		x = 0
		grid.each do |cell|
			if x % 10 == 0
				output += "</tr><tr>"
				output += "<th> #{cell} </th>"
				x += 1
			else
				output += "<th> #{cell} </th>"
				x += 1
			end
		end
		output += "</table>"
	end

	def show2
		output = "<div style= 'width: 700px; height: 650px;'>"
		[*1..10].each do |n|
			[*"A".."J"].each do |l|
				if grid["#{l}#{n}".to_sym].hit?
					output += "<div style= 'width: 65px; height: 65px;
					  display: inline-block;
					  border: 1px rgb(89,89,89) solid;
	          padding: 0px;
	          background: rgb(255, 0, 0);'></div>"
				elsif grid["#{l}#{n}".to_sym].is_a? Ship
				  output += "<div style= 'width: 65px; height: 65px;
					  display: inline-block;
					  border: 1px rgb(89,89,89) solid;
	          padding: 0px;
	          background: rgb(171, 95, 36);'></div>"
				else
					output += "<div style= 'width: 65px; height: 65px;
					  display: inline-block;
					  border: 1px rgb(89,89,89) solid;
	          padding: 0px;
	          background: rgb(73, 244, 249);'></div>"
				end
			end
		end
		output += "</div>"
	end

	def place(ship, coord, orientation = :horizontally)
		coords = [coord]
		ship.size.times{coords << next_coord(coords.last, orientation)}
		put_on_grid_if_possible(coords, ship)
	end

	def floating_ships?
		ships.any?(&:floating?)
	end

	def shoot_at(coordinate)
		raise "You cannot hit the same square twice" if  grid[coordinate].hit?
		grid[coordinate].shoot
	end

	def ships
		grid.values.select{|cell|is_a_ship?(cell)}.map(&:content).uniq
	end

	def ships_count
		ships.count
	end

private

 	def next_coord(coord, orientation)
		orientation == :vertically ? next_vertical(coord) : coord.next
	end

	def next_vertical(coord)
		coord.to_s.reverse.next.reverse.to_sym
	end

	def is_a_ship?(cell)
		cell.content.respond_to?(:sunk?)
	end

	def any_coord_not_on_grid?(coords)
		(grid.keys & coords) != coords
	end

	def any_coord_is_already_a_ship?(coords)
		coords.any?{|coord| is_a_ship?(grid[coord])}
	end

	def raise_errors_if_cant_place_ship(coords)
		raise "You cannot place a ship outside of the grid" if any_coord_not_on_grid?(coords)
		raise "You cannot place a ship on another ship" if any_coord_is_already_a_ship?(coords)
	end

	def put_on_grid_if_possible(coords, ship)
		raise_errors_if_cant_place_ship(coords)
		coords.each{|coord|grid[coord].content = ship}
	end

end
