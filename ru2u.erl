%% coding: utf-8
% ru2u, Resolver U2U (Username / UUID) by tHEMtZ
-module(ru2u).
-export([n2u/1, u2n/1, uf/1]).

n2u(Name) -> % Username to UUID
	application:start(inets),
	application:start(crypto),
	application:start(asn1),
	application:start(public_key),
	application:start(ssl),
	[{_, {_, [_, _, _, _, _, _, _], Result}}] = [httpc:request(post, {"https://api.mojang.com/profiles/page/1", [], "application/json", "{\"name\":\""++Name++"\",\"agent\":\"minecraft\"}"}, [{ssl, [{verify, 0}]}], [])],
	string:substr(Result, 21, 32).
u2n(Uuid) -> % UUID to Username
	application:start(inets),
	application:start(crypto),
	application:start(asn1),
	application:start(public_key),
	application:start(ssl),
	[{_, {_, [_, _, _, _, _, _, _], Result}}] = [httpc:request(get, {"https://sessionserver.mojang.com/session/minecraft/profile/"++string:join(string:tokens(Uuid, "-"), ""), []}, [{ssl, [{verify, 0}]}], [])],
	string:sub_word(string:substr(Result, 50, 16), 1, $\").
uf(Tbsuuid) -> % Format UUID
	CountHyphen = string:words(Tbsuuid, $-),
	if CountHyphen<2 ->
		string:substr(Tbsuuid, 1, 8)++"-"++string:substr(Tbsuuid, 9, 4)++"-"++string:substr(Tbsuuid, 13, 4)++"-"++string:substr(Tbsuuid, 17, 4)++"-"++string:substr(Tbsuuid, 21);
	true ->
		string:join(string:tokens(Tbsuuid, "-"), "")
	end.
