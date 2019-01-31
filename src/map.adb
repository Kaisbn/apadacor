with LCD_Std_Out; use LCD_Std_Out;
with Game; use Game;
package body Map is

  function Get_Cell(pos : Point) return Cell
  is
  begin
    return pacmap(pos.x, pos.y);
  end Get_Cell;

  procedure Set_Cell(pos : Point ; t_cell : Cell) is
  begin
    pacmap(pos.x, pos.y) := t_cell;
  end Set_Cell;
    
  procedure Print_Map
  is
  begin
    Display.Hidden_Buffer (1).Set_Source(HAL.Bitmap.Black);
    Display.Hidden_Buffer (1).Fill;
    for i in 1 .. Rows loop
      for j in 1 .. Columns loop
        case Get_Cell((i, j)) is
          when Air | Outside =>
            Display.Hidden_Buffer (1).Set_Source(HAL.Bitmap.Black);
            Display.Hidden_Buffer (1).Fill_Rect ((((j - 1) * Square_Width, (i - 1) * Square_Height), Square_Width, Square_Height));
          when Wall =>
            Display.Hidden_Buffer (1).Set_Source(HAL.Bitmap.Blue);
            Display.Hidden_Buffer (1).Fill_Rect ((((j - 1) * Square_Width, (i - 1) * Square_Height), Square_Width, Square_Height));
          when Self =>
            Display.Hidden_Buffer (1).Set_Source(HAL.Bitmap.Yellow);
            Display.Hidden_Buffer (1).Fill_Circle (((j - 1) * Square_Width + Square_Width / 2, (i - 1) * Square_Height + Square_Height / 2), Square_Width / 2);
          when Coin =>
            Display.Hidden_Buffer (1).Set_Source(HAL.Bitmap.White);
            Display.Hidden_Buffer (1).Fill_Circle (((j - 1) * Square_Width + Square_Width / 2, (i - 1) * Square_Height + Square_Height / 2), Square_Width / 6);
          when others =>
            null;
        end case;
      end loop;
    end loop;
    Display.Hidden_Buffer (1).Set_Source(HAL.Bitmap.Red);
    for enemy of enemies loop
      Display.Hidden_Buffer (1).Fill_Circle (((enemy.Pos.y - 1) * Square_Width + Square_Width / 2, (enemy.Pos.x - 1) * Square_Height + Square_Height / 2), Square_Width / 2);
    end loop;
    Display.Update_Layer (1, Copy_Back => True);
  end Print_Map;
  
end Map;
