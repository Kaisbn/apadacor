with Ada.Numerics.Discrete_Random;
with HAL.Bitmap; use HAL.Bitmap;
with Map; use Map;

package Game is

  Nb_Enemies : constant := 5; -- Total number of enemies in the map.
  
  type Direction is (No, Up, Down, Left, Right);
  type Enemy_Record is record
    Pos : Point;
    Dir : Direction;
  end record;
  type Enemies_Array is array (1 .. Nb_Enemies) of Enemy_Record;
  
  enemies : Enemies_Array; -- Position and direction of all of the enemies
  self_pos : Point := (7, 12); -- Position of the Player to move him quicker
  
  -- Create this package to generate Integers.
  package Random_Integer is new Ada.Numerics.Discrete_Random(Integer);
  gen : Random_Integer.Generator;
  
  -- Try to move the player with the given Direction and decrement `coins` if the
  -- Player move on a coin. Return True if the Player moved, False otherwise.
  function Move_Player(dir : Direction ; coins : in out Integer) return Boolean
    with Pre => coins > 0;
  
  -- Return the direction from where the Player is if it is within 5 cells, 'No'
  -- direction otherwise.
  function Nearest_Player(pos : Point) return Direction
    with Pre => pos.x > 0 and then pos.y > 0 and then pos.x <= Columns and then pos.y <= Rows;
  
  -- Move all the enemies. Try to move with the previous direction or a
  -- random direction if it is not possible. Return True if an enemy killed the
  -- Player, False otherwise.
  function Move_Enemies return Boolean
    with Post => (if not Move_Enemies'Result then (for some cell of enemies => (cell.Pos.x = self_pos.x and then cell.Pos.y = self_pos.y)));
  
  -- Generate `Nb_Enemies` enemies with a random direction at a right position
  -- in the map.
  function Generate_Enemies return Enemies_Array
    with Post => (for all enemy of Generate_Enemies'Result =>
                    Get_Cell(enemy.Pos) /= Wall and then Get_Cell(enemy.Pos) /= Outside);
  
  -- Check if there is an user input, then translate it into the correct
  -- direction and return it. Return the direction in parameter otherwise.
  function Get_Next_Direction(next_dir : Direction) return Direction;
  
  -- Main loop that runs the game. Return True if the Player wins, False if it
  -- loses.
  function Touch_Screen return Boolean
    with Post => (if Touch_Screen'Result then (for all cell of pacmap => cell /= Coin)
                  else (for some cell of enemies => (cell.Pos.x = self_pos.x and then cell.Pos.y = self_pos.y)));
                     
  
end Game;
