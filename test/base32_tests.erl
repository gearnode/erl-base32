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

-module(base32_tests).

-include_lib("eunit/include/eunit.hrl").

encode_test_() ->
  [?_assertEqual(<<>>,
                 base32:encode(<<>>)),
   ?_assertEqual(<<"MY======">>,
                 base32:encode(<<"f">>)),
   ?_assertEqual(<<"MZXQ====">>,
                 base32:encode(<<"fo">>)),
   ?_assertEqual(<<"MZXW6===">>,
                 base32:encode(<<"foo">>)),
   ?_assertEqual(<<"MZXW6YQ=">>,
                 base32:encode(<<"foob">>)),
   ?_assertEqual(<<"MZXW6YTB">>,
                 base32:encode(<<"fooba">>)),
   ?_assertEqual(<<"MZXW6YTBOI======">>,
                 base32:encode(<<"foobar">>))].
                 
decode_test_() ->
  [?_assertEqual(<<>>,
                 base32:decode(<<>>)),
   ?_assertEqual(<<"f">>,
                 base32:decode(<<"MY======">>)),
   ?_assertEqual(<<"fo">>,
                 base32:decode(<<"MZXQ====">>)),
   ?_assertEqual(<<"foo">>,
                 base32:decode(<<"MZXW6===">>)),
   ?_assertEqual(<<"foob">>,
                 base32:decode(<<"MZXW6YQ=">>)),
   ?_assertEqual(<<"fooba">>,
                 base32:decode(<<"MZXW6YTB">>)),
   ?_assertEqual(<<"foobar">>,
                 base32:decode(<<"MZXW6YTBOI======">>))].
