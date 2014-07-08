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

int main(string[] args)
{
  string sig = "mem";

  if(args.length > 1) {
    if(args[1] == "-d" || args[1] == "--disk") {
      sig = "disk";
    }
  }

  File f = File("/sys/power/state", "w");
  f.write(sig);
  f.close();

  return 0;
}
