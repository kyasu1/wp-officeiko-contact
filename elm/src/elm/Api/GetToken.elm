module Api.GetToken exposing (request)

import Http
import Json.Decode as Decode
import Types exposing (Token)


decodeToken : Decode.Decoder Token
decodeToken =
    Decode.field "data" <|
        (Decode.field "token" Decode.string)


endpoint : String
endpoint =
    "https://elixir.officeiko.co.jp/services/api/gettoken"


request : Http.Request Token
request =
    Http.get endpoint decodeToken
