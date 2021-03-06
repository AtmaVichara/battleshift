class ShipPlacer
  def initialize(board:, ship:, start_space:, end_space:)
    @board       = board
    @ship        = ship
    @start_space = start_space
    @end_space   = end_space
    @messages = []
  end

  def run
    begin
      if same_row?
        place_in_row
      elsif same_column?
        place_in_column
      else
        raise InvalidShipPlacement.new("Invalid ship placement. Ship must be in either the same row or column.")
      end
    rescue InvalidShipPlacement => e
      @messages << e.message
    end
  end

  def ships_placed
    @board.get_ships.length
  end

  def message_formatter(size)
    if size.to_i == 2 && ships_placed == 1
      @messages <<  "Successfully placed ship with a size of 2. You have #{ships_placed} ship(s) to place with a size of 3."
    elsif size.to_i == 3 && ships_placed == 1
      @messages << "Successfully placed ship with a size of 3. You have #{ships_placed} ship(s) to place with a size of 2."
    elsif ships_placed == 3
      @messages << "Invalid ship placement. You have placed all your ships."
    else
      @messages << "Successfully placed ship with a size of #{size}. You have 0 ship(s) to place."
    end
  end

  def message
    @messages.first
  end


  private
  attr_reader :board, :ship,
    :start_space, :end_space

  def same_row?
    start_space[0] == end_space[0]
  end

  def same_column?
    start_space[1] == end_space[1]
  end

  def place_in_row
    row = start_space[0]
    range = start_space[1]..end_space[1]
    raise InvalidShipPlacement unless range.count == ship.length.to_i
    range.each { |column| place_ship(row, column) }
  end

  def place_in_column
    column = start_space[1]
    range   = start_space[0]..end_space[0]
    raise InvalidShipPlacement unless range.count == ship.length.to_i
    range.each { |row| place_ship(row, column) }
  end

  def place_ship(row, column)
    coordinates = "#{row}#{column}"
    space = board.locate_space(coordinates)
    if space.occupied?
      raise InvalidShipPlacement.new("Invalid ship placement. Attempting to place ship in a space that is already occupied.")
    else
      space.occupy!(ship)
    end
  end
end
