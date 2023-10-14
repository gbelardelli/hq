#extends Object

#class_name HQSOLO


class_name Heroquest_solo

var _total_number_of_turns:int = randi_range(7, 12)
var _max_room_counter:int = randi_range(5, 10)
var _current_room_counter:int = 0
var _mission_percent_made:int = 0
var _escape_found:int = 0
var _first_room:int = 0
var _new_data_to_test_delete:int = 0

#	var fornitures_qty_dict:Dictionary = {1:db_fornitures_charged[0][2],
#		2:db_fornitures_charged[1][2],
#		3:db_fornitures_charged[2][2],
#		4:db_fornitures_charged[3][2],
#		5:db_fornitures_charged[4][2],
#		6:db_fornitures_charged[5][2],
#		7:db_fornitures_charged[6][2],
#		8:db_fornitures_charged[7][2],
#		9:db_fornitures_charged[8][2],
#		10:db_fornitures_charged[9][2],
#		11:db_fornitures_charged[10][2],
#		12:db_fornitures_charged[11][2],
#		13:db_fornitures_charged[12][2]}
#
#	var monsters_qty_dict:Dictionary = {1:db_monsters_charged[0][2],
#						 2:db_monsters_charged[1][2],
#						 3:db_monsters_charged[2][2],
#						 4:db_monsters_charged[3][2],
#						 5:db_monsters_charged[4][2],
#						 6:db_monsters_charged[5][2],
#						 7:db_monsters_charged[6][2],
#						 8:db_monsters_charged[7][2],
#						 9:db_monsters_charged[8][2]}
#
#	var monsters_combat_values_dict:Dictionary = {1:db_monsters_charged[0][4],
#								   2:db_monsters_charged[1][4],
#								   3:db_monsters_charged[2][4],
#								   4:db_monsters_charged[3][4],
#								   5:db_monsters_charged[4][4],
#								   6:db_monsters_charged[5][4],
#								   7:db_monsters_charged[6][4],
#								   8:db_monsters_charged[8][4],
#								   9:db_monsters_charged[7][4]}
#
#	var monsters_category:Dictionary = {1:db_monsters_charged[0][1],
#						 2:db_monsters_charged[1][1],
#						 3:db_monsters_charged[2][1],
#						 4:db_monsters_charged[3][1],
#						 5:db_monsters_charged[4][1],
#						 6:db_monsters_charged[5][1],
#						 7:db_monsters_charged[6][1],
#						 8:db_monsters_charged[7][1],
#						 9:db_monsters_charged[8][1]
#						 }

var _the_mission:int = 0
var _special_room_charged:Dictionary = {}
var _monster_class:String = ""
var _config_dict:Dictionary = {}
var _position_dict:Dictionary = {}
var _forniture_dict:Dictionary = {}
var _treasures_card_dict:Dictionary = {}
var _monsters_dict:Dictionary = {}

func _init(cd:Dictionary):
	self.config_dict = cd

	#position dict
	#self.position_dict = self.config_dict['positions']

	#fornitures dict
	self.forniture_dict = GlobalUtils.load_furnitures("heroquest")

	#treasures dict that you can find inside a cest or in other forniture
	#self.treasures_card_dict =  self.config_dict['cards']

	#monsters dict that you can find inside a Room or in a aisle
	#self.monsters_dict = self.config_dict['monsters_dict']

func special_data_mission_charged(mission:int):
	self.the_mission = mission
	self.special_room_charged = self.config_dict['specials_rooms'][self.the_mission]
	self.monster_class = self.config_dict['monster_class'][self.the_mission]

	#remove_forniture_for_special_room
	for i in self.SPECIAL_ROOM_CHARGED[0]:
		self.FORNITURES_QTY_DICT[i]-=1
