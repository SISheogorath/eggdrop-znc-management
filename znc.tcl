###############################################################################
### Preconfiguration please don't change...
### Script Logic ## Handle with care!
###############################################################################
set scriptname "Shivering-Isles ZNC managment script"
set scriptOwner "Christoph Kern"
set scriptOwnerMail "Sheogorath@shivering-isles.de" 
set scriptchannel "#ZNC"
set scriptOwnerNetwork "irc.shivering-isles.de"
set scriptversion "0.7.0.1"
set scriptdebug 0

putlog "$scriptname loading configuration..."

###############################################################################
### End of Preconfig
###############################################################################


###############################################################################
### Start of config
###############################################################################


### Script --------------------------------------------------------------------
# Script specific settings
# 
# 
###----------------------------------------------------------------------------

## set to 0 to minimize script putlog part
set scriptUseBigHeader 1

## Advertice ScriptOwner
set adverticeScriptOwner 0

## Prefix for triggering Bot Commands things like !request or .request
set scriptCommandPrefix "!"

### ZNC -----------------------------------------------------------------------
# Here you can configure your whole ZNC settings
#
# 
###----------------------------------------------------------------------------

## ZNC Network name
set zncnetworkname "Shivering-Isles ZNC"

## The prefix set for Modules for Bot's ZNC-User
set zncprefix "*"

## The DNS-Host of your ZNC Server
set znchost "znc.shivering-isles.de"

## The ZNC NON-SSL Port, if not exists set ""
set zncNonSSLPort "65534"

## The ZNC SSL Port, if not exists set ""
set zncSSLPort "65535"

## The ZNC-Webinterface NON-SSL Port, if not exists set ""
set zncWebNonSSLPort "65534"

## The ZNC-Webinterface SSL Port, if not exists set ""
set zncWebSSLPort "65535"

## The Name of server support/admin
set zncAdminName "Sheogorath"

## The E-Mail address of server support/admin
set zncAdminMail "znc@shivering-isles.de"

## The Level of Security for the random generated password for new ZNC-users (recommanded is 3 means [a-zA-Z0-9])
set zncPasswordSecurityLevel 3

## The Length of the automatic generated password)
set zncPasswordLength 16

### Optional - Preconfiguration -----------------------------------------------
# Default Modules and Networks
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Default User Modules loaded, if not exists set { } if you use arguments do it like that: "autoreply \"I'll be back soon\""
#set defaultUserModules { "chansaver" "controlpanel" "buffextras" "autoreply \"I'll be back soon\""}
set zncDefaultUserModules {  }

## Default User Modules loaded, if not exists set { } if you use arguments do it like that: "autoreply \"I'll be back soon\""
#set defaultUserModules { "chansaver" "controlpanel" "buffextras" "autoreply \"I'll be back soon\""}
set zncDefaultNetworkModules {  }

### Preconfigured Networks
## Enable Preconfigured Networks
set usePreconfiguredNetworks 1

## Array of Preconfigured Networks (only works if usePreconfiguredNetworks is set to 1 )
array set knownNetworks {
	shivering-isles "irc.shivering-isles.de +6697"
	freenode 		"irc.freenode.net +7000"
	euircnet		"irc.euirc.net +6697"
}

## Forces to 1 Network  !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
#set zncEnforcedNetwork "irc.shivering-isles.de +6697"
set zncEnforcedNetwork ""


### Optional - Topic Settings -------------------------------------------------
# Topic Settings
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Change Topic 1 means on 0 means off
set zncTopic 0

## Show Number of ZNC users in Topic
set zncTopicUsercount 1

## Show Serverdata in Topic
set zncTopicServerdata 1

## Show Name of server support/admin
set zncTopicShowAdmin 1

## Topicprefix
set zncTopicPrefix ""

## GreetSuffix
set zncTopicSuffix ""


### Optional - Greeting Settings ----------------------------------------------
# Settings for Greeting 
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Show Greeting 1 means on 0 means off
set zncGreeting 0

## Greet prefix (possible values for replace: %nick% %channel%)
set zncGreetPrefix "\00300,01"

## Greet suffix (possible values for replace: %nick% %channel%)
set zncGreetSuffix "\003"

