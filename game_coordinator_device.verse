
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Vehicles }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Curves }
using { /Verse.org/Simulation/Tags }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# Game zones tags
pickup_zone_tag := class(tag) {}
pickup_zone_level_1_tag := class(pickup_zone_tag) {}
pickup_zone_level_2_tag := class(pickup_zone_tag) {}
pickup_zone_level_3_tag := class(pickup_zone_tag) {}
delivery_zone_tag := class(tag) {}



# A Verse-authored creative device that can be placed in a level
game_coordinator_device := class<concrete>(creative_device):
    DeliveryZoneSelector<private> : tagged_zone_selector = tagged_zone_selector{}
    var PickupZoneSelectors<private> : []tagged_zone_selector = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello, world!")
        Print("2 + 2 = {2 + 2}")

        SetupZones()

        var PickupLevel : int = 0

        loop:
            if (PickupZone : base_zone = PickupZoneSelectors[PickupLevel].SelectNext[]):
                Print("find pickupZone to select")
                PickupZone.ActivateZone()
                PickupZone.ZoneCompletedEvent.Await()
                PickupZone.DeactivateZone()

            else:
                Print("Cant find next pickupZone to select")
                return

            if (DeleveryZone := DeliveryZoneSelector.SelectNext[]):
                Print ("find next DeliveryZone to select")
                DeleveryZone.ActivateZone()
                DeleveryZone.ZoneCompletedEvent.Await()
                DeleveryZone.DeactivateZone()

            else:
                Print ("Cant find next DeliveryZone to select")
                return

    SetupZones<private>() : void =
        DeliveryZoneSelector.InitZones(delivery_zone_tag{})
        
        PickupZoneLevelTags : []pickup_zone_tag = array{pickup_zone_level_1_tag{}, pickup_zone_level_2_tag{}, pickup_zone_level_3_tag{}}

        set PickupZoneSelectors = for(PickupZoneTag :PickupZoneLevelTags):
            PickupZone := tagged_zone_selector{}
            PickupZone.InitZones(PickupZoneTag)
            PickupZone