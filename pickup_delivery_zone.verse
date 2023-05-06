using { /Fortnite.com/Devices }
using { /Verse.org/Concurrency }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Random }

base_zone<public> := class:
    ActivatorDevice<public> : creative_object_interface #定数 キャプチャー エリアのデバイス or アイテム スポーナーのデバイス
    ZoneCompletedEvent<public> : event(base_zone) = event(base_zone){} #プレイヤーがこのゾーンとやりとりした時の通知イベント
    ZoneDeactivatedEvent<protected> : event() = event(){} #プレイヤーがゾーンを完了する前にゾーンが非アクティブ化された際、WaitForZoneCompleted() 関数を終了させる

    GetTransform<public>() :transform =
        ActivatorDevice.GetTransform()
    
    ActivateZone<public>() : void =
        Print("Zone activated")
        if (CaptureArea := capture_area_device[ActivatorDevice]): #キャプチャ―エリアなら
            CaptureArea.Enable()
            spawn {WaitForZoneCompleted(option{CaptureArea.AgentEntersEvent})} # 適切なデバイスイベントを渡す AgentEntersEvent
        
        else if (ItemSpawner := item_spawner_device[ActivatorDevice]): # アイテムスポーナーなら
            ItemSpawner.Enable()
            spawn { WaitForZoneCompleted(option{ItemSpawner.ItemPickedUpEvent})} # 適切なデバイスイベントを渡す ItemPickedUpEvent
        
    DeactivateZone<public>() : void =
        Print("Zone deactivated")
        if (CaptureArea := capture_area_device[ActivatorDevice]):
            CaptureArea.Disable()
        else if (ItemSpawner := item_spawner_device[ActivatorDevice]):
            ItemSpawner.Disable()
        ZoneDeactivatedEvent.Signal()
            

    WaitForZoneCompleted<private>(ZoneDeviceCompletionEventOpt : ?awaitable(agent))<suspends> : void =
        if (DeviceEvent := ZoneDeviceCompletionEventOpt?):
            #最初に終了しない式はキャンセルされる
            race: 
                block:
                    DeviceEvent.Await()
                    ZoneCompletedEvent.Signal(Self)

                
                ZoneDeactivatedEvent.Await()
                

# コンストラクタ
MakeBaseZone<constructor><public>(InActivatorDevice : creative_object_interface) := base_zone:
    ActivatorDevice := InActivatorDevice


tagged_zone_selector<public> := class:
    var Zones<protected> : []base_zone = array{}

    # タグを渡してZoneを初期化するメソッド
    InitZones<public>(ZoneTag : tag) : void =
        ZoneDevices := GetCreativeObjectsWithTag(ZoneTag)
        set Zones = for (ZoneDevice : ZoneDevices):
            MakeBaseZone(ZoneDevice)

    #別のゾーンを発見するか失敗を返す
    SelectNext<public>()<transacts><decides> : base_zone =
        Zones[GetRandomInt(0, Zones.Length - 1)]