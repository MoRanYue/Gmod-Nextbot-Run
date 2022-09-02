--nextbot config 
--nextbot设置

--what nextbot will spawn
--可能会生成的nextbot列表
NBR.nb.nextbot = {
    -- "npc_izeg1",
    -- "npc_izeg2",
    -- "npc_izeg3",
    -- "npc_kokomi",
    -- "npc_jiaohuang",
    -- "npc_powerboy"
}
--spawn point
--生成位置
--Set Nextbot spawn point for each map
--为每个地图设置nextbot重生点
--ATTENTION: It's optional now, if not found spawn position of current map, then the spawn position will be random player spawn point.
--注意：这现在是可选的，如果找不到当前地图的位置，将会使用任意的玩家出生点。
NBR.nb.spawnpos = {
    -- ["exampleMap"] = Vector(114514, 1918, 810),
    ["gm_construct"] = Vector(-78, -1112, -79),
    ["gm_mallparking"] = Vector(-13, 755, 192),
    ["gm_poolrooms"] = Vector(556, 861, 161),
    ["gm_backrooms"] = Vector(-5796, 6377, 64),
    ["gm_abstraction_extended"] = Vector(-3836, 176, -122)
}
--max nextbots
--nextbot可以生成的最大数量
NBR.nb.maxnpcs = 20
--practical max nextbots
--实际可以生成的nextbot最大值
NBR.nb.practical_maxnpcs = 200
--nextbot refresh interval ( Seconds )
--nextbot刷新时间（秒）
NBR.nb.refresh_nb_interval = 600

--general config
--一般设置

--what weapon for players when players spawned
--玩家生成后拥有的武器
NBR.general.start_loadout = {
    "weapon_crowbar",
    "weapon_parkour"
    -- "csgo_butterfly"
}
--can players vote nextbot and hope it will spawn more
--nextbot投票是否开启
NBR.general.vote_nb = false

--advance config
--高级设置

--Enable Void Console?
--使用虚空控制台
NBR.advance.enable_void_console = true