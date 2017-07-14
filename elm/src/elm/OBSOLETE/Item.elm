module Item exposing (requestItem, fromXML)

import Task exposing (Task)
import Http
import Json.Decode as Decode
import Xml exposing (Value(..))
import Xml.Decode exposing (..)
import Xml.Query exposing (..)
import Types exposing (Item, ItemDetail)


{-|
  https://ellie-app.com/Tp8rvZmhbta1/2
-}
decodeImage1 : Value -> Result String String
decodeImage1 value =
    Result.map (\a -> a)
        (tag "Image1" string value)


parseItem : Value -> Result String ItemDetail
parseItem value =
    Result.map5 ItemDetail
        (tag "AuctionItemUrl" string value)
        (tag "Title" string value)
        (tag "Status" string value)
        (tag "Price" float value)
        (tag "Img" decodeImage1 value)


parseResult : Value -> Result String ItemDetail
parseResult value =
    Result.map
        (\r -> r)
        (tag "Result" parseItem value)


fromXML : String -> Maybe ItemDetail
fromXML body =
    decode body
        |> Result.andThen (tag "ResultSet" parseResult)
        |> Result.toMaybe


endpointYahoo : String
endpointYahoo =
    "https://auctions.yahooapis.jp/AuctionWebService/V2/auctionItem"


appId : String
appId =
    "dj0zaiZpPUxDTXBSUWdTNjNqOSZzPWNvbnN1bWVyc2VjcmV0Jng9ZWE-"


{-| request XML data to yahoo auction api with specific auctionID
-}
requestItem : String -> Http.Request String
requestItem itemID =
    Http.getString (endpointYahoo ++ "?appid=" ++ appId ++ "&auctionID=" ++ itemID)
