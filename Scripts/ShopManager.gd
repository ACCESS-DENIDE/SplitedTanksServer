extends Node
var rng=RandomNumberGenerator.new()

@onready var Server = $".."
@onready var player_manager = $"../PlayerManager"

var deals={}


func _buy(peer_id, num):
	if(player_manager.players_links[peer_id]["Score"]>=deals.keys()[num]):
		player_manager.players_links[peer_id]["Score"]-=deals.keys()[num]
		Server.PlayerManager._update_scores()
		
		match deals.values()[num]:
			"Shield":
				player_manager.players_links[peer_id]["Inst"]._add_item(18)
				pass
			"Boost":
				player_manager.players_links[peer_id]["Inst"]._add_item(19)
				pass
			"Mine":
				player_manager.players_links[peer_id]["Inst"]._add_item(20)
				pass
			"SuperCharge":
				player_manager.players_links[peer_id]["Inst"]._add_item(21)
				pass
			"Bulet":
				player_manager.players_links[peer_id]["GT"]=0
				pass
			"Rocket":
				player_manager.players_links[peer_id]["GT"]=1
				pass
			"Plasma":
				player_manager.players_links[peer_id]["GT"]=2
				pass
			"Mortir":
				player_manager.players_links[peer_id]["GT"]=3
				pass
			"RandomBlock":
				randomize()
				player_manager.players_links[peer_id]["Blocks"][player_manager.players_links[peer_id]["Blocks"].keys()[rng.randi_range(0, 4)]]+=1
				pass
			"Sprinkler":
				player_manager.players_links[peer_id]["Inst"]._add_item(32)
				pass
			"TankTrap":
				player_manager.players_links[peer_id]["Inst"]._add_item(33)
				pass
			"Portal":
				player_manager.players_links[peer_id]["Inst"]._add_item(34)
				pass
			"Invisible":
				player_manager.players_links[peer_id]["Inst"]._add_item(35)
				pass
			"Nou":
				player_manager.players_links[peer_id]["Inst"]._add_item(36)
				pass
			"Jetpack":
				player_manager.players_links[peer_id]["Inst"]._add_item(37)
				pass
			"ScoreSucker":
				player_manager.players_links[peer_id]["Inst"]._add_item(38)
				pass
			"Slower":
				player_manager.players_links[peer_id]["Inst"]._add_item(39)
				pass
			"4X":
				player_manager.players_links[peer_id]["Inst"]._add_item(40)
				pass
			"RandomBullShit":
				player_manager.players_links[peer_id]["Inst"]._add_item(41)
				pass
			"Angry Beers":
				player_manager.players_links[peer_id]["Inst"]._add_item(42)
				pass
			"Fortnite":
				player_manager.players_links[peer_id]["Inst"]._add_item(43)
				pass
		deals.erase(deals.keys()[num])
		_updateDeals()
		Server._update_locals_of_peer(peer_id, { "Blocks":Server.PlayerManager.players_links[peer_id]["Blocks"]})
	pass

func _updateDeals():
	var outp={}
	while(deals.size()<3):
		match randi_range(0, 20):
			0:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Shield"
				pass
			1:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Boost"
				pass
			2:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Mine"
				pass
			3:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="SuperCharge"
				pass
			4:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Bulet"
				pass
			5:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Rocket"
				pass
			6:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Plasma"
				pass
			7:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Mortir"
				pass
			8:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="RandomBlock"
				pass
			9:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Sprinkler"
				pass
			10:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="TankTrap"
				pass
			11:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Portal"
				pass
			12:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Invisible"
				pass
			13:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="NoU"
				pass
			14:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Jetpack"
				pass
			15:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="ScoreSucker"
				pass
			16:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Slower"
				pass
			17:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="4X"
				pass
			18:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="RandomBullShit"
				pass
			19:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Angry Beers"
				pass
			20:
				randomize()
				var price=rng.randi_range(200,400)
				outp[price]="Fortnite"
				pass
		deals.merge(outp)
	if(deals.size()>3):
		for i in range(3, deals.size()-1):
			deals.erase(deals.keys()[3])
			
	for i in player_manager.players_links.keys():
		Server._update_locals_of_peer(i, {"ShopDeals":deals})
