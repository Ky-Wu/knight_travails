class Tree
  def initialize(starting_position)
    @root = Position.new(starting_position)
    raise 'Not valid start!' unless valid?(starting_position)
    @position_changes = [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]
  end

  def find_shortest_path(end_position)
    raise 'Not valid end!' unless valid?(end_position)
    start = @root.position
    path = [end_position]
    queue = [@root]
    queue.each do |node|
      all_moves = @position_changes.map do |change|
        [change[0] + node.position[0], change[1] + node.position[1]]
      end
      if all_moves.include?(end_position)
        current_node = node
        until current_node.nil?
          path.unshift(current_node.position)
          current_node = current_node.previous_position
        end
        return path
      end
      valid_moves = all_moves.select {|move| valid?(move) }
      valid_moves.each do |move|
        possible_move = Position.new(move)
        node.possible_moves << possible_move
        possible_move.previous_position = node
        queue << possible_move
      end
    end
  end

  private
  
  def valid?(position)
    return false unless position.is_a?(Array) && position.length == 2
    position.each { |number| return false unless (0..7).include?(number) }
    true
  end
end

class Position
  attr_accessor :position, :possible_moves, :previous_position
  def initialize(position)
    @previous_position = nil
    @position = position
    @possible_moves = []
  end
end

def knight_moves(start, goal)
  tree = Tree.new(start)
  path = tree.find_shortest_path(goal)
  puts "You made it in #{path.length - 1} moves! Here's your path:"
  path.each {|position| print "#{position}\n"}
end
