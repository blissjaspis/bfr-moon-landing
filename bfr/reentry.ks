clearscreen.

function distance {
  declare parameter pos1, pos2.
  local dif to V(pos1:lat - pos2:lat, pos1:lng - pos2:lng, 0).
  return dif:mag.
}

global shipLandingPosition to latlng(28.608387575067, -80.6063059604572).

global reentryAltitude to 55000.0.
global maxPitch to 35.0.
global flipSpeed to 1800.0.
global landingSteeringAltitude to 32000.
global descentSpeed to -30.

wait until ship:altitude <= 130000.

rcs on.

set steer to heading(0, 0).
//lock steering to steer.
lock forward to lookdirup(velocity:surface, -ship:body:position).
lock normVec to vcrs(ship:body:position, ship:velocity:surface).
set pitch to 0.0.
lock steering to angleaxis(pitch, normVec) * forward.

wait until ship:altitude <= reentryAltitude.
print "Starting reentry now".
set pitch to 15.0.
wait until ship:verticalspeed >= (descentSpeed - 5).
print "Starting dynamic pitch now".
set pitch to 15.0.
wait 1.
clearscreen.

set vSpeed to ship:verticalspeed.
set vSpeedTime to time:seconds - 0.1.

set dis to 0.
lock dis to distance(addons:tr:impactpos, shipLandingPosition).

//until velocity:surface:mag <= flipSpeed {
until dis <= 0.06 {
  set vSpeedN to ship:verticalspeed.
  set vSpeedTimeN to time:seconds.

  set vAcc to (vSpeedN - vSpeed) / (vSpeedTimeN - vSpeedTime).
  print "Vertical accelaration is " + vAcc at (0, 0).
  set vSpeed to vSpeedN.
  set vSpeedTime to vSpeedTimeN.

  if (vSpeed <= descentSpeed) and (vAcc <= 0) {
    print "Increasing pitch to " + pitch at (0, 1).
    set pitch to pitch + 0.1.
  } else if (vSpeed >= descentSpeed) and (vAcc >= 0) {
    print "Decreasing pitch to " + pitch at (0, 1).
    set pitch to pitch - 0.1.
  }
  set pitch to min(35.0, pitch).

  wait 0.2.
}
wait 1.

unlock forward.
unlock normVec.
unlock steering.

lock steering to -velocity:surface.
until ship:altitude <= landingSteeringAltitude {
  set impactPos to addons:tr:impactpos.
  set dis to distance(impactPos, shipLandingPosition).
  print dis at (0, 5).
  wait 0.2.
}

copypath("0:/functions.ks", "").
copypath("0:/bfr/bfr_util.ks", "").
copypath("0:/bfr/landing.ks", "").
copypath("0:/bfr/ship_landing.ks", "").

run ship_landing.ks.
