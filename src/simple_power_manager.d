/*  
 *  Copyright © 2012 Sipieter Clément <csipieter@gmail.com>
 *
 *  This file is part of simple-power-manager.
 *
 *  Simple-power-manager is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Simple-power-manager is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with simple-power-manager. If not, see <http://www.gnu.org/licenses/>.
 */
 
import std.stdio;
import std.string;
import std.process;
import core.thread;

int bat_percent_critical = 10;
string critical_cmd = "hibernate";


int 
atoi(char[] s)
{
  int val = 0;
  
  for(int i = 0;  i < s.length; ++i)
    {
      if(!isNumeric(s[i]))
        break;
        
      val *= 10;
      val += cast(int)(s[i] - '0');
    }
    
  return val;
}

/**
 * Return 1 if the battery is discharging.
 */
int 
getEnergyStatus(int bat_num)
{
  File f;
	string file_path = "/sys/class/power_supply/BAT0/status";
  char[] buf;

  try
    {
      f = File(file_path, "r");
      f.readln(buf);
      f.close();
    }
  catch{}
  
  if(buf[0] == 'D')
    return 1;

  return 0;
}

int 
getEnergyFull(int bat_num)
{	  
  static int energy_full = 0;
  File f;
	string file_path = "/sys/class/power_supply/BAT0/energy_full";
  char[] buf;
  
  if(energy_full == 0)
    {
      try
        {
          f = File(file_path, "r");
          f.readln(buf);
          f.close();
          
          energy_full = atoi(buf);
        }
      catch{}
    }
  
	return energy_full;
}

int 
getEnergyNow(int bat_num)
{
  int energy_now = 0;
  File f;
	string file_path = "/sys/class/power_supply/BAT0/energy_full";
  char[] buf;
  

  try
    {
      f = File(file_path, "r");
      f.readln(buf);
      f.close();
      
      energy_now = atoi(buf);
    }
  catch{}
  
	return energy_now;
}

int
getEnergyPercent(int bat_num)
{
	int energy_full, energy_now; 
	
	energy_full = getEnergyFull(bat_num);
	energy_now = getEnergyNow(bat_num);
	
	if(energy_full == -1 || energy_now == -1)
		return -1;
		
	return (energy_now * 100) / energy_full;
}

void 
main()
{
  int old_percent_bat = 0;
  int new_percent_bat;
  
  while(true)
    {
      Thread.sleep( dur!("seconds")( 60 ) );
      
      if(new_percent_bat < bat_percent_critical && old_percent_bat >= 10)
        system(critical_cmd);
    }
}