## Greet Messages (possible values for replace: %nick% %channel% %zncAdminName% %zncAdminMail% %zncNonSSLPort% %zncSSLPort% %zncWebSSLPort% %zncWebNonSSLPort% %znchost%)
set zncGreetings {
	"Hello %nick%, stay here or manage you ZNC Account via https://%znchost%:%zncWebSSLPort%!"
	"Hello %nick%, welcome to %channel%!"
	"Welcome %nick%, %channel% is for ZNC management. To request a ZNC-Account use !help request"
	}


### Optional - Advertice ------------------------------------------------------
# Settings for advertice your network
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Do Advertice 1 means on 0 means off (if 0 scriptAdvertice is off, too)
set zncAdvertice 0

## Show Number of ZNC users in Advertice
set zncAdverticeUsercount 1

## Show Serverdata in Topic
set zncAdverticeServerdata 1

## Show Name of server support/admin
set zncAdverticeShowAdmin 1

## Sentences for Advertice
#set zncAdverticeSenteces { } #disabled
set zncAdverticeSenteces { 
	"Get your Free ZNC now!" 
	""}


###############################################################################
### End of Config
###############################################################################

###############################################################################
### Script Logic ## Handle with care! (If you change 1 character my support ends)
###############################################################################
putlog "$scriptname configuration loaded"
putlog "$scriptname loading script..."

if { $scriptUseBigHeader } {
	putlog "$scriptname is wirtten by $scriptOwner"
	putlog "If you need help join irc://$scriptOwnerNetwork/$scriptchannel"
	putlog "If you can't join or want to contact me inanother way, you can E-Mail to $scriptOwnerMail"
	putlog "Enjoin your work with $scriptname"
}

if { $scriptdebug } {
	putlog "!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!"
	putlog "RUNNING SCRIPT IN DEBUG MODE! DO NOT RUN PRODUCTIVE!"
}

### Bot Commands --------------------------------------------------------------

proc znc:request { nick host handle chan text } {
	global scriptCommandPrefix zncPasswordSecurityLevel zncPasswordLength zncnetworkname zncDefaultUserModules zncDefaultNetworkModules
	set username [lindex $text 0]
	if { $username == ""} { 
		puthelp "NOTICE $nick :${scriptCommandPrefix}request syntax is \"${scriptCommandPrefix}request <zncusername>\" for more please use \"${scriptCommandPrefix}help request\""
		return
	} else {
		set password [znc:helpfunction:generatePassword  $zncPasswordSecurityLevel $zncPasswordLength ]
		if [ adduser $username ] {
			setuser $username COMMENT $nick
			chattr $username +ZC
			znc:controlpanel:AddUser $username $password 
			znc:blockuser:block $username 
			puthelp "NOTICE $nick :Hey $nick, your request for $username is noticed and after confirm by an administrator you'll get an IRC Message with all needed data."
		} else {
			puthelp "NOTICE $nick :Sry, but your wanted username is already in use... :/"
		}
	}
}

proc znc:confirm {nick host handle chan text} {
	global scriptCommandPrefix zncPasswordSecurityLevel zncPasswordLength
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}Confirm syntax is \"${scriptCommandPrefix}Confirm <zncusername>\" for more please use \"${scriptCommandPrefix}help Confirm"
	}
	if [ matchattr $username C] {
		set password [znc:helpfunction:generatePassword $zncPasswordSecurityLevel $zncPasswordLength ]
		znc:controlpanel:Set "password" $username $password 
		msg:simply:sendUserRequest $username $password
		
		znc:blockuser:unblock $username 
		chattr $username -C
		puthelp "NOTICE $nick :$username is now confirmed."
	} elseif [ validuser $username ] {
		puthelp "NOTICE $nick :$username is already confirmed."
	} else {
		puthelp "NOTICE $nick :$username does not exist"
	}
}

proc znc:status {nick host handle chan text} {
	global scriptCommandPrefix zncPasswordSecurityLevel zncPasswordLength
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}status syntax is \"${scriptCommandPrefix}status <zncusername>\" for more please use \"${scriptCommandPrefix}help status"
	}
	if [ matchattr $username C] {
		puthelp "NOTICE $nick :Confirmation for $username is still pending."
	} elseif [ validuser $username ] {
		puthelp "NOTICE $nick :$username is confirmed."
	} else {
		puthelp "NOTICE $nick :$username does not exist."
	}
}

