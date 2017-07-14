module Types exposing (..)

import Time exposing (Time)
import Json.Decode as Decode
import Json.Encode as Encode


type alias Taco =
    { currentTime : Time
    , item : Maybe Item
    , token : Token
    }


type TacoUpdate
    = NoUpdate
    | UpdateTime Time
    | UpdateItem (Maybe Item)


type Item
    = Item String (Maybe ItemDetail)


type alias ItemDetail =
    { auctionItemUrl : String
    , title : String
    , status : String
    , price : Float
    , images : List String
    }


getItemUrl : Item -> Maybe String
getItemUrl (Item itemID maybeItemDetail) =
    maybeItemDetail
        |> Maybe.map (\itemDetail -> itemDetail.auctionItemUrl)


type alias Inquiry =
    { name : String
    , content : String
    , email : String
    , emailConfirmation : String
    , phone : Maybe String
    , gender : Maybe Gender
    }


{-| Gender
-}
type Gender
    = Male
    | Female


encodeGender : Gender -> Encode.Value
encodeGender =
    Encode.string << genderToString


decodeGender : Decode.Decoder Gender
decodeGender =
    Decode.oneOf
        [ (Decode.field "男性" (Decode.succeed Male))
        , (Decode.field "女性" (Decode.succeed Female))
        ]


genderToString : Gender -> String
genderToString gender =
    case gender of
        Male ->
            "男性"

        Female ->
            "女性"


type alias Token =
    String


type SendMailResponse
    = Success
    | Failure
