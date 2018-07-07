function posToLatLng {
  declare parameter t_pos.

  // calculate latitude and longitude with the standard formulas
  local lat to arccos(t_pos:y / r) - 90.0.
  local lng to calcLng(t_pos).

  // correct the longitude since it can't be calculated directly from the position
  local correction to ship:geoposition:lng - calcLng(pos).
  local lng to limitLng(lng + correction).

  return LatLng(lat, lng).
}

function calcLng {
  declare parameter t_pos.

  // wikipedia says this works...
  if (t_pos:x > 0) {
    return arctan(t_pos:z / t_pos:x).
  } else if (t_pos:x = 0) {
    return sgn(t_pos:z) * 90.
  } else if (t_pos:z >= 0) {
    return arctan(t_pos:z / t_pos:x) + 180.
  } else if (t_pos:z < 0) {
    return arctan(t_pos:z / t_pos:x) - 180.
  }
}

function limitLng {
  declare parameter lng.

  // force the longitude between -180 and 180
  if lng > 180 {
    return lng - 360.
  } else if lng < 180 {
    return lng + 360.
  } else {
    return lng.
  }
}

function sgn {
  declare parameter p.
  if p = 0 {
    return 0.0.
  }
  return p / abs(p).
}