proc znc:deny {nick host handle chan text} {
	global scriptCommandPrefix
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}Deny syntax is \"${scriptCommandPrefix}Deny <zncusername>\" for more please use \"${scriptCommandPrefix}help Deny"
	}
	if [ matchattr $username C ] {
		znc:controlpanel:DelUser $username 
		deluser $username
		puthelp "NOTICE $nick :$username is now denied."
	} elseif [ validuser $username ] {
		puthelp "NOTICE $nick :$username is already confirmed. Use \"${scriptCommandPrefix}DelUser <username>\" to remove"
	} else {
		puthelp "NOTICE $nick :$username does not exist"
	}
}

proc znc:delUser {nick host handle chan text} {
	global scriptCommandPrefix
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}DelUser syntax is \"${scriptCommandPrefix}DelUser <zncusername>\" for more please use \"${scriptCommandPrefix}help DelUser"
	}
	if [ validuser $username ] {
		znc:controlpanel:DelUser $username 
		deluser $username
		puthelp "NOTICE $nick :$username is now deleted."
	} else {
		puthelp "NOTICE $nick :$username does not exist"
	}
}

proc znc:listUnconfirmed {nick host handle chan text} {
	global scriptCommandPrefix
	set UnConfirmedList [join [ userlist C ] ,]
	if { $UnConfirmedList != "" } {
		puthelp "NOTICE $nick :Unconfirmed users: $UnConfirmedList"
	} else {
		puthelp "NOTICE $nick :no unconfirmed users"
	}
}

proc znc:listall {nick host handle chan text} {
	global scriptCommandPrefix
	set UnConfirmedList [join [ userlist Z ] ,]
	if { $UnConfirmedList != "" } {
		puthelp "NOTICE $nick :Existing users: $UnConfirmedList"
	} else {
		puthelp "NOTICE $nick :no existing users O.o"
	}
}

