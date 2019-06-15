#pragma semicolon 1
#define DEBUG
#define PLUGIN_AUTHOR "lazhoroni"
#define PLUGIN_VERSION "1.00"
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <warden>
EngineVersion g_Game;
public Plugin myinfo = 
{
	name = "Komutçu Değiş Kal !gectim",
	author = PLUGIN_AUTHOR,
	description = "Komutcu olan !gectim yazar. 30 dakika sonra komdk oylamasi baslatilir.",
	version = PLUGIN_VERSION,
	url = "https://not2easy.pro/forums/"
};
public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	RegConsoleCmd("sm_gectim", GECTIM);
}
public Action GECTIM(int client, int args)
{
	if(IsClientInGame(client) && warden_iswarden(client))
	{
		PrintToChatAll("\x02[not2easy]\x10 30 dakika \x04sonra komdk yapılacaktır.");
		CreateTimer(1800.0, GECTIMTIMER);
		return Plugin_Handled;
	}
	else
	{
		PrintToChat(client, "\x02[not2easy] \x04Bu komutu kullanabilmek için komutçu olmalısınız.");
		return Plugin_Handled;
	}
}
public Action GECTIMTIMER(Handle timer, any data)
{
	DoVoteMenu();
}
public int Handle_VoteMenu(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_VoteEnd)
	{
		if (param1 == 0)
		{
			for(int i=1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && warden_iswarden(i))
				{
					PrintToChatAll("\x02[not2easy]\x10 %N \x04adlı kişi komutçuluktan çıkarılmıştır.", i);
					warden_remove(i);
				}
			}
		}
		else if (param1 == 1)
		{
			delete menu;
			for(int i=1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && warden_iswarden(i))
				{
					PrintToChatAll("\x02[not2easy]\x10 %N \x04adlı kişi komutçuluğa devam edecektir.", i);
					PrintToChat(i, "\x02[not2easy]\x04 Lütfen tekrar \x10!gectim \x04yazınız.");
				}
			}
		}
	}
}
void DoVoteMenu()
{
	if (IsVoteInProgress())
	{
		return;
	}
	Menu menu = new Menu(Handle_VoteMenu);
	for( int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && warden_iswarden(i))
		{
			menu.SetTitle("%N adlı komutçu değişsin mi?", i);
		}
	}
	menu.AddItem("yes", "Evet");
	menu.AddItem("no", "Hayır");
	menu.ExitButton = false;
	menu.DisplayVoteToAll(20);
}