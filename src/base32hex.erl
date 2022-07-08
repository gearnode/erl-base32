%% Copyright (c) 2022 Bryan Frimin <bryan@frimin.fr>.
%% Copyright (c) 2021 Exograd SAS.
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

-module(base32hex).

-export([encode/1, encode/2,
         decode/1]).

-spec encode(binary()) -> binary().
encode(Bin) when is_binary(Bin) ->
  encode(Bin, []).

-spec encode(binary(), Options) -> binary()
          when Options :: [Option],
               Option :: nopad.
encode(Bin, Options) when is_binary(Bin), is_list(Options) ->
  case proplists:get_bool(nopad, Options) of
    true ->
      encode(nopad, Bin, <<>>);
    false ->
      encode(pad, Bin, <<>>)
  end.

-spec encode(nopad | pad, binary(), binary()) -> binary().
encode(_, <<>>, Acc) ->
  Acc;
encode(Mode, <<A0:5, B0:5, C0:5, D0:5, E0:5, F0:5, G0:5, H0:5, Rest/binary>>,
       Acc) ->
  A = enc_b32hex_digit(A0),
  B = enc_b32hex_digit(B0),
  C = enc_b32hex_digit(C0),
  D = enc_b32hex_digit(D0),
  E = enc_b32hex_digit(E0),
  F = enc_b32hex_digit(F0),
  G = enc_b32hex_digit(G0),
  H = enc_b32hex_digit(H0),
  encode(Mode, Rest, <<Acc/binary, A, B, C, D, E, F, G, H>>);
encode(Mode, <<A0:5, B0:5, C0:5, D0:5, E0:5, F0:5, G0:2>>, Acc) ->
  A = enc_b32hex_digit(A0),
  B = enc_b32hex_digit(B0),
  C = enc_b32hex_digit(C0),
  D = enc_b32hex_digit(D0),
  E = enc_b32hex_digit(E0),
  F = enc_b32hex_digit(F0),
  G = enc_b32hex_digit(G0 bsl 3),
  case Mode of
    pad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, C, D, E, F, G, $=>>);
    nopad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, C, D, E, F, G>>)
  end;
encode(Mode, <<A0:5, B0:5, C0:5, D0:5, E0:4>>, Acc) ->
  A = enc_b32hex_digit(A0),
  B = enc_b32hex_digit(B0),
  C = enc_b32hex_digit(C0),
  D = enc_b32hex_digit(D0),
  E = enc_b32hex_digit(E0 bsl 1),
  case Mode of
    pad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, C, D, E, $=, $=, $=>>);
    nopad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, C, D, E>>)
  end;
encode(Mode, <<A0:5, B0:5, C0:5, D0:1>>, Acc) ->
  A = enc_b32hex_digit(A0),
  B = enc_b32hex_digit(B0),
  C = enc_b32hex_digit(C0),
  D = enc_b32hex_digit(D0 bsl 4),
  case Mode of
    pad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, C, D, $=, $=, $=, $=>>);
    nopad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, C, D>>)
  end;
encode(Mode, <<A0:5, B0:3>>, Acc) ->
  A = enc_b32hex_digit(A0),
  B = enc_b32hex_digit(B0 bsl 2),
  case Mode of
    pad ->
      encode(Mode, <<>>, <<Acc/binary, A, B, $=, $=, $=, $=, $=, $=>>);
    nopad ->
      encode(Mode, <<>>, <<Acc/binary, A, B>>)
  end.

-spec enc_b32hex_digit(0..31) -> $0..$9 | $A..$V.
enc_b32hex_digit(Digit) when Digit =< 9 ->
  Digit + 48;
enc_b32hex_digit(Digit) when Digit =< 31 ->
  Digit + 55.

-spec decode(binary()) ->
        {ok, binary()} | {error, Reason}
          when Reason :: {invalid_base32hex, binary()}
                       | {invalid_base32hex, {unexpected_char, binary()}}.
decode(Bin) ->
  try
    {ok, decode(Bin, <<>>)}
  catch
    throw:{error, Reason} ->
      {error, Reason}
  end.

-spec decode(binary(), binary()) -> binary().
decode(<<>>, Acc) ->
  Acc;
decode(<<A0:8, B0:8, $=, $=, $=, $=, $=, $=>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0) bsr 2,
  decode(<<>>, <<Acc/binary, A:5, B:3>>);
decode(<<A0:8, B0:8, C0:8, D0:8, $=, $=, $=, $=>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0) bsr 4,
  decode(<<>>, <<Acc/binary, A:5, B:5, C:5, D:1>>);
decode(<<A0:8, B0:8, C0:8, D0:8, E0:8, $=, $=, $=>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0),
  E = dec_b32hex_char(E0) bsr 1,
  decode(<<>>, <<Acc/binary, A:5, B:5, C:5, D:5, E:4>>);
decode(<<A0:8, B0:8, C0:8, D0:8, E0:8, F0:8, G0:8, $=>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0),
  E = dec_b32hex_char(E0),
  F = dec_b32hex_char(F0),
  G = dec_b32hex_char(G0) bsr 3,
  decode(<<>>, <<Acc/binary, A:5, B:5, C:5, D:5, E:5, F:5, G:2>>);
decode(<<A0:8, B0:8, C0:8, D0:8, E0:8, F0:8, G0:8>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0),
  E = dec_b32hex_char(E0),
  F = dec_b32hex_char(F0),
  G = dec_b32hex_char(G0) bsr 3,
  decode(<<>>, <<Acc/binary, A:5, B:5, C:5, D:5, E:5, F:5, G:2>>);
decode(<<A0:8, B0:8, C0:8, D0:8, E0:8>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0),
  E = dec_b32hex_char(E0) bsr 1,
  decode(<<>>, <<Acc/binary, A:5, B:5, C:5, D:5, E:4>>);
decode(<<A0:8, B0:8, C0:8, D0:8>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0) bsr 4,
  decode(<<>>, <<Acc/binary, A:5, B:5, C:5, D:1>>);
decode(<<A0:8, B0:8>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0) bsr 2,
  decode(<<>>, <<Acc/binary, A:5, B:3>>);
decode(<<A0:8, B0:8, C0:8, D0:8, E0:8, F0:8, G0:8, H0:8, Rest/binary>>, Acc) ->
  A = dec_b32hex_char(A0),
  B = dec_b32hex_char(B0),
  C = dec_b32hex_char(C0),
  D = dec_b32hex_char(D0),
  E = dec_b32hex_char(E0),
  F = dec_b32hex_char(F0),
  G = dec_b32hex_char(G0),
  H = dec_b32hex_char(H0),
  decode(Rest, <<Acc/binary, A:5, B:5, C:5, D:5, E:5, F:5, G:5, H:5>>);
decode(Bin, _) ->
  throw({error, {invalid_base32hex, Bin}}).

-spec dec_b32hex_char($0..$9 | $A..$V) -> 0..31.
dec_b32hex_char(Char) when Char >= $0, Char =< $9 ->
  Char - 48;
dec_b32hex_char(Char) when Char >= $A, Char =< $V ->
  Char - 55;
dec_b32hex_char(Char) ->
  throw({error, {invalid_base32hex, {unexpected_char, <<Char>>}}}).