proc znc:help {nick host handle chan text} {
	global scriptCommandPrefix zncAdminName scriptname botnick
	set helpcontext [lindex $text 0]
	if { $helpcontext != "" } {
		switch [string tolower $helpcontext] {
			request {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Request"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Request you can request an ZNC-Account that Account"
				puthelp "NOTICE $nick :#is just waiting for a confirm or deny by $zncAdminName. If it is confirmed you'll"
				puthelp "NOTICE $nick :#get an IRC MEssage with address and password for your account."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#If you want to get the current state of confimation you can use ${scriptCommandPrefix}Status command."
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}request <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}request Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick request <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick request Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			status {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Status"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Status you can check confirmation state of your ZNC Account request."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Status <zncusername>"
					puthelp "NOTICE $nick :#Example:"
				puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Status Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#  /msg $botnick Status <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick Status Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			info {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Info"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Info displays znc informations."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}info"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#  /msg $botnick info"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			listunconfirmedusers {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}ListUnconfirmedUsers"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}ListUnconfirmedUsers $zncAdminName gets a list of unconfirmed"
				puthelp "NOTICE $nick :#users."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}ListUnconfirmedUsers"
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}ListUnconfirmedUsers"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick ListUnconfirmedUsers"
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick ListUnconfirmedUsers"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			listallusers {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}ListAllUsers"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}ListAllUsers $zncAdminName gets a list of ZNC users."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}ListAllUsers"
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}ListAllUsers"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick ListAllUsers"
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick ListAllUsers"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			list {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}list"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#${scriptCommandPrefix}list is an alias of ${scriptCommandPrefix}ListAllUsers and ${scriptCommandPrefix}ListUnconfirmedUsers"
				puthelp "NOTICE $nick :#You can use \"${scriptCommandPrefix}list members\" for ${scriptCommandPrefix}ListAllUsers"
				puthelp "NOTICE $nick :#and \"${scriptCommandPrefix}list pending\" for ${scriptCommandPrefix}ListUnconfirmedUsers"
				puthelp "NOTICE $nick :### End of Help ###"
			}
			confirm {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Confirm"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Confirm $zncAdminName can confirm ZNC Account requests."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Confirm <zncusername>"
					puthelp "NOTICE $nick :#Example:"
				puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Confirm Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#  /msg $botnick Confirm <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick Confirm Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			deny {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Deny"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Deny $zncAdminName can deny ZNC Account requests."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Deny <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Deny Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick Deny <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick Deny Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			deluser {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}DelUser"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}DelUser $zncAdminName can delete ZNC Accounts if they are"
				puthelp "NOTICE $nick :#already confirmed."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}DelUser <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}DelUser Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick DelUser <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick DelUser Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			help {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}help"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}help you'll get messages like this one..."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help \[<command>\]"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help request"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick help \[<command>\]"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick help request"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			default {
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#please use ${scriptCommandPrefix}help without parameters for full command list"
				} else {
					puthelp "NOTICE $nick :#please use /msg $botnick help without parameters for full command list"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
		}
	} else {
		puthelp "NOTICE $nick :#$scriptname Command list:"
		puthelp "NOTICE $nick :#request    	            |Requests an ZNC Account"
		puthelp "NOTICE $nick :#status    	            |Shows confirmation state of a ZNC Account"
		puthelp "NOTICE $nick :#info    	            |Shows znc informations"
		puthelp "NOTICE $nick :Admin-only commands:"
		puthelp "NOTICE $nick :#list    	            |Aliases for ListAllUsers and ListUnconfirmedUsers"
		puthelp "NOTICE $nick :#ListAllUsers            |Lists all ZNC Accounts"
		puthelp "NOTICE $nick :#ListUnconfirmedUsers    |Lists unconfirmed ZNC Accounts"
		puthelp "NOTICE $nick :#Confirm                 |Confirms ZNC Account request"
		puthelp "NOTICE $nick :#Deny                    |Denies a ZNC Account request"
		puthelp "NOTICE $nick :#DelUser                 |Deletes a confirmed ZNC Account"
		puthelp "NOTICE $nick :#help                    |Shows help for commands"
		puthelp "NOTICE $nick :# "
		puthelp "NOTICE $nick :#Use \"${scriptCommandPrefix}help <command>\" for full helpcontext."
		puthelp "NOTICE $nick :# "
		puthelp "NOTICE $nick :#-----------------"
		if { $chan != $nick } {
			puthelp "NOTICE $nick :#Syntax:"
			puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help \[<command>\]"
			puthelp "NOTICE $nick :#Example:"
			puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help request"
		} else {
			puthelp "NOTICE $nick :#Syntax:"
			puthelp "NOTICE $nick :#   /msg $botnick help \[<command>\]"
			puthelp "NOTICE $nick :#Example:"
			puthelp "NOTICE $nick :#   /msg $botnick help request"
		}
		puthelp "NOTICE $nick :### End of Help ###"
	}
}

proc znc:zncinfo {nick host handle chan text} {
	global scriptCommandPrefix zncAdminName scriptname botnick zncnetworkname znchost zncNonSSLPort zncSSLPort zncWebNonSSLPort zncWebSSLPort zncAdminName zncAdminMail 
	puthelp "NOTICE $nick :Here are our ZNC information:"
	puthelp "NOTICE $nick :Our ZNChost is: $znchost"
	if { $zncNonSSLPort != "" } {
		puthelp "NOTICE $nick :To connect your IRC Client via NON-SSL connect to: ${znchost}:${zncNonSSLPort}"
	}
	if { $zncSSLPort != "" } {
		puthelp "NOTICE $nick :To connect your IRC Client via SSL connect to: ${znchost}:${zncSSLPort}"
	}
	puthelp "NOTICE $nick :Your ZNC Username is: $username"
	puthelp "NOTICE $nick :Your ZNC Password is: $password"
	puthelp "NOTICE $nick :To Connect to ZNC-Server use \"username/networkname:password\" as server-password"
	if { $zncWebNonSSLPort != "" } {
		puthelp "NOTICE $nick :To login via NON-SSL-Webinterface goto: http://${znchost}:${zncWebNonSSLPort}"
	}
	if { $zncWebSSLPort != "" } {
		puthelp "NOTICE $nick :To login via SSL-Webinterface goto: https://${znchost}:${zncWebSSLPort}"
	}
	puthelp "NOTICE $nick :### End of information ###"
}

