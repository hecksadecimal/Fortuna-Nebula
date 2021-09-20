//Pahrump access defines

#define ACCESS_REGION_NCR 1
#define ACCESS_REGION_LEGION 2
#define ACCESS_REGION_BROTHERHOOD 3
#define ACCESS_REGION_FOLLOWERS 4
#define ACCESS_REGION_OASIS 5
#define ACCESS_REGION_DEN 6
#define ACCESS_REGION_KHANS 7

//NCR Access Defines
var/global/const/access_ncr_general = "ACCESS_NCR_GENERAL"
/datum/access/ncrgeneral
	id = access_ncr_general
	desc = "NCR General Access"
	region = ACCESS_REGION_NCR

var/global/const/access_ncr_armory = "ACCESS_NCR_ARMORY"
/datum/access/ncrarmory
	id = access_ncr_armory
	desc = "NCR Armory Access"
	region = ACCESS_REGION_NCR

var/global/const/access_ncr_command = "ACCESS_NCR_COMMAND"
/datum/access/ncrcommand
	id = access_ncr_command
	desc = "NCR Command Access"
	region = ACCESS_REGION_NCR

var/global/const/access_ncr_vip = "ACCESS_NCR_VIP"
/datum/access/ncrvip
	id = access_ncr_vip
	desc = "NCR VIP Access"
	region = ACCESS_REGION_NCR

//Legion
var/global/const/access_legion_general = "ACCESS_LEGION_GENERAL"
/datum/access/legiongeneral
	id = access_legion_general
	desc = "Legion General Access"
	region = ACCESS_REGION_LEGION

var/global/const/access_legion_armory = "ACCESS_LEGION_ARMORY"
/datum/access/legionarmory
	id = access_legion_armory
	desc = "Legion Armory Access"
	region = ACCESS_REGION_LEGION

var/global/const/access_legion_command = "ACCESS_LEGION_COMMAND"
/datum/access/legioncommand
	id = access_legion_command
	desc = "Legion Command Access"
	region = ACCESS_REGION_LEGION

//Brotherhood
var/global/const/access_brotherhood_general = "ACCESS_BROTHERHOOD_GENERAL"
/datum/access/brotherhoodgeneral
	id = access_brotherhood_general
	desc = "Brotherhood General Access"
	region = ACCESS_REGION_BROTHERHOOD

var/global/const/access_brotherhood_armory = "ACCESS_BROTHERHOOD_ARMORY"
/datum/access/brotherhoodarmory
	id = access_brotherhood_armory
	desc = "Brotherhood Armory Access"
	region = ACCESS_REGION_BROTHERHOOD

var/global/const/access_brotherhood_command = "ACCESS_BROTHERHOOD_COMMAND"
/datum/access/brotherhoodcommand
	id = access_brotherhood_command
	desc = "Brotherhood Command Access"
	region = ACCESS_REGION_BROTHERHOOD

//Followers
var/global/const/access_followers_general = "ACCESS_FOLLOWERS_GENERAL"
/datum/access/followersgeneral
	id = access_followers_general
	desc = "Followers General Access"
	region = ACCESS_REGION_FOLLOWERS

var/global/const/access_followers_command = "ACCESS_FOLLOWERS_COMMAND"
/datum/access/followerscommand
	id = access_followers_command
	desc = "Followers Command Access"
	region = ACCESS_REGION_FOLLOWERS

//Oasis
var/global/const/access_oasis_general = "ACCESS_OASIS_GENERAL"
/datum/access/oasisgeneral
	id = access_oasis_general
	desc = "Oasis General Access"
	region = ACCESS_REGION_OASIS

var/global/const/access_oasis_mayor = "ACCESS_OASIS_MAYOR"
/datum/access/oasismayor
	id = access_oasis_mayor
	desc = "Mayor Access"
	region = ACCESS_REGION_OASIS

var/global/const/access_oasis_deputy = "ACCESS_OASIS_DEPUTY"
/datum/access/oasisdeputy
	id = access_oasis_deputy
	desc = "Deputy Access"
	region = ACCESS_REGION_OASIS

var/global/const/access_oasis_shopkeep = "ACCESS_OASIS_SHOPKEEP"
/datum/access/oasisshopkeep
	id = access_oasis_shopkeep
	desc = "Shopkeep Access"
	region = ACCESS_REGION_OASIS

var/global/const/access_oasis_barkeep = "ACCESS_OASIS_BARKEEP"
/datum/access/oasisbarkeep
	id = access_oasis_barkeep
	desc = "Barkeep Access"
	region = ACCESS_REGION_OASIS

//Den
var/global/const/access_den_general = "ACCESS_DEN_GENERAL"
/datum/access/dengeneral
	id = access_den_general
	desc = "Den General Access"
	region = ACCESS_REGION_DEN

//Khans
var/global/const/access_khans_general = "ACCESS_KHANS_GENERAL"
/datum/access/khansgeneral
	id = access_khans_general
	desc = "Khans General Access"
	region = ACCESS_REGION_KHANS