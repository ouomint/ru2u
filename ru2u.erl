%% coding: utf-8
% ru2u, Resolver U2U (Username / UUID) by tHEMtZ
-module(ru2u).
-export([rh/1, sh/1, uf/1, n2u/1, u2n/1]).

rh(UuidWithHyphen) -> % Remove Hyphen
	string:join(string:tokens(UuidWithHyphen, "-"), "").
sh(UuidWithoutHyphen) -> % Separate with Hyphen
	CountHyphen = string:words(UuidWithoutHyphen, $-),
	if CountHyphen<2 ->
		string:substr(UuidWithoutHyphen, 1, 8)++"-"++string:substr(UuidWithoutHyphen, 9, 4)++"-"++string:substr(UuidWithoutHyphen, 13, 4)++"-"++string:substr(UuidWithoutHyphen, 17, 4)++"-"++string:substr(UuidWithoutHyphen, 21);
	true ->
		UuidWithoutHyphen
	end.
uf(TbsUuid) -> % Format UUID
	CountHyphen = string:words(TbsUuid, $-),
	if CountHyphen<2 ->
		sh(TbsUuid);
	true ->
		rh(TbsUuid)
	end.
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
	[{_, {_, [_, _, _, _, _, _, _], Result}}] = [httpc:request(get, {"https://sessionserver.mojang.com/session/minecraft/profile/"++rh(Uuid), []}, [{ssl, [{verify, 0}]}], [])],
	Return = string:sub_word(string:substr(Result, 50, 16), 1, $\"),
	if Return == ":" ->
		{fail, Uuid};
	true ->
		Return
	end.
