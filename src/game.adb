with STM32.Board; use STM32.Board;
with HAL.Touch_Panel; use HAL.Touch_Panel;
with Ada.Real_Time;
with LCD_Std_Out;
with STM32.User_Button; use STM32;

package body Game is

  function Move_Player(dir : Direction ; coins : in out Integer) return Boolean
  is
    x : Integer := 0;
    y : Integer := 0;
  begin
    x := self_pos.x;
    y := self_pos.y;
    if (dir = Left and then x - 1 <= 0) then
      x := Columns;
    elsif (dir = Right and then x + 1 > Columns) then
      x := 1;
    elsif (dir = Up and then y - 1 > 0 and then Get_Cell((y - 1, x)) /= Wall) then
      y := y - 1;
    elsif (dir = Down and then y + 1 <= Rows and then Get_Cell((y + 1, x)) /= Wall) then
      y := y + 1;
    elsif (dir = Left and then x - 1 > 0 and then Get_Cell((y, x - 1)) /= Wall) then
      x := x - 1;
    elsif (dir = Right and then x + 1 <= Columns and then Get_Cell((y, x + 1)) /= Wall) then
      x := x + 1;
    else
      return False;
    end if;
    Set_Cell((self_pos.y, self_pos.x), Air);
    if Get_Cell((y, x)) = Coin then
      coins := coins - 1;
    end if;
    Set_Cell((y, x), Self);
    self_pos := (x, y);
    return True;
  end Move_Player;

  function Nearest_Player(pos : Point) return Direction
  is
    player : Point := pos;
    min_dist : Integer := 5;
    ret : Direction := No;
    i : Natural := 0;
    cur : Cell := Wall;
  begin
    while player.y <= Columns and then i < min_dist loop
      cur := Get_Cell(player);
      if cur = Self then
        min_dist := i;
        ret := Right;
        exit;
      elsif cur = Wall then
        exit;
      end if;
      i := i + 1;
      player.y := player.y + 1;
    end loop;
    i := 0;
    player := pos;
    while player.y > 0 and then i < min_dist loop
      cur := Get_Cell(player);
      if cur = Self then
        min_dist := i;
        ret := Left;
        exit;
      elsif cur = Wall then
        exit;
      end if;
      i := i + 1;
      player.y := player.y - 1;
    end loop;
    i := 0;
    player := pos;
    while player.x <= Rows and then i < min_dist loop
      cur := Get_Cell(player);
      if cur = Self then
        min_dist := i;
        ret := Down;
        exit;
      elsif cur = Wall then
        exit;
      end if;
      i := i + 1;
      player.x := player.x + 1;
    end loop;
    i := 0;
    player := pos;
    while player.x > 0 and then i < min_dist loop
      cur := Get_Cell(player);
      if cur = Self then
        min_dist := i;
        ret := Up;
        exit;
      elsif cur = Wall then
        exit;
      end if;
      i := i + 1;
      player.x := player.x - 1;
    end loop;
    return ret;
  end Nearest_Player;

  function Move_Enemies return Boolean
  is
    ret : Boolean := True;
    nearest : Direction := No;
    pos : Point;
    next_dir : Direction;
    type Direction_Array is array (1 .. 4) of Direction;
    possible_dirs : constant Direction_Array := ( Up, Down, Right, Left );
  begin
    for enemy of enemies loop
      if Get_Cell((enemy.Pos.x, enemy.Pos.y)) = Self then
        ret := False;
      end if;
      nearest := nearest_player(enemy.Pos);
      if nearest /= No then
        enemy.Dir := nearest;
      end if;
      pos := enemy.Pos;
      loop
        if (enemy.Dir = Left and then pos.y - 1 > 0 and then Get_Cell((pos.x, pos.y - 1)) /= Wall) then
          pos.y := pos.y - 1;
        elsif (enemy.Dir = Right and then pos.y + 1 < Columns and then Get_Cell((pos.x, pos.y + 1)) /= Wall) then
          pos.y := pos.y + 1;
        elsif (enemy.Dir = Up and then pos.x - 1 > 0 and then Get_Cell((pos.x - 1, pos.y)) /= Wall) then
          pos.x := pos.x - 1;
        elsif (enemy.Dir = Down and then pos.x + 1 < Rows and then Get_Cell((pos.x + 1, pos.y)) /= Wall) then
          pos.x := pos.x + 1;
        else
          next_dir := possible_dirs((Random_Integer.Random(gen) mod 4) + 1);
          while (next_dir = enemy.Dir) loop
            next_dir := possible_dirs((Random_Integer.Random(gen) mod 4) + 1);
          end loop;
          enemy.Dir := next_dir;
        end if;
        if pos.x /= enemy.Pos.x or pos.y /= enemy.Pos.y then
          exit;
        end if;
      end loop;
      enemy.Pos := pos;
      if Get_Cell(enemy.Pos) = Self then
        ret := False;
      end if;
    end loop;
    return ret;
  end Move_Enemies;

  function Generate_Enemies return Enemies_Array
  is
    pos : Point;
    i : Integer := 1;
    nb : Integer := Nb_Enemies;
    enemies_ret : Enemies_Array;
  begin
    while nb > 0 loop
      pos.x := (Random_Integer.Random(gen) mod Rows) + 1;
      pos.y := (Random_Integer.Random(gen) mod Columns) + 1;
      if Get_Cell(pos) = Air or else Get_Cell(pos) = Coin then
        nb := nb - 1;
        enemies_ret(i) := (pos, Up);
        i := i + 1;
      end if;
    end loop;
    return enemies_ret;
  end Generate_Enemies;
  
  function Get_Next_Direction(next_dir : Direction) return Direction
  is
    finger_pos : Point;
    function PointInTriangle (pt : Point ; v1 : Point ; v2 : Point ; v3 : Point) return Boolean
    is
      d1, d2, d3 : Integer;
      has_neg, has_pos : Boolean;
      function sign(p1 : Point ; p2 : Point ; p3 : Point) return Integer is
      begin
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
      end sign;
    begin
      d1 := sign(pt, v1, v2);
      d2 := sign(pt, v2, v3);
      d3 := sign(pt, v3, v1);

      has_neg := (d1 < 0) or else (d2 < 0) or else (d3 < 0);
      has_pos := (d1 > 0) or else (d2 > 0) or else (d3 > 0);

      return not (has_neg and then has_pos);
    end PointInTriangle;
  begin
      declare
          State : constant TP_State := Touch_Panel.Get_All_Touch_Points;
      begin
          case State'Length is
          when 1 =>
            finger_pos := (State (State'First).X, State (State'First).Y);
            if finger_pos.x /= 0 and then finger_pos.y /= 0 then
              if PointInTriangle(finger_pos, (0, 0), (LCD_Natural_Width, 0), (LCD_Natural_Width / 2, LCD_Natural_Height / 2)) then
                return Up;
              elsif PointInTriangle(finger_pos, (0, 0), (LCD_Natural_Width / 2, LCD_Natural_Height / 2), (0, LCD_Natural_Height)) then
                return Left;
              elsif PointInTriangle(finger_pos, (LCD_Natural_Width, 0), (LCD_Natural_Width / 2, LCD_Natural_Height / 2), (LCD_Natural_Width, LCD_Natural_Height)) then
                return Right;
              elsif PointInTriangle(finger_pos, (0, LCD_Natural_Height), (LCD_Natural_Width / 2, LCD_Natural_Height / 2), (LCD_Natural_Width, LCD_Natural_Height)) then
                return Down;
              else
                return next_dir;
              end if;
            end if;
          when others => null;
        end case;
    end;
    return next_dir;
  end Get_Next_Direction;
  
  function Touch_Screen return Boolean
  is
    move_entities : Positive := 1;
    dir : Direction := Up;
    next_dir : Direction := Up;
    not_loose : Boolean := True;
    dir_changes : Boolean := False;
    coins : Integer := 225;
  begin
    enemies := Generate_Enemies;
    Print_Map;
    while coins /= 0 and then not_loose loop
      next_dir := Get_Next_Direction(next_dir);
      if move_entities = 100 then
        if Move_Player(next_dir, coins) then -- Check if we use next_dir from the last user input
          dir := next_dir; -- If yes, it's the new direction
        else
          dir_changes := Move_Player(dir, coins);
        end if;
        not_loose := Move_Enemies;
        Print_Map;
        move_entities := 1;
      else
        move_entities := move_entities + 1;
      end if;
    end loop;
    return coins = 0;
  end Touch_Screen;

end Game;
