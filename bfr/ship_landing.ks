run landing.
clearscreen.

wait 1.0.

// global shipLandingPosition to latlng(28.6084095848539, -80.596476358078).
// global shipLandingAlt to 106.
global shipLandingPosition to latlng(28.608387575067, -80.6063059604572).
global shipLandingAlt to 203.5.

global landingBurnAltitude to 5000.

print "Starting".
rcs on.

set thrott to 0.0.
lock throttle to thrott.
set steer to atmosphericDescentSteering(shipLandingPosition).
lock steering to steer.


until ship:altitude <= landingBurnAltitude {
  set steer to atmosphericDescentSteering(shipLandingPosition).
  wait 0.05.
}

lock height to ship:altitude - shipLandingAlt.

set thrott to 0.1.
wait 2.
when abs(ship:verticalspeed) <= 50 then {
  gear on.
}


//until ship:altitude <= shipLandingAlt {
until ship:verticalspeed >= -0.1 {
  set steer to landingSteering(shipLandingPosition, height).
  set thrott to defaultLandingThrottle(height, 0.2).
  wait 0.05.
}

set thrott to 0.0.

wait 1.
