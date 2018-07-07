run once ascent.
run once bfr_util.

// ~~~~~~~~~~~~~~~~~ Startup ~~~~~~~~~~~~~~~~
clearscreen.
print "Init".
limitGridFinAuthority(0).
set thrott to 1.0.
lock throttle to thrott.
wait 5.

// ~~~~~~~~~~~~~~~~~ Ignition ~~~~~~~~~~~~~~~~~~~
controlFromBooster().
stage.
wait 5.
set pitch to 90.
lock steering to heading(90, pitch).

// ~~~~~~~~~~~~~~~~~ Liftoff ~~~~~~~~~~~~~~~~
stage.
until readyForBoosterSep() {
  //ascent until booster separation
  set pitch to pitchForAltitude(ship:altitude).
  wait 0.2.
}

// ~~~~~~~~~~~~~~~~~ Booster Separation ~~~~~~~~~~~~~~~~~~~~~~

shutdownBooster().
set thrott to 0.
wait 1.
unlock steering.
stage.
rcs on.
set ship:control:fore to 1.0.

// wait for the second stage to move away from the center core
wait 1.
//set thrott to 0.5.
lock steering to heading(90, 25).
wait 2.

set ship:control:fore to 0.0.
set thrott to 1.0.

wait 10.
