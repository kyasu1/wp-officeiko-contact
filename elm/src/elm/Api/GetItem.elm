module Api.GetItem exposing (request)

import Task exposing (Task)
import Http
import Json.Decode as Decode exposing (int, string, float, list, nullable)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Types exposing (Item, ItemDetail)


decodeItem : Decode.Decoder ItemDetail
decodeItem =
    Decode.field "data"
        (decode ItemDetail
            |> required "auction_item_url" string
            |> required "title" string
            |> required "status" string
            |> required "price" float
            |> required "images" (list string)
        )


endpoint : String
endpoint =
    "https://elixir.officeiko.co.jp/services/api/getitem"


request : String -> Http.Request ItemDetail
request auctionId =
    Http.get (endpoint ++ "?auction_id=" ++ auctionId) decodeItem