### ZNC - Functions -----------------------------------------------------------

proc znc:controlpanel:AddNetwork { username network } {
	znc:sendTo:Controlpanel "AddNetwork $username $network"
}

proc znc:controlpanel:AddServer { username network server } {
	znc:sendTo:Controlpanel "AddServer $username $network $server "
}

proc znc:controlpanel:AddUser { username password } {
	znc:sendTo:Controlpanel "AddUser $username $password"
}

proc znc:controlpanel:DelNetwork { username network } {
	znc:sendTo:Controlpanel "DelNetwork $username $network"
}

proc znc:controlpanel:DelUser { username } {
	znc:sendTo:Controlpanel "DelUser $username"
}

proc znc:controlpanel:Disconnect { username network } {
	znc:sendTo:Controlpanel "Disconnect $username $network"
}

proc znc:controlpanel:LoadModule { username modulename {args ""} } {
	if { $args == ""} {
		znc:sendTo:Controlpanel "LoadModule $username $modulename"
	} else {
		znc:sendTo:Controlpanel "LoadModule $username $modulename $args"
	}
}

proc znc:controlpanel:LoadNetModule { username network modulename {args ""} } {
	if { $args == ""} {
		znc:sendTo:Controlpanel "LoadNetModule $username $network $modulename"
	} else {
		znc:sendTo:Controlpanel "LoadNetModule $username $network $modulename $args"
	}
}

proc znc:controlpanel:Reconnect { username network } {
		znc:sendTo:Controlpanel "Reconnect $username $network"
}

proc znc:controlpanel:Set { variable username value } {
	znc:sendTo:Controlpanel "Set $variable $username $value"
}

proc znc:controlpanel:SetChan { variable username network chan value } {
	znc:sendTo:Controlpanel "SetChan $variable $username $network $chan $value"
}

proc znc:controlpanel:SetNetwork { variable username network value } {
	znc:sendTo:Controlpanel "SetNetwork $variable $username $network $value"
}

proc znc:blockuser:block { username } {
	znc:sendTo:blockuser "block $username"
}

proc znc:blockuser:unblock { username } {
	znc:sendTo:blockuser "unblock $username"
}


### Help functions ------------------------------------------------------------
proc znc:helpfunction:generatePassword { secureityLevel passwordLength } {
	set return "" 
	if { $secureityLevel >0 } {
	set pool {"1" "2" "3" "4" "5" "6" "7" "8" "9"}
	}
	if { $secureityLevel >1 } {
	lappend pool "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"	
	}
	if { $secureityLevel >2 } {
	lappend pool "A" "B" "C" "D" "E" "F" "G" "H" "T" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
	}
	if { $secureityLevel > 3 } {
	lappend pool "%" "&" "@" "_" "-" "!" "\$" "/" "\\" "." "," ";" "#" "+" "*" "~" "?" "="
	}
	if { $secureityLevel > 4 } {
	lappend pool "ä" "ö" "ü" "Ä" "Ü" "Ö" "ß" "<" ">" "|" "á" "ú" "ó" "é" "à" "ò" "ù" "è" "€" "â" "ô" "ê" "û"
	}
	if { $pool == "" } { return }
	for { set i 1 } { $i < $passwordLength } { incr i } {
		set return [string append $return [znc:helpfunction:randelem $pool]]
	}
	return $return
}


### Helpfunction for znc:helpfunction:generatePassword
if {[catch {string append}]} then {
    rename string STRING_ORIGINAL
    proc string {cmd args} {
        switch -regexp -- $cmd {
            ^a(p(p(e(n(d)?)?)?)?)?$ {
                uplevel [list join $args {}]
            }
            default {
                if {[catch {
                    set result [uplevel [list STRING_ORIGINAL $cmd] $args]
                } err]} then {
                    return -code error\
                        [STRING_ORIGINAL map\
                             [list\
                                  STRING_ORIGINAL string\
                                  ": must be bytelength,"\
                                  ": must be append, bytelength,"]\
                             $err]
                } else {
                    set result
                }
            }
        }
    }
 }
