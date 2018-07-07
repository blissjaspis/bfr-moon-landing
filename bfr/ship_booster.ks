run once ascent.
run once landing.

wait until stage:LqdMethane > 0.
set lz1 to ship:geoposition.
wait until readyForBoosterSep().

clearscreen.
// ~~~~~~~~~~~~~~ MECO and separation ~~~~~~~~~~~~~~~~~~~
wait 2.
run once bfr_util.
wait 1.
shutdownBooster().
unlock steering.
rcs on.
set ship:control:pitch to 1.0.
wait 8.0.
set ship:control:pitch to 0.0.
rcs off.

wait 4.
// wait 1.
set thrott to boostbackThrottle.
lock throttle to thrott.
set steer to boostbackSteering(ship:geoposition).
lock steering to steer.
wait 1.

// ~~~~~~~~~~~~~~ Boostback Burn start ~~~~~~~~~~~~~~~~~~~
activateCenterEngines().
activateInnerBoostEngines().
wait 1.
activateBoostEngines().
wait until distanceFromSteering() < 10.

until boostbackClose(lz1) {
  set steer to boostbackSteering(lz1).
  wait 0.05.
}
shutdownBoostEngines().
until boostbackComplete(lz1) {
  set steer to boostbackSteering(lz1).
}

shutdownBooster().

// ~~~~~~~~~~~~~~ Turn around and coast ~~~~~~~~~~~~~~~~~~~
lock steer to lookdirup(heading(270, 0):forevector, vcrs(V(0, 1, 0), ship:body:position)).
rcs on.
wait 8.
rcs off.
lock steer to -ship:velocity:surface.

brakes on.
limitGridFinAuthority(60.0).

coastAndTurn().
wait until ship:altitude <= reentryAltitude.

// ~~~~~~~~~~~~~~ Reentry Burn start ~~~~~~~~~~~~~~~~~~~
set thrott to reentryThrottle.
activateCenterEngines().
wait 1.
activateInnerBoostEngines().
until reentryBurnComplete() {
  set steer to reentryBurnSteering(lz1).
  wait 0.1.
}
shutdownBooster().


// ~~~~~~~~~~~~~~ Atmospheric descent ~~~~~~~~~~~~~~~~~~~
until ship:altitude < landingAltitude {
  set steer to atmosphericDescentSteering(lz1).
  wait 0.1.
}

// ~~~~~~~~~~~~~~ Landing burn start ~~~~~~~~~~~~~~~~~~~
lock height to ship:altitude - lz1alt.
set thrott to 0.1.

activateInnerBoostEngines().
activateCenterEngines().
wait 2.

set multiEngineBurn to true.

when abs(ship:verticalspeed) <= 110 then {
  shutdownInnerBoostEngines().
  set multiEngineBurn to false.

  when abs(ship:verticalspeed) <= 30 then {
    gear on.
  }
}

// until height < 1 or ship:verticalspeed >= -0.2 {
until height < 0 or ship:verticalspeed >= 0 {
  set steer to landingSteering(lz1, height).
  if multiEngineBurn {
    set thrott to landingThrottle(80, height, 1000, 0.2).
  } else {
    set thrott to defaultLandingThrottle(height, 0.2).
    //set thrott to landingThrottle(10, height, 30, 0.2).
  }
  wait 0.05.
}

shutdownBooster().
wait 1.
print ship:geoposition at (0, 0).
