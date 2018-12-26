with Ada.Numerics.Discrete_Random;
with HAL.Bitmap; use HAL.Bitmap;

package Game is

  Nb_Enemies : constant := 5;
  
  type Direction is (No, Up, Down, Left, Right);
  type Enemy_Record is record
    Pos : Point;
    Dir : Direction;
  end record;
  type Enemies_Array is array (1 .. Nb_Enemies) of Enemy_Record;
  
  enemies : Enemies_Array;
  self_pos : Point := (7, 12);
  coins : Integer := 226;
  next_dir : Direction := Up;
  prev_dir : Direction := Up;
  
  package Random_Integer is new Ada.Numerics.Discrete_Random(Integer);
  gen : Random_Integer.Generator;
  
  function Move_Player(dir : Direction) return Boolean;
  
  
  function Nearest_Player(pos : Point) return Direction;
  function Move_Enemies return Boolean;
  function Generate_Enemies return Enemies_Array;
  
  function Touch_Screen return Boolean;
  
end Game;