###----------------------------------------------------------------------------
proc znc:helpfunction:randelem {list} {
    lindex $list [expr {int(rand()*[llength $list])}]
}

proc znc:helpfunction:loadModuleList { username list } {
    foreach module $list {
		znc:controlpanel:LoadModule $username $module
	}
}

proc znc:helpfunction:loadNetModuleList { username network list} {
    foreach module $list {
		znc:controlpanel:LoadNetModule $username $network $module
	}
}


proc msg:simply:sendUserRequest { username password } {
	global zncnetworkname znchost zncNonSSLPort zncSSLPort zncWebNonSSLPort zncWebSSLPort zncAdminName zncAdminMail 
	set nick [getuser $username COMMENT]
	puthelp "PRIVMSG $nick :Hey ${nick}, your ZNC account hosted by $zncnetworkname is confirmed."
	puthelp "PRIVMSG $nick :Our ZNChost is: $znchost"
	if { $zncNonSSLPort != "" } {
		puthelp "PRIVMSG $nick :To connect your IRC Client via NON-SSL connect to: ${znchost}:${zncNonSSLPort}"
	}
	if { $zncSSLPort != "" } {
		puthelp "PRIVMSG $nick :To connect your IRC Client via SSL connect to: ${znchost}:${zncSSLPort}"
	}
	puthelp "PRIVMSG $nick :Your ZNC Username is: $username"
	puthelp "PRIVMSG $nick :Your ZNC Password is: $password"
	puthelp "PRIVMSG $nick :To Connect to ZNC-Server use \"${username}:${password}\" as server-password"
	if { $zncWebNonSSLPort != "" } {
		puthelp "PRIVMSG $nick :To login via NON-SSL-Webinterface goto: http://${znchost}:${zncWebNonSSLPort}"
	}
	if { $zncWebSSLPort != "" } {
		puthelp "PRIVMSG $nick :To login via SSL-Webinterface goto: https://${znchost}:${zncWebSSLPort}"
	}
}

proc eggdrop:helpfunction:isNotZNCChannel { chan } {
	return [expr ! [channel get $chan znc]]
}

proc debug:helpfunction:test { nick host handle text } {
	puthelp "PRIVMSG $nick :Channels: [join [channels] ,]"
	puthelp "PRIVMSG $nick :[eggdrop:helpfunction:isNotZNCChannel "#ZNC" ]"
}

proc debug:helpfunction:testchan { nick host handle chan text } {
	global zncPasswordSecurityLevel zncPasswordLength
	puthelp "PRIVMSG $nick :$chan"
	puthelp "PRIVMSG $nick :[znc:helpfunction:generatePassword  $zncPasswordSecurityLevel $zncPasswordLength ]"
}

### sendTo - Functions --------------------------------------------------------
proc znc:sendTo:Controlpanel { command } {
	global zncprefix
	putquick "PRIVMSG ${zncprefix}controlpanel :$command"
}

proc znc:sendTo:blockuser { command } {
	global zncprefix
	putquick "PRIVMSG ${zncprefix}blockuser :$command"
}



### Commands - Functions ------------------------------------------------------

## Request Commands
proc znc:PUB:request {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:request $nick $host $handle $chan $text
}

proc znc:MSG:request {nick host handle text} {
	znc:request $nick $host $handle $nick $text
}

## Info Commands
proc znc:PUB:info {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:zncinfo $nick $host $handle $chan $text
}

proc znc:MSG:info {nick host handle text} {
	znc:zncinfo $nick $host $handle $nick $text
}

## Confirm Commands
proc znc:PUB:confirm {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:confirm $nick $host $handle $chan $text
}

proc znc:MSG:confirm {nick host handle text} {
	znc:confirm $nick $host $handle $nick $text
}

## Status Commands
proc znc:PUB:status {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:status $nick $host $handle $chan $text
}

proc znc:MSG:status {nick host handle text} {
	znc:status $nick $host $handle $nick $text
}

