resource "azuread_named_location" "blocked_countries" {
  display_name = "Blocked Countries"
  country {
    countries_and_regions                 = jsondecode(file("${path.module}/assets/blocked_countries.json"))
    include_unknown_countries_and_regions = false
  }
}

resource "azuread_named_location" "blocked_locations" {
  display_name = "Blocked Locations"
  ip {
    ip_ranges = jsondecode(file("${path.module}/assets/blocked_locations.json"))
  }
}

resource "azuread_named_location" "controlplane_access" {
  display_name = "Control plane access locations"
  ip {
    ip_ranges = []
  }
}

resource "azuread_named_location" "managementplane_access" {
  display_name = "Management plane access locations"
  ip {
    ip_ranges = []
  }
}
