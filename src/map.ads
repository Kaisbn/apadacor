with STM32.Board; use STM32.Board;
with HAL.Bitmap; use HAL.Bitmap;

package Map is

  Rows : constant := 22; -- Number of cells from up to down
  Columns : constant := 30; -- Number of cells from left to right
  Square_Height : constant := LCD_Natural_Height / Rows;
  Square_Width : constant := LCD_Natural_Width / Columns;
  
  type Cell is (Air, Wall, Outside, Self, Coin);
  type Map_Type is array (1 .. Rows, 1 .. Columns) of Cell;
  
  function Get_Cell(pos : Point) return Cell; -- Get the cell at `pos` from the map
  procedure Set_Cell(pos : Point ; t_cell : Cell); -- Set the cell at `pos` to the map
  
  pacmap : Map_Type := (
    (Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall),
    (Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall),
    (Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall),
    (Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall),
    (Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall),
    (Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall),
    (Wall, Coin, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Coin, Wall),
    (Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall),
    (Outside, Outside, Outside, Outside, Outside, Wall, Coin, Wall, Wall, Air, Air, Air, Air, Air, Air, Air, Air, Air, Air, Air, Air, Wall, Wall, Coin, Wall, Outside, Outside, Outside, Outside, Outside),
    (Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Air, Wall, Wall, Wall, Wall, Air, Air, Wall, Wall, Wall, Wall, Air, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall),
    (Air, Air, Air, Air, Air, Air, Coin, Air, Air, Air, Wall, Air, Air, Air, Air, Air, Air, Air, Air, Wall, Air, Air, Air, Coin, Air, Air, Air, Air, Air, Air),
    (Wall, Wall, Wall, Wall, Wall, Wall, Self, Wall, Wall, Air, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Air, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall),
    (Outside, Outside, Outside, Outside, Outside, Wall, Coin, Wall, Wall, Air, Air, Air, Air, Air, Air, Air, Air, Air, Air, Air, Air, Wall, Wall, Coin, Wall, Outside, Outside, Outside, Outside, Outside),
    (Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Air, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Air, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall),
    (Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall),
    (Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Coin, Wall),
    (Wall, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Wall),
    (Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall),
    (Wall, Coin, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Wall, Wall, Coin, Coin, Coin, Coin, Coin, Coin, Wall),
    (Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall, Wall, Coin, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Coin, Wall),
    (Wall, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Coin, Wall),
    (Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall, Wall)
  );
  
  -- Print the map on LCD Screen
  procedure Print_Map;

end Map;