## Deny Commands
proc znc:PUB:deny {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:deny $nick $host $handle $chan $text
}

proc znc:MSG:deny {nick host handle text} {
	znc:deny $nick $host $handle $nick $text
}

## DelUser Commands
proc znc:PUB:delUser {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:delUser $nick $host $handle $chan $text
}

proc znc:MSG:delUser {nick host handle text} {
	znc:delUser $nick $host $handle $nick $text
}

## List Command
proc znc:PUB:listchoose {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	if {[string tolower [lindex $text 0]] == "members"} {
		znc:listall $nick $host $handle $chan $text
	} elseif {[string tolower [lindex $text 0]] == "pending"} {
		znc:listUnconfirmed $nick $host $handle $chan $text
	} else {
		puthelp "NOTICE $nick :Please use the help command."
	}
}

proc znc:MSG:listchoose {nick host handle text} {
	if {[string tolower [lindex $text 0]] == "members"} {
		znc:listall $nick $host $handle $nick $text
	} elseif {[string tolower [lindex $text 0]] == "pending"} {
		znc:listUnconfirmed $nick $host $handle $nick $text
	} else {
		puthelp "NOTICE $nick :Please use the help command."
	}
}

## ListUnconfirmedUsers Commands
proc znc:PUB:listUnconfirmed {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:listUnconfirmed $nick $host $handle $chan $text
}

proc znc:MSG:listUnconfirmed {nick host handle text} {
	znc:listUnconfirmed $nick $host $handle $nick $text
}

## ListAllUsers Commands
proc znc:PUB:listall {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:listall $nick $host $handle $chan $text
}

proc znc:MSG:listall {nick host handle text} {
	znc:listall $nick $host $handle $nick $text
}

## Help Commands
proc znc:PUB:help {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:help $nick $host $handle $chan $text
}

proc znc:MSG:help {nick host handle text} {
	znc:help $nick $host $handle $nick $text
}


### custom flags --------------------------------------------------------------

## ZNC Channel flag
setudef flag znc


### binds ---------------------------------------------------------------------

## public binds ---------------------------------------------------------------
bind PUB - "${scriptCommandPrefix}Request" znc:PUB:request
bind PUB - "${scriptCommandPrefix}Status" znc:PUB:status
bind PUB - "${scriptCommandPrefix}Info" znc:PUB:info
bind PUB Y "${scriptCommandPrefix}Confirm" znc:PUB:confirm
bind PUB Y "${scriptCommandPrefix}Deny" znc:PUB:deny
bind PUB Y "${scriptCommandPrefix}DelUser" znc:PUB:delUser
bind PUB Y "${scriptCommandPrefix}ListUnconfirmedUsers" znc:PUB:listUnconfirmed
bind PUB Y "${scriptCommandPrefix}List" znc:PUB:listchoose
bind PUB Y "${scriptCommandPrefix}ListAllUsers" znc:PUB:listall
bind PUB Y "${scriptCommandPrefix}LAU" znc:PUB:listall
bind PUB Y "${scriptCommandPrefix}LUU" znc:PUB:listUnconfirmed
bind PUB - "${scriptCommandPrefix}help" znc:PUB:help

## private binds --------------------------------------------------------------
bind MSG - "Request" znc:MSG:request
bind MSG - "Status" znc:MSG:status
bind MSG - "Info" znc:MSG:info
bind MSG Y "Confirm" znc:MSG:confirm
bind MSG Y "Deny" znc:MSG:deny
bind MSG Y "DelUser" znc:MSG:delUser
bind MSG Y "ListUnconfirmedUsers" znc:MSG:listUnconfirmed
bind MSG Y "ListALLUsers" znc:MSG:listall
bind MSG Y "List" znc:MSG:listchoose
bind MSG Y "LAU" znc:MSG:listall
bind MSG Y "LUU" znc:MSG:listUnconfirmed
bind MSG - "help" znc:MSG:help

## debug binds ----------------------------------------------------------------
if {$scriptdebug} {
	bind PUB n "!test" debug:helpfunction:testchan
	bind MSG n "test" debug:helpfunction:test
}


### End of Script -------------------------------------------------------------
putlog "$scriptname version $scriptversion loaded"
