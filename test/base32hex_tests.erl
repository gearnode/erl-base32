%% Copyright (c) 2021 Bryan Frimin <bryan@frimin.fr>.
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
%% SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
%% IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(base32hex_tests).

-include_lib("eunit/include/eunit.hrl").

encode_test_() ->
  [?_assertEqual(<<>>,
                 base32hex:encode(<<>>)),
   ?_assertEqual(<<"CO======">>,
                 base32hex:encode(<<"f">>)),
   ?_assertEqual(<<"CPNG====">>,
                 base32hex:encode(<<"fo">>)),
   ?_assertEqual(<<"CPNMU===">>,
                 base32hex:encode(<<"foo">>)),
   ?_assertEqual(<<"CPNMUOG=">>,
                 base32hex:encode(<<"foob">>)),
   ?_assertEqual(<<"CPNMUOJ1">>,
                 base32hex:encode(<<"fooba">>)),
   ?_assertEqual(<<"CPNMUOJ1E8======">>,
                 base32hex:encode(<<"foobar">>))].

decode_test_() ->
  [?_assertEqual({ok, <<>>},
                 base32hex:decode(<<"">>)),
   ?_assertEqual({ok, <<"f">>},
                 base32hex:decode(<<"CO======">>)),
   ?_assertEqual({ok, <<"fo">>},
                 base32hex:decode(<<"CPNG====">>)),
   ?_assertEqual({ok, <<"foo">>},
                 base32hex:decode(<<"CPNMU===">>)),
   ?_assertEqual({ok, <<"foob">>},
                 base32hex:decode(<<"CPNMUOG=">>)),
   ?_assertEqual({ok, <<"fooba">>},
                 base32hex:decode(<<"CPNMUOJ1">>)),
   ?_assertEqual({ok, <<"foobar">>},
                 base32hex:decode(<<"CPNMUOJ1E8======">>))].
