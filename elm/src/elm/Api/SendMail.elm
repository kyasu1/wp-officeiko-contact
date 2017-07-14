module Api.SendMail exposing (send)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Types exposing (Item, Inquiry, Token, SendMailResponse(..), genderToString)


endpoint : String
endpoint =
    "https://elixir.officeiko.co.jp/services/api/sendmail"


compose : Maybe Item -> Inquiry -> Encode.Value
compose maybeItem inquiry =
    case maybeItem of
        Just item ->
            Encode.object
                [ ( "item", encodeItem item )
                , ( "inquiry", encodeInquiry inquiry )
                ]

        Nothing ->
            Encode.object
                [ ( "item", Encode.null )
                , ( "inquiry", encodeInquiry inquiry )
                ]


encodeInquiry : Inquiry -> Encode.Value
encodeInquiry inquiry =
    Encode.object
        [ ( "name", Encode.string inquiry.name )
        , ( "email", Encode.string inquiry.email )
        , ( "content", Encode.string inquiry.content )
        , ( "phone", Maybe.map (\phone -> Encode.string phone) inquiry.phone |> Maybe.withDefault Encode.null )
        , ( "gender", Maybe.map (\gender -> Encode.string (genderToString gender)) inquiry.gender |> Maybe.withDefault Encode.null )
        ]


encodeItem : Item -> Encode.Value
encodeItem (Types.Item itemID maybeItem) =
    case maybeItem of
        Just item ->
            Encode.object
                [ ( "itemID", Encode.string itemID )
                , ( "itemDetail"
                  , Encode.object
                        [ ( "auctionItemUrl", Encode.string item.auctionItemUrl )
                        , ( "title", Encode.string item.title )
                        , ( "status", Encode.string item.status )
                        , ( "price", Encode.float item.price )
                        , ( "images", Encode.list (List.map Encode.string item.images) )
                        ]
                  )
                ]

        Nothing ->
            Encode.object
                [ ( "itemID", Encode.string itemID )
                , ( "itemDetail", Encode.null )
                ]


decodeResponse : Decode.Decoder SendMailResponse
decodeResponse =
    Decode.oneOf
        [ Decode.field "data" (Decode.succeed Success)
        , Decode.field "error" (Decode.succeed Failure)
        ]


send : Maybe Item -> Inquiry -> Token -> Http.Request SendMailResponse
send maybeItem inquiry token =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = endpoint
        , body = Http.jsonBody (compose maybeItem inquiry)
        , expect = Http.expectJson decodeResponse
        , timeout = Nothing
        , withCredentials = False
        }
