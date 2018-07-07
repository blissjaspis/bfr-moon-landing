global turn_start_velocity to 100.
set turn_pitch_base to 0.985.
//set turn_pitch_mult to 90 / 80000.


// -- SHIP VALUE
// global booster_separation_fuel to 83000.
// -- TANKER VALUE
global booster_separation_fuel to 76000.

// calculates the pitch during ascent depending on the ships altitude
function pitchForAltitude {
  declare parameter alt.

  if ship:velocity:surface:mag < turn_start_velocity {
    return 90.
  } else {
    //return 90 * turn_pitch_base ^ (alt / 1000.0).
    return 104 - sqrt(80 * (alt / 1000.0 + 2.0)).
  }
}

// returns true as soon as the methane level drops under [booster_separation_fuel]
function readyForBoosterSep {
  return stage:LqdMethane < booster_separation_fuel.
}
