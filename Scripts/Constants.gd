extends Node

var server_port=25565
var max_players=4
var map_path
#Only four player models, so it will reuse them

var spawn_weapon=0
var spawn_powerUp=21

var round_time_sec=30
var betwen_round_sec=30

var point_deposit_score=500
var neutral_point_deposit_score=250
var star_pickup_score=200
var hohlyonok_kill_score=1000
var flag_per_sec_score=100
var boos_damage_score=100

var boss_speed=100
var boss_ab_reload=5

var pig_speed=0

var min_spawn_star=5
var max_star_spawn=10
var star_spawn_chance=100

var tank_speed=200

var bulet_speed=200
var bulet_reload=0.5

var rocket_speed=150

var artillery_speed=750

var plasma_ignition_time=1

var speedboost_time=10
var boost_power=2

var invincible_time=5

var spawn_invincible=3
var respawn_time=3


var min_crate_spawn=3600
var max_crate_spawn=3600
var crate_spawn_chance=100

var kill_score=100

var trap_time=5

var faz_agr_time=20
var faz_instakill_time=3
var faz_speed=100
var faz_lifetime=15

var x4ModeTime=10

var slower_time=7
var slower_power=0.5

var jet_time=10

var camuflage_time=6

var sprinkler_shoots=5
var sprinkler_delay=0.5

var RBG_shoots=20
var RBG_delay=0.2
var RBGminAmount=5
var RBGmaxAmount=20


func _load_config():
	if(FileAccess.file_exists("Config.json")):
		var conf={}
		var loader=FileAccess.open("Config.json", FileAccess.READ)
		conf=JSON.parse_string(loader.get_as_text())
		loader.close()
		for i in conf.keys():
			match i:
				"server_port":
					server_port=conf[i]
					pass
				"max_players":
					max_players=conf[i]
					pass
				"round_time_sec":
					round_time_sec=conf[i]
					pass
				"betwen_round_sec":
					betwen_round_sec=conf[i]
					pass
				"point_deposit_score":
					point_deposit_score=conf[i]
					pass
				"neutral_point_deposit_score":
					neutral_point_deposit_score=conf[i]
					pass
				"star_pickup_score":
					star_pickup_score=conf[i]
					pass
				"hohlyonok_kill_score":
					hohlyonok_kill_score=conf[i]
					pass
				"flag_per_sec_score":
					flag_per_sec_score=conf[i]
					pass
				"boos_damage_score":
					boos_damage_score=conf[i]
					pass
				"boss_speed":
					boss_speed=conf[i]
					pass
				"pig_speed":
					pig_speed=conf[i]
					pass
				"min_spawn_star":
					min_spawn_star=conf[i]
					pass
				"max_star_spawn":
					max_star_spawn=conf[i]
					pass
				"star_spawn_chance":
					star_spawn_chance=conf[i]
					pass
				"tank_speed":
					tank_speed=conf[i]
					pass
				"bulet_speed":
					bulet_speed=conf[i]
					pass
				"bulet_reload":
					bulet_reload=conf[i]
					pass
				"rocket_speed":
					rocket_speed=conf[i]
					pass
				"artillery_speed":
					artillery_speed=conf[i]
					pass
				"plasma_ignition_time":
					plasma_ignition_time=conf[i]
					pass
				"speedboost_time":
					speedboost_time=conf[i]
					pass
				"boost_power":
					boost_power=conf[i]
					pass
				"invincible_time":
					invincible_time=conf[i]
					pass
				"spawn_invincible":
					spawn_invincible=conf[i]
					pass
				"respawn_time":
					respawn_time=conf[i]
					pass
				"min_crate_spawn":
					min_crate_spawn=conf[i]
					pass
				"max_crate_spawn":
					max_crate_spawn=conf[i]
					pass
				"crate_spawn_chance":
					crate_spawn_chance=conf[i]
					pass
				"kill_score":
					kill_score=conf[i]
					pass
				"trap_time":
					trap_time=conf[i]
					pass
				"faz_agr_time":
					faz_agr_time=conf[i]
					pass
				"faz_instakill_time":
					faz_instakill_time=conf[i]
					pass
				"faz_speed":
					faz_speed=conf[i]
					pass
				"faz_lifetime":
					faz_lifetime=conf[i]
					pass
				"x4ModeTime":
					x4ModeTime=conf[i]
					pass
				"slower_time":
					slower_time=conf[i]
					pass
				"slower_power":
					slower_power=conf[i]
					pass
				"jet_time":
					jet_time=conf[i]
					pass
				"camuflage_time":
					camuflage_time=conf[i]
					pass
				"sprinkler_shoots":
					sprinkler_shoots=conf[i]
					pass
				"sprinkler_delay":
					sprinkler_delay=conf[i]
					pass
				"RBG_shoots":
					RBG_shoots=conf[i]
					pass
				"RBG_delay":
					RBG_delay=conf[i]
					pass
				"RBGminAmount":
					RBGminAmount=conf[i]
					pass
				"RBGmaxAmount":
					RBGmaxAmount=conf[i]
					pass
				"map_path":
					map_path=conf[i]
					pass
				"spawn_weapon":
					spawn_weapon=conf[i]
					pass
				"spawn_powerUp":
					spawn_powerUp=conf[i]
					pass
				"boss_ab_reload":
					boss_ab_reload=conf[i]
					pass
